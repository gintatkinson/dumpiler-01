//! Symbol table and scope resolution for SysML v2 / KerML models.

use deap_core::sysml_ast::*;
use std::collections::BTreeMap;

/// Classification of SysML v2 entities in the symbol table.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum SymbolKind {
    Package,
    Part,
    Port,
    Attribute,
    Action,
    Operation,
    Constraint,
    Requirement,
    State,
    Transition,
    Connection,
    Item,
    Hazard,
    Risk,
    UseCase,
    TestCase,
    Capability,
    Interaction,
}

/// A resolved symbol entry in the symbol table.
#[derive(Debug, Clone, PartialEq)]
pub struct Symbol {
    pub name: String,
    pub qualified_name: String,
    pub kind: SymbolKind,
    pub parent: Option<String>,
    pub type_name: Option<String>,
    pub direction: Option<String>,
    pub is_conjugated: bool,
    pub doc: Option<String>,
}

/// Symbol table providing scope resolution and entity lookup.
#[derive(Debug, Clone, Default)]
pub struct SymbolTable {
    /// Qualified name -> Symbol (e.g., "Package::Part::Port")
    pub symbols: BTreeMap<String, Symbol>,
    /// Unqualified name -> List of qualified names
    pub by_name: BTreeMap<String, Vec<String>>,
}

impl SymbolTable {
    pub fn new() -> Self {
        Self::default()
    }

    /// Build a comprehensive symbol table from a PackageDef hierarchy.
    pub fn build_from_package(pkg: &PackageDef) -> Self {
        let mut table = Self::new();
        table.index_package(pkg, "");
        table
    }

    /// Look up a symbol by exact qualified name.
    pub fn lookup(&self, qualified_name: &str) -> Option<&Symbol> {
        self.symbols.get(qualified_name)
    }

    /// Look up a symbol within a given parent scope or fall back to global scope.
    pub fn lookup_in_scope(&self, scope: &str, name: &str) -> Option<&Symbol> {
        if name.contains("::") {
            return self.lookup(name);
        }

        if !scope.is_empty() {
            let scoped_name = format!("{}::{}", scope, name);
            if let Some(sym) = self.symbols.get(&scoped_name) {
                return Some(sym);
            }
        }

        // Try direct name
        if let Some(sym) = self.symbols.get(name) {
            return Some(sym);
        }

        // Search by unqualified name
        if let Some(qnames) = self.by_name.get(name) {
            if let Some(first) = qnames.first() {
                return self.symbols.get(first);
            }
        }

        None
    }

    /// Look up a port on a part given "PartName.portName" or in a specific part scope.
    pub fn lookup_port(&self, port_ref: &str, current_part: Option<&str>) -> Option<&Symbol> {
        if port_ref.contains('.') {
            let parts: Vec<&str> = port_ref.split('.').collect();
            if parts.len() == 2 {
                let part_name = parts[0];
                let port_name = parts[1];

                // Find candidate part
                if let Some(part_qnames) = self.by_name.get(part_name) {
                    for part_q in part_qnames {
                        let candidate_port_q = format!("{}::{}", part_q, port_name);
                        if let Some(sym) = self.symbols.get(&candidate_port_q) {
                            if sym.kind == SymbolKind::Port {
                                return Some(sym);
                            }
                        }
                    }
                }
            }
        } else if let Some(part) = current_part {
            let candidate_q = format!("{}::{}", part, port_ref);
            if let Some(sym) = self.symbols.get(&candidate_q) {
                if sym.kind == SymbolKind::Port {
                    return Some(sym);
                }
            }
        }

        // Fall back to unqualified search
        if let Some(port_qnames) = self.by_name.get(port_ref) {
            for q in port_qnames {
                if let Some(sym) = self.symbols.get(q) {
                    if sym.kind == SymbolKind::Port {
                        return Some(sym);
                    }
                }
            }
        }

        None
    }

    /// Get all symbols of a specific kind.
    pub fn all_of_kind(&self, kind: SymbolKind) -> Vec<&Symbol> {
        self.symbols.values().filter(|s| s.kind == kind).collect()
    }

