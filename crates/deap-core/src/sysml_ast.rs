//! AST structures for SysML v2 entities, requirements, and system architecture.

use regex::Regex;
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;

fn default_true() -> bool {
    true
}

fn default_one() -> i32 {
    1
}

/// Represents an attribute definition or instance in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct AttributeDef {
    pub name: String,
    #[serde(default)]
    pub type_name: String,
    pub default_value: Option<String>,
    pub doc: Option<String>,
}

/// Represents an item flow or discrete data flow definition in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct FlowDef {
    pub name: String,
    #[serde(default = "default_direction_out")]
    pub direction: String,
    #[serde(default = "default_item_type")]
    pub item_type: String,
    pub doc: Option<String>,
    pub rate_hz: Option<f64>,
    pub unit: Option<String>,
    pub valid_range: Option<String>,
    pub default_value: Option<String>,
}

fn default_direction_out() -> String {
    "out".to_string()
}

fn default_item_type() -> String {
    "Item".to_string()
}

/// Represents a port definition or interface point in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct PortDef {
    pub name: String,
    pub type_name: String,
    #[serde(default = "default_direction_inout")]
    pub direction: String,
    #[serde(default)]
    pub is_conjugated: bool,
    pub doc: Option<String>,
    #[serde(default = "default_port_category")]
    pub port_category: String,
    #[serde(default)]
    pub protocol_family: String,
    #[serde(default)]
    pub electrical_attributes: BTreeMap<String, String>,
    #[serde(default)]
    pub item_flows: Vec<FlowDef>,
}

fn default_direction_inout() -> String {
    "inout".to_string()
}

fn default_port_category() -> String {
    "DataPort".to_string()
}

/// Represents an action definition in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct ActionDef {
    pub name: String,
    pub doc: Option<String>,
    #[serde(default)]
    pub in_params: Vec<AttributeDef>,
    #[serde(default)]
    pub out_params: Vec<AttributeDef>,
    #[serde(default)]
    pub parameters: Vec<AttributeDef>,
    pub performer: Option<String>,
    #[serde(default)]
    pub steps: Vec<String>,
    #[serde(default = "default_true")]
    pub is_def: bool,
}

impl Default for ActionDef {
    fn default() -> Self {
        Self {
            name: String::new(),
            doc: None,
            in_params: Vec::new(),
            out_params: Vec::new(),
            parameters: Vec::new(),
            performer: None,
            steps: Vec::new(),
            is_def: true,
        }
    }
}

/// Represents an operation definition with typed signature in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct OperationDef {
    pub name: String,
    #[serde(default = "default_direction_inout")]
    pub direction: String,
    #[serde(default)]
    pub param_type: String,
    pub return_type: Option<String>,
    pub doc: Option<String>,
    #[serde(default)]
    pub parameters: Vec<AttributeDef>,
}

/// Represents a subsystem capability specification in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct CapabilityDef {
    pub name: String,
    pub description: Option<String>,
    pub subsystem: Option<String>,
    pub package_ref: Option<String>,
    pub doc: Option<String>,
}

/// Represents an interaction sequence in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct InteractionDef {
    pub name: String,
    #[serde(default)]
    pub lifelines: Vec<String>,
    #[serde(default)]
    pub messages: Vec<String>,
    #[serde(default)]
    pub triggers: Vec<String>,
    pub doc: Option<String>,
}

/// Represents a formal constraint definition, invariant, or assertion in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct ConstraintDef {
    pub name: String,
    pub expression: String,
    #[serde(default)]
    pub parameters: Vec<String>,
    #[serde(default)]
    pub is_assertion: bool,
    pub doc: Option<String>,
    #[serde(default)]
    pub pre_conditions: Vec<String>,
    #[serde(default)]
    pub post_conditions: Vec<String>,
}

/// Represents a verification test case definition in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct TestCaseDef {
    pub name: String,
    pub subject_part: Option<String>,
    #[serde(default)]
    pub verified_requirements: Vec<String>,
    pub objective: Option<String>,
    #[serde(default)]
    pub test_steps: Vec<String>,
    pub doc: Option<String>,
}

/// Represents a requirement definition in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct RequirementDef {
    pub name: String,
    pub req_id: String,
    pub text: String,
    pub doc: Option<String>,
    #[serde(default)]
    pub assumes: Vec<String>,
    #[serde(default)]
    pub requires: Vec<String>,
    #[serde(default)]
    pub verified_by: Vec<String>,
    #[serde(default)]
    pub satisfied_by: Vec<String>,
}

/// Represents a state transition in a SysML v2 state machine.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct TransitionDef {
    pub name: Option<String>,
    pub source: Option<String>,
    pub target: Option<String>,
    pub trigger: Option<String>,
    pub guard: Option<String>,
    pub effect: Option<String>,
    pub doc: Option<String>,
}

/// Represents a state machine state definition in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct StateDef {
    pub name: String,
    pub doc: Option<String>,
    pub entry_action: Option<String>,
    pub do_action: Option<String>,
    pub exit_action: Option<String>,
    #[serde(default)]
    pub transitions: Vec<TransitionDef>,
    #[serde(default)]
    pub sub_states: Vec<StateDef>,
}

/// Represents a use case definition in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct UseCaseDef {
    pub name: String,
    pub doc: Option<String>,
    pub subject: Option<String>,
    pub actor: Option<String>,
    #[serde(default)]
    pub actors: Vec<String>,
    pub objective: Option<String>,
    #[serde(default)]
    pub includes: Vec<String>,
    #[serde(default)]
    pub extends: Vec<String>,
    #[serde(default)]
    pub steps: Vec<String>,
    #[serde(default)]
    pub preconditions: Vec<String>,
    #[serde(default)]
    pub postconditions: Vec<String>,
}

/// Represents a data payload or item definition in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct ItemDef {
    pub name: String,
    pub doc: Option<String>,
    #[serde(default)]
    pub attributes: Vec<AttributeDef>,
}

/// Represents a safety hazard definition in SysML v2 / STPA models.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct HazardDef {
    pub name: String,
    pub doc: Option<String>,
    #[serde(default = "default_one")]
    pub severity: i32,
    pub source_port: Option<String>,
    pub target_port: Option<String>,
    pub part_ref: Option<String>,
}

/// Represents a safety risk definition in SysML v2 / STPA models.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct RiskDef {
    pub name: String,
    pub doc: Option<String>,
    #[serde(default = "default_one")]
    pub severity: i32,
    pub hazard_ref: Option<String>,
    pub source_port: Option<String>,
    pub target_port: Option<String>,
}

/// Represents a connection or topological flow link between ports in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct ConnectionDef {
    pub name: String,
    pub source_port: String,
    pub target_port: String,
    pub source_part: Option<String>,
    pub target_part: Option<String>,
    pub doc: Option<String>,
    #[serde(default = "default_one")]
    pub severity: i32,
    pub item_flow_ref: Option<String>,
    pub protocol: Option<String>,
    pub latency_ms: Option<f64>,
    #[serde(default)]
    pub is_flow: bool,
}

/// Represents a structural part definition or block in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct PartDef {
    pub name: String,
    pub doc: Option<String>,
    #[serde(default = "default_true")]
    pub is_def: bool,
    pub type_name: Option<String>,
    #[serde(default)]
    pub attributes: Vec<AttributeDef>,
    #[serde(default)]
    pub ports: Vec<PortDef>,
    #[serde(default)]
    pub actions: Vec<ActionDef>,
    #[serde(default)]
    pub constraints: Vec<ConstraintDef>,
    #[serde(default)]
    pub requirements: Vec<RequirementDef>,
    #[serde(default)]
    pub parts: Vec<PartDef>,
    #[serde(default)]
    pub operations: Vec<OperationDef>,
    #[serde(default)]
    pub capabilities: Vec<CapabilityDef>,
    #[serde(default)]
    pub interactions: Vec<InteractionDef>,
    #[serde(default)]
    pub test_cases: Vec<TestCaseDef>,
    #[serde(default)]
    pub states: Vec<StateDef>,
    #[serde(default)]
    pub use_cases: Vec<UseCaseDef>,
    #[serde(default)]
    pub item_defs: Vec<ItemDef>,
    #[serde(default)]
    pub hazards: Vec<HazardDef>,
    #[serde(default)]
    pub risks: Vec<RiskDef>,
    #[serde(default)]
    pub connections: Vec<ConnectionDef>,
}