    fn insert(&mut self, symbol: Symbol) {
        self.by_name
            .entry(symbol.name.clone())
            .or_default()
            .push(symbol.qualified_name.clone());
        self.symbols.insert(symbol.qualified_name.clone(), symbol);
    }

    fn index_package(&mut self, pkg: &PackageDef, parent_scope: &str) {
        let pkg_qname = if parent_scope.is_empty() {
            pkg.name.clone()
        } else {
            format!("{}::{}", parent_scope, pkg.name)
        };

        self.insert(Symbol {
            name: pkg.name.clone(),
            qualified_name: pkg_qname.clone(),
            kind: SymbolKind::Package,
            parent: if parent_scope.is_empty() {
                None
            } else {
                Some(parent_scope.to_string())
            },
            type_name: None,
            direction: None,
            is_conjugated: false,
            doc: pkg.doc.clone(),
        });

        for attr in &pkg.attribute_defs {
            self.insert(Symbol {
                name: attr.name.clone(),
                qualified_name: format!("{}::{}", pkg_qname, attr.name),
                kind: SymbolKind::Attribute,
                parent: Some(pkg_qname.clone()),
                type_name: Some(attr.type_name.clone()),
                direction: None,
                is_conjugated: false,
                doc: attr.doc.clone(),
            });
        }

        for port in &pkg.port_defs {
            self.insert(Symbol {
                name: port.name.clone(),
                qualified_name: format!("{}::{}", pkg_qname, port.name),
                kind: SymbolKind::Port,
                parent: Some(pkg_qname.clone()),
                type_name: Some(port.type_name.clone()),
                direction: Some(port.direction.clone()),
                is_conjugated: port.is_conjugated,
                doc: port.doc.clone(),
            });
        }

        for act in &pkg.action_defs {
            self.insert(Symbol {
                name: act.name.clone(),
                qualified_name: format!("{}::{}", pkg_qname, act.name),
                kind: SymbolKind::Action,
                parent: Some(pkg_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: act.doc.clone(),
            });
        }

        for con in &pkg.constraint_defs {
            self.insert(Symbol {
                name: con.name.clone(),
                qualified_name: format!("{}::{}", pkg_qname, con.name),
                kind: SymbolKind::Constraint,
                parent: Some(pkg_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: con.doc.clone(),
            });
        }

        for req in &pkg.requirement_defs {
            self.insert(Symbol {
                name: req.name.clone(),
                qualified_name: format!("{}::{}", pkg_qname, req.name),
                kind: SymbolKind::Requirement,
                parent: Some(pkg_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: req.doc.clone(),
            });
        }

        for state in &pkg.state_defs {
            self.insert(Symbol {
                name: state.name.clone(),
                qualified_name: format!("{}::{}", pkg_qname, state.name),
                kind: SymbolKind::State,
                parent: Some(pkg_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: state.doc.clone(),
            });
        }

        for conn in &pkg.connection_defs {
            self.insert(Symbol {
                name: conn.name.clone(),
                qualified_name: format!("{}::{}", pkg_qname, conn.name),
                kind: SymbolKind::Connection,
                parent: Some(pkg_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: conn.doc.clone(),
            });
        }

        for hz in &pkg.hazard_defs {
            self.insert(Symbol {
                name: hz.name.clone(),
                qualified_name: format!("{}::{}", pkg_qname, hz.name),
                kind: SymbolKind::Hazard,
                parent: Some(pkg_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: hz.doc.clone(),
            });
        }

        for rk in &pkg.risk_defs {
            self.insert(Symbol {
                name: rk.name.clone(),
                qualified_name: format!("{}::{}", pkg_qname, rk.name),
                kind: SymbolKind::Risk,
                parent: Some(pkg_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: rk.doc.clone(),
            });
        }

        for part in &pkg.part_defs {
            self.index_part(part, &pkg_qname);
        }

        for subpkg in &pkg.packages {
            self.index_package(subpkg, &pkg_qname);
        }
    }

    fn index_part(&mut self, part: &PartDef, parent_scope: &str) {
        let part_qname = format!("{}::{}", parent_scope, part.name);

        self.insert(Symbol {
            name: part.name.clone(),
            qualified_name: part_qname.clone(),
            kind: SymbolKind::Part,
            parent: Some(parent_scope.to_string()),
            type_name: part.type_name.clone(),
            direction: None,
            is_conjugated: false,
            doc: part.doc.clone(),
        });

        for attr in &part.attributes {
            self.insert(Symbol {
                name: attr.name.clone(),
                qualified_name: format!("{}::{}", part_qname, attr.name),
                kind: SymbolKind::Attribute,
                parent: Some(part_qname.clone()),
                type_name: Some(attr.type_name.clone()),
                direction: None,
                is_conjugated: false,
                doc: attr.doc.clone(),
            });
        }

        for port in &part.ports {
            self.insert(Symbol {
                name: port.name.clone(),
                qualified_name: format!("{}::{}", part_qname, port.name),
                kind: SymbolKind::Port,
                parent: Some(part_qname.clone()),
                type_name: Some(port.type_name.clone()),
                direction: Some(port.direction.clone()),
                is_conjugated: port.is_conjugated,
                doc: port.doc.clone(),
            });
        }

        for act in &part.actions {
            self.insert(Symbol {
                name: act.name.clone(),
                qualified_name: format!("{}::{}", part_qname, act.name),
                kind: SymbolKind::Action,
                parent: Some(part_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: act.doc.clone(),
            });
        }

        for con in &part.constraints {
            self.insert(Symbol {
                name: con.name.clone(),
                qualified_name: format!("{}::{}", part_qname, con.name),
                kind: SymbolKind::Constraint,
                parent: Some(part_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: con.doc.clone(),
            });
        }

        for req in &part.requirements {
            self.insert(Symbol {
                name: req.name.clone(),
                qualified_name: format!("{}::{}", part_qname, req.name),
                kind: SymbolKind::Requirement,
                parent: Some(part_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: req.doc.clone(),
            });
        }

        for state in &part.states {
            self.insert(Symbol {
                name: state.name.clone(),
                qualified_name: format!("{}::{}", part_qname, state.name),
                kind: SymbolKind::State,
                parent: Some(part_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: state.doc.clone(),
            });
        }

        for conn in &part.connections {
            self.insert(Symbol {
                name: conn.name.clone(),
                qualified_name: format!("{}::{}", part_qname, conn.name),
                kind: SymbolKind::Connection,
                parent: Some(part_qname.clone()),
                type_name: None,
                direction: None,
                is_conjugated: false,
                doc: conn.doc.clone(),
            });
        }

        for subpart in &part.parts {
            self.index_part(subpart, &part_qname);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_symbol_table_indexing_and_lookup() {
        let pkg = PackageDef {
            name: "Vehicle_SSOT".to_string(),
            part_defs: vec![
                PartDef {
                    name: "FlightComputer".to_string(),
                    ports: vec![
                        PortDef {
                            name: "bus_out".to_string(),
                            type_name: "CANBus".to_string(),
                            direction: "out".to_string(),
                            is_conjugated: false,
                            ..Default::default()
                        },
                    ],
                    ..Default::default()
                },
                PartDef {
                    name: "Actuator".to_string(),
                    ports: vec![
                        PortDef {
                            name: "bus_in".to_string(),
                            type_name: "CANBus".to_string(),
                            direction: "in".to_string(),
                            is_conjugated: false,
                            ..Default::default()
                        },
                    ],
                    ..Default::default()
                },
            ],
            ..Default::default()
        };

        let table = SymbolTable::build_from_package(&pkg);
        assert!(table.lookup("Vehicle_SSOT::FlightComputer").is_some());
        assert!(table.lookup("Vehicle_SSOT::FlightComputer::bus_out").is_some());

        let port_sym = table.lookup_port("FlightComputer.bus_out", None).unwrap();
        assert_eq!(port_sym.name, "bus_out");
        assert_eq!(port_sym.direction.as_deref(), Some("out"));
    }
}