impl Default for PartDef {
    fn default() -> Self {
        Self {
            name: String::new(),
            doc: None,
            is_def: true,
            type_name: None,
            attributes: Vec::new(),
            ports: Vec::new(),
            actions: Vec::new(),
            constraints: Vec::new(),
            requirements: Vec::new(),
            parts: Vec::new(),
            operations: Vec::new(),
            capabilities: Vec::new(),
            interactions: Vec::new(),
            test_cases: Vec::new(),
            states: Vec::new(),
            use_cases: Vec::new(),
            item_defs: Vec::new(),
            hazards: Vec::new(),
            risks: Vec::new(),
            connections: Vec::new(),
        }
    }
}

/// Top-level or nested package container in SysML v2.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct PackageDef {
    pub name: String,
    pub doc: Option<String>,
    pub parent_package: Option<String>,
    #[serde(default)]
    pub packages: Vec<PackageDef>,
    #[serde(default)]
    pub part_defs: Vec<PartDef>,
    #[serde(default)]
    pub port_defs: Vec<PortDef>,
    #[serde(default)]
    pub attribute_defs: Vec<AttributeDef>,
    #[serde(default)]
    pub action_defs: Vec<ActionDef>,
    #[serde(default)]
    pub operation_defs: Vec<OperationDef>,
    #[serde(default)]
    pub capability_defs: Vec<CapabilityDef>,
    #[serde(default)]
    pub interaction_defs: Vec<InteractionDef>,
    #[serde(default)]
    pub constraint_defs: Vec<ConstraintDef>,
    #[serde(default)]
    pub test_case_defs: Vec<TestCaseDef>,
    #[serde(default)]
    pub requirement_defs: Vec<RequirementDef>,
    #[serde(default)]
    pub state_defs: Vec<StateDef>,
    #[serde(default)]
    pub use_case_defs: Vec<UseCaseDef>,
    #[serde(default)]
    pub item_defs: Vec<ItemDef>,
    #[serde(default)]
    pub hazard_defs: Vec<HazardDef>,
    #[serde(default)]
    pub risk_defs: Vec<RiskDef>,
    #[serde(default)]
    pub connection_defs: Vec<ConnectionDef>,
}

/// Legacy and high-level SysML model container for backwards compatibility.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct SysmlModel {
    pub package_name: Option<String>,
    pub doc: Option<String>,
    pub attributes: Vec<AttributeDef>,
    pub parts: Vec<PartDef>,
    pub ports: Vec<PortDef>,
    pub actions: Vec<ActionDef>,
    pub constraints: Vec<ConstraintDef>,
    pub requirements: Vec<RequirementDef>,
}

impl From<PackageDef> for SysmlModel {
    fn from(pkg: PackageDef) -> Self {
        Self {
            package_name: Some(pkg.name),
            doc: pkg.doc,
            attributes: pkg.attribute_defs,
            parts: pkg.part_defs,
            ports: pkg.port_defs,
            actions: pkg.action_defs,
            constraints: pkg.constraint_defs,
            requirements: pkg.requirement_defs,
        }
    }
}

impl From<SysmlModel> for PackageDef {
    fn from(m: SysmlModel) -> Self {
        Self {
            name: m.package_name.unwrap_or_else(|| "SysML_Model".to_string()),
            doc: m.doc,
            parent_package: None,
            packages: Vec::new(),
            part_defs: m.parts,
            port_defs: m.ports,
            attribute_defs: m.attributes,
            action_defs: m.actions,
            operation_defs: Vec::new(),
            capability_defs: Vec::new(),
            interaction_defs: Vec::new(),
            constraint_defs: m.constraints,
            test_case_defs: Vec::new(),
            requirement_defs: m.requirements,
            state_defs: Vec::new(),
            use_case_defs: Vec::new(),
            item_defs: Vec::new(),
            hazard_defs: Vec::new(),
            risk_defs: Vec::new(),
            connection_defs: Vec::new(),
        }
    }
}

/// Parse attributes from SysML v2 source text.
pub fn parse_attribute_defs(content: &str) -> Vec<AttributeDef> {
    let re = Regex::new(
        r#"(?m)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?attribute\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)\s*:\s*(?P<type>[A-Za-z0-9_]+)(?:\s*=\s*(?P<val>[^;]+))?;"#,
    )
    .unwrap();

    let mut attrs = Vec::new();
    for cap in re.captures_iter(content) {
        let name = cap["name"].to_string();
        let type_name = cap["type"].to_string();
        let default_value = cap.name("val").map(|v| v.as_str().trim().to_string());
        let doc = cap.name("doc").map(|d| d.as_str().trim().to_string());

        attrs.push(AttributeDef {
            name,
            type_name,
            default_value,
            doc,
        });
    }
    attrs
}

/// Parse port definitions from SysML v2 source text.
pub fn parse_port_defs(content: &str) -> Vec<PortDef> {
    let re = Regex::new(
        r#"(?m)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?port\s+(?:def\s+)?(?:(?P<dir>in|out|inout)\s+)?(?P<name>[A-Za-z0-9_]+)\s*:\s*(?P<conj>~)?(?P<type>[A-Za-z0-9_]+);"#,
    )
    .unwrap();

    let mut ports = Vec::new();
    for cap in re.captures_iter(content) {
        let name = cap["name"].to_string();
        let type_name = cap["type"].to_string();
        let direction = cap
            .name("dir")
            .map(|d| d.as_str().trim().to_string())
            .unwrap_or_else(|| "inout".to_string());
        let is_conjugated = cap.name("conj").is_some();
        let doc = cap.name("doc").map(|d| d.as_str().trim().to_string());

        ports.push(PortDef {
            name,
            type_name,
            direction,
            is_conjugated,
            doc,
            ..Default::default()
        });
    }
    ports
}

/// Parse action definitions from SysML v2 source text.
pub fn parse_action_defs(content: &str) -> Vec<ActionDef> {
    let re = Regex::new(
        r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?action\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)\s*(?:\{(?P<body>.*?)\}|;)"#,
    )
    .unwrap();

    let in_param_re = Regex::new(
        r#"(?m)^\s*in\s+(?:attribute\s+)?(?P<name>[A-Za-z0-9_]+)\s*:\s*(?P<type>[A-Za-z0-9_]+);"#,
    )
    .unwrap();
    let out_param_re = Regex::new(
        r#"(?m)^\s*out\s+(?:attribute\s+)?(?P<name>[A-Za-z0-9_]+)\s*:\s*(?P<type>[A-Za-z0-9_]+);"#,
    )
    .unwrap();

    let mut actions = Vec::new();
    for cap in re.captures_iter(content) {
        let name = cap["name"].to_string();
        let doc = cap.name("doc").map(|d| d.as_str().trim().to_string());

        let mut in_params = Vec::new();
        let mut out_params = Vec::new();

        if let Some(body) = cap.name("body") {
            let body_str = body.as_str();
            for p_cap in in_param_re.captures_iter(body_str) {
                in_params.push(AttributeDef {
                    name: p_cap["name"].to_string(),
                    type_name: p_cap["type"].to_string(),
                    default_value: None,
                    doc: None,
                });
            }
            for p_cap in out_param_re.captures_iter(body_str) {
                out_params.push(AttributeDef {
                    name: p_cap["name"].to_string(),
                    type_name: p_cap["type"].to_string(),
                    default_value: None,
                    doc: None,
                });
            }
        }

        actions.push(ActionDef {
            name,
            doc,
            in_params,
            out_params,
            ..Default::default()
        });
    }
    actions
}

/// Parse constraint definitions or assertions from SysML v2 source text.
pub fn parse_constraint_defs(content: &str) -> Vec<ConstraintDef> {
    let re = Regex::new(
        r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?(?P<assert>assert\s+)?constraint\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)(?:\((?P<params>[^)]*)\))?\s*(?:\{(?P<expr>.*?)\}|;)"#,
    )
    .unwrap();

    let mut constraints = Vec::new();
    for cap in re.captures_iter(content) {
        let name = cap["name"].to_string();
        let is_assertion = cap.name("assert").is_some();
        let doc = cap.name("doc").map(|d| d.as_str().trim().to_string());
        let parameters = cap
            .name("params")
            .map(|p| {
                p.as_str()
                    .split(',')
                    .map(|s| s.trim().to_string())
                    .filter(|s| !s.is_empty())
                    .collect()
            })
            .unwrap_or_default();
        let expression = cap
            .name("expr")
            .map(|e| e.as_str().trim().trim_end_matches(';').trim().to_string())
            .unwrap_or_default();

        constraints.push(ConstraintDef {
            name,
            expression,
            parameters,
            is_assertion,
            doc,
            ..Default::default()
        });
    }
    constraints
}

/// Parse requirement definitions from SysML v2 source text.
pub fn parse_requirement_defs(content: &str) -> Vec<RequirementDef> {
    let re = Regex::new(
        r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?requirement\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)\s*(?:\{(?P<body>.*?)\}|;)"#,
    )
    .unwrap();
    let id_re = Regex::new(r#"(?m)^\s*(?:id|req_id)\s*=\s*"(?P<id>[^"]+)""#).unwrap();
    let text_re = Regex::new(r#"(?m)^\s*(?:doc|text)\s*=\s*"(?P<text>[^"]+)""#).unwrap();

    let mut reqs = Vec::new();
    for cap in re.captures_iter(content) {
        let name = cap["name"].to_string();
        let doc = cap.name("doc").map(|d| d.as_str().trim().to_string());
        let mut req_id = String::new();
        let mut text = String::new();

        if let Some(body) = cap.name("body") {
            let body_str = body.as_str();
            if let Some(id_cap) = id_re.captures(body_str) {
                req_id = id_cap["id"].to_string();
            }
            if let Some(txt_cap) = text_re.captures(body_str) {
                text = txt_cap["text"].to_string();
            }
        }

        reqs.push(RequirementDef {
            name,
            req_id,
            text,
            doc,
            ..Default::default()
        });
    }
    reqs
}

/// Parse connection definitions from SysML v2 source text.
pub fn parse_connection_defs(content: &str) -> Vec<ConnectionDef> {
    let re = Regex::new(
        r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?(?P<is_flow>flow|connection)\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)\s*\{(?P<body>.*?)\}"#,
    )
    .unwrap();
    let conn_stmt_re = Regex::new(
        r#"(?m)^\s*(?:connect|flow\s+from)\s+(?P<src>[A-Za-z0-9_.]+)\s+to\s+(?P<tgt>[A-Za-z0-9_.]+);"#,
    )
    .unwrap();

    let mut conns = Vec::new();
    for cap in re.captures_iter(content) {
        let name = cap["name"].to_string();
        let is_flow = &cap["is_flow"] == "flow";
        let doc = cap.name("doc").map(|d| d.as_str().trim().to_string());
        let body = &cap["body"];

        let mut source_port = String::new();
        let mut target_port = String::new();

        if let Some(c_cap) = conn_stmt_re.captures(body) {
            source_port = c_cap["src"].to_string();
            target_port = c_cap["tgt"].to_string();
        }

        let source_part = if source_port.contains('.') {
            Some(source_port.split('.').next().unwrap().to_string())
        } else {
            None
        };

        let target_part = if target_port.contains('.') {
            Some(target_port.split('.').next().unwrap().to_string())
        } else {
            None
        };

        conns.push(ConnectionDef {
            name,
            source_port,
            target_port,
            source_part,
            target_part,
            doc,
            severity: 1,
            item_flow_ref: None,
            protocol: None,
            latency_ms: None,
            is_flow,
        });
    }
    conns
}

/// Parse state definitions from SysML v2 source text.
pub fn parse_state_defs(content: &str) -> Vec<StateDef> {
    let re = Regex::new(
        r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?state\s+(?:def\s+)?(?P<name>[A-Za-z0-9_]+)\s*(?:\{(?P<body>.*?)\}|;)"#,
    )
    .unwrap();
    let entry_re = Regex::new(r#"(?m)^\s*entry\s+(?P<act>[^;]+);"#).unwrap();
    let do_re = Regex::new(r#"(?m)^\s*do\s+(?P<act>[^;]+);"#).unwrap();
    let exit_re = Regex::new(r#"(?m)^\s*exit\s+(?P<act>[^;]+);"#).unwrap();

    let mut states = Vec::new();
    for cap in re.captures_iter(content) {
        let name = cap["name"].to_string();
        let doc = cap.name("doc").map(|d| d.as_str().trim().to_string());

        let mut entry_action = None;
        let mut do_action = None;
        let mut exit_action = None;

        if let Some(body) = cap.name("body") {
            let body_str = body.as_str();
            if let Some(e_cap) = entry_re.captures(body_str) {
                entry_action = Some(e_cap["act"].trim().to_string());
            }
            if let Some(d_cap) = do_re.captures(body_str) {
                do_action = Some(d_cap["act"].trim().to_string());
            }
            if let Some(x_cap) = exit_re.captures(body_str) {
                exit_action = Some(x_cap["act"].trim().to_string());
            }
        }

        states.push(StateDef {
            name,
            doc,
            entry_action,
            do_action,
            exit_action,
            transitions: Vec::new(),
            sub_states: Vec::new(),
        });
    }
    states
}

/// Helper to locate the matching closing brace for a block, respecting strings and comments.
pub fn find_matching_brace(s: &str, open_pos: usize) -> Option<usize> {
    let mut depth = 0;
    let mut in_str = false;
    let mut in_escape = false;
    let mut chars = s[open_pos..].char_indices();
    while let Some((idx, ch)) = chars.next() {
        if in_str {
            if in_escape {
                in_escape = false;
            } else if ch == '\\' {
                in_escape = true;
            } else if ch == '"' {
                in_str = false;
            }
        } else {
            match ch {
                '"' => in_str = true,
                '{' => depth += 1,
                '}' => {
                    depth -= 1;
                    if depth == 0 {
                        return Some(open_pos + idx);
                    }
                }
                _ => {}
            }
        }
    }
    None
}

/// Parse part definitions from SysML v2 source text.
pub fn parse_part_defs(content: &str) -> Vec<PartDef> {
    let head_re = Regex::new(
        r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?part\s+def\s+(?P<name>[A-Za-z0-9_]+)\s*(?P<term>\{|;)"#,
    )
    .unwrap();

    let mut parts = Vec::new();
    for cap in head_re.captures_iter(content) {
        let full_match = cap.get(0).unwrap();
        let name = cap["name"].to_string();
        let doc = cap.name("doc").map(|d| d.as_str().trim().to_string());
        let term = &cap["term"];

        let body = if term == "{" {
            let open_pos = full_match.end() - 1;
            if let Some(close_pos) = find_matching_brace(content, open_pos) {
                &content[open_pos + 1..close_pos]
            } else {
                ""
            }
        } else {
            ""
        };

        let attributes = parse_attribute_defs(body);
        let ports = parse_port_defs(body);
        let actions = parse_action_defs(body);
        let constraints = parse_constraint_defs(body);
        let requirements = parse_requirement_defs(body);
        let connections = parse_connection_defs(body);
        let states = parse_state_defs(body);

        parts.push(PartDef {
            name,
            doc,
            is_def: true,
            type_name: None,
            attributes,
            ports,
            actions,
            constraints,
            requirements,
            parts: Vec::new(),
            operations: Vec::new(),
            capabilities: Vec::new(),
            interactions: Vec::new(),
            test_cases: Vec::new(),
            states,
            use_cases: Vec::new(),
            item_defs: Vec::new(),
            hazards: Vec::new(),
            risks: Vec::new(),
            connections,
        });
    }
    parts
}

/// Parse an entire SysML v2 source text into a structured SysmlModel.
pub fn parse_sysml(content: &str) -> SysmlModel {
    let pkg_re = Regex::new(
        r#"(?s)(?:doc\s*/\*(?P<doc>.*?)\*/\s*)?package\s+(?P<name>[A-Za-z0-9_]+)\s*\{"#,
    )
    .unwrap();

    if let Some(cap) = pkg_re.captures(content) {
        let full_match = cap.get(0).unwrap();
        let package_name = Some(cap["name"].to_string());
        let doc = cap.name("doc").map(|d| d.as_str().trim().to_string());
        let open_pos = full_match.end() - 1;
        let body = if let Some(close_pos) = find_matching_brace(content, open_pos) {
            &content[open_pos + 1..close_pos]
        } else {
            &content[open_pos + 1..]
        };

        let parts = parse_part_defs(body);
        let ports = parse_port_defs(body);
        let actions = parse_action_defs(body);
        let constraints = parse_constraint_defs(body);
        let requirements = parse_requirement_defs(body);
        let attributes = parse_attribute_defs(body);

        SysmlModel {
            package_name,
            doc,
            attributes,
            parts,
            ports,
            actions,
            constraints,
            requirements,
        }
    } else {
        let parts = parse_part_defs(content);
        let ports = parse_port_defs(content);
        let actions = parse_action_defs(content);
        let constraints = parse_constraint_defs(content);
        let requirements = parse_requirement_defs(content);
        let attributes = parse_attribute_defs(content);

        SysmlModel {
            package_name: None,
            doc: None,
            attributes,
            parts,
            ports,
            actions,
            constraints,
            requirements,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_part_defs_and_ports() {
        let sysml_source = r#"
package AutonomousVehicle_SSOT {
    doc /* SSOT for Autonomous System Architecture and Safety Model */

    attribute ruddervatorCount : Integer = 4;
    attribute tailConfiguration : String = "X-tail";
    attribute catapultLaunchLimitG : Real = 12.0;
    attribute maxGLoad : Real = 12.0;

    part def Airframe {
        attribute massKg : Real = 25.0;
    }

    part def FlightControlComputer {
        port c2_bus : RS485;
        port telemetry : MAVLink;
    }
}
"#;
        let model = parse_sysml(sysml_source);
        assert_eq!(model.package_name.as_deref(), Some("AutonomousVehicle_SSOT"));
        assert_eq!(model.parts.len(), 2);

        let airframe = &model.parts[0];
        assert_eq!(airframe.name, "Airframe");
        assert_eq!(airframe.attributes.len(), 1);
        assert_eq!(airframe.attributes[0].name, "massKg");
        assert_eq!(airframe.attributes[0].type_name, "Real");
        assert_eq!(airframe.attributes[0].default_value.as_deref(), Some("25.0"));

        let fcc = &model.parts[1];
        assert_eq!(fcc.name, "FlightControlComputer");
        assert_eq!(fcc.ports.len(), 2);
        assert_eq!(fcc.ports[0].name, "c2_bus");
        assert_eq!(fcc.ports[0].type_name, "RS485");
        assert_eq!(fcc.ports[1].name, "telemetry");
        assert_eq!(fcc.ports[1].type_name, "MAVLink");
    }

    #[test]
    fn test_parse_actions_and_constraints() {
        let sysml_source = r#"
action def CalculateTrajectory {
    in attribute currentPos : Vector3;
    out attribute nextWaypoint : Vector3;
}

constraint def VelocityLimitConstraint(v : Real) {
    v <= 60.0;
}
"#;
        let actions = parse_action_defs(sysml_source);
        assert_eq!(actions.len(), 1);
        assert_eq!(actions[0].name, "CalculateTrajectory");
        assert_eq!(actions[0].in_params.len(), 1);
        assert_eq!(actions[0].in_params[0].name, "currentPos");
        assert_eq!(actions[0].out_params.len(), 1);
        assert_eq!(actions[0].out_params[0].name, "nextWaypoint");

        let constraints = parse_constraint_defs(sysml_source);
        assert_eq!(constraints.len(), 1);
        assert_eq!(constraints[0].name, "VelocityLimitConstraint");
        assert_eq!(constraints[0].parameters, vec!["v : Real"]);
        assert_eq!(constraints[0].expression, "v <= 60.0");
    }

    #[test]
    fn test_parse_connections_and_states() {
        let sysml_source = r#"
part def VehicleSystem {
    state def NavigationState {
        entry InitializeINS;
        do UpdateExtendedKalmanFilter;
        exit ShutdownSensors;
    }

    connection def GpsToFcc {
        connect gps.fix to fcc.nav_input;
    }
}
"#;
        let parts = parse_part_defs(sysml_source);
        assert_eq!(parts.len(), 1);
        let vehicle = &parts[0];
        assert_eq!(vehicle.name, "VehicleSystem");
        assert_eq!(vehicle.states.len(), 1);
        assert_eq!(vehicle.states[0].name, "NavigationState");
        assert_eq!(vehicle.states[0].entry_action.as_deref(), Some("InitializeINS"));
        assert_eq!(vehicle.connections.len(), 1);
        assert_eq!(vehicle.connections[0].name, "GpsToFcc");
        assert_eq!(vehicle.connections[0].source_port, "gps.fix");
        assert_eq!(vehicle.connections[0].target_port, "fcc.nav_input");
    }

    #[test]
    fn test_parse_ground_truth_model_fixture() {
        let fixture = include_str!("../../../tests/fixtures/safety/ground_truth_model.sysml");
        let model = parse_sysml(fixture);
        assert_eq!(model.package_name.as_deref(), Some("AutonomousVehicle_SSOT"));
        assert_eq!(model.parts.len(), 2);
    }
}
