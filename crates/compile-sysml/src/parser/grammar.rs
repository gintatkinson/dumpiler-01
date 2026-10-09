//! Recursive descent parser translating SysML v2 / KerML tokens into typed AST.

use crate::lexer::scanner::Scanner;
use crate::lexer::token::{Span, Token, TokenKind};
use deap_core::sysml_ast::*;
use std::fmt;

/// Diagnostic error with source location span.
#[derive(Debug, Clone, PartialEq)]
pub struct ParseError {
    pub message: String,
    pub span: Span,
}

impl fmt::Display for ParseError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "Parse error at line {}, col {}: {}",
            self.span.line, self.span.col, self.message
        )
    }
}

impl std::error::Error for ParseError {}

/// Recursive descent parser for SysML v2 / KerML syntax.
pub struct SysmlParser<'a> {
    tokens: &'a [Token],
    pos: usize,
}

impl<'a> SysmlParser<'a> {
    pub fn new(tokens: &'a [Token]) -> Self {
        Self { tokens, pos: 0 }
    }

    /// Parse complete source text into a PackageDef.
    pub fn parse_source(source: &str, default_pkg_name: &str) -> Result<PackageDef, ParseError> {
        let mut scanner = Scanner::new(source);
        let tokens = scanner.scan_all().map_err(|msg| ParseError {
            message: msg,
            span: Span::default(),
        })?;
        let mut parser = SysmlParser::new(&tokens);
        parser.parse_package_or_file(default_pkg_name)
    }

    /// Parse a package or top-level file definitions into PackageDef.
    pub fn parse_package_or_file(&mut self, default_pkg_name: &str) -> Result<PackageDef, ParseError> {
        self.skip_trivia();

        // Check if top-level starts with package declaration
        let mut pending_doc = self.take_doc_comment();
        if self.check(&TokenKind::Package) {
            let pkg = self.parse_package_decl(pending_doc)?;
            return Ok(pkg);
        }

        // Flat file without top-level package block
        let mut pkg = PackageDef {
            name: default_pkg_name.to_string(),
            doc: pending_doc.take(),
            ..Default::default()
        };

        while !self.is_at_end() {
            self.parse_container_item(&mut pkg, None)?;
            self.skip_trivia();
        }

        Ok(pkg)
    }

    fn parse_package_decl(&mut self, mut doc: Option<String>) -> Result<PackageDef, ParseError> {
        self.expect(&TokenKind::Package)?;
        let name = self.expect_ident()?;
        self.expect(&TokenKind::OpenBrace)?;

        self.skip_trivia();
        if doc.is_none() {
            doc = self.take_doc_comment();
        }

        let mut pkg = PackageDef {
            name,
            doc,
            ..Default::default()
        };

        while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
            self.parse_container_item(&mut pkg, None)?;
            self.skip_trivia();
        }

        self.expect(&TokenKind::CloseBrace)?;
        Ok(pkg)
    }

    fn parse_container_item(
        &mut self,
        pkg: &mut PackageDef,
        parent_part: Option<&mut PartDef>,
    ) -> Result<(), ParseError> {
        self.skip_trivia();
        let doc = self.take_doc_comment();

        if self.is_at_end() {
            return Ok(());
        }

        match self.peek_kind() {
            TokenKind::Package => {
                let subpkg = self.parse_package_decl(doc)?;
                pkg.packages.push(subpkg);
            }
            TokenKind::Part => {
                let part = self.parse_part_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.parts.push(part);
                } else {
                    pkg.part_defs.push(part);
                }
            }
            TokenKind::Port => {
                let port = self.parse_port_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.ports.push(port);
                } else {
                    pkg.port_defs.push(port);
                }
            }
            TokenKind::In | TokenKind::Out | TokenKind::Inout if self.peek_next_is_port() => {
                let port = self.parse_port_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.ports.push(port);
                } else {
                    pkg.port_defs.push(port);
                }
            }
            TokenKind::Attribute => {
                let attr = self.parse_attribute_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.attributes.push(attr);
                } else {
                    pkg.attribute_defs.push(attr);
                }
            }
            TokenKind::Action => {
                let action = self.parse_action_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.actions.push(action);
                } else {
                    pkg.action_defs.push(action);
                }
            }
            TokenKind::Constraint | TokenKind::Assert => {
                let constraint = self.parse_constraint_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.constraints.push(constraint);
                } else {
                    pkg.constraint_defs.push(constraint);
                }
            }
            TokenKind::Requirement => {
                let req = self.parse_requirement_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.requirements.push(req);
                } else {
                    pkg.requirement_defs.push(req);
                }
            }
            TokenKind::State => {
                let state = self.parse_state_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.states.push(state);
                } else {
                    pkg.state_defs.push(state);
                }
            }
            TokenKind::Connection | TokenKind::Connect => {
                let conn = self.parse_connection_decl(doc, false)?;
                if let Some(parent) = parent_part {
                    parent.connections.push(conn);
                } else {
                    pkg.connection_defs.push(conn);
                }
            }
            TokenKind::Flow => {
                let conn = self.parse_connection_decl(doc, true)?;
                if let Some(parent) = parent_part {
                    parent.connections.push(conn);
                } else {
                    pkg.connection_defs.push(conn);
                }
            }
            TokenKind::UseCase => {
                let uc = self.parse_use_case_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.use_cases.push(uc);
                } else {
                    pkg.use_case_defs.push(uc);
                }
            }
            TokenKind::Item => {
                let item = self.parse_item_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.item_defs.push(item);
                } else {
                    pkg.item_defs.push(item);
                }
            }
            TokenKind::Hazard => {
                let hz = self.parse_hazard_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.hazards.push(hz);
                } else {
                    pkg.hazard_defs.push(hz);
                }
            }
            TokenKind::Risk => {
                let rk = self.parse_risk_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.risks.push(rk);
                } else {
                    pkg.risk_defs.push(rk);
                }
            }
            TokenKind::Test => {
                let tc = self.parse_test_case_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.test_cases.push(tc);
                } else {
                    pkg.test_case_defs.push(tc);
                }
            }
            TokenKind::Capability => {
                let cap = self.parse_capability_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.capabilities.push(cap);
                } else {
                    pkg.capability_defs.push(cap);
                }
            }
            TokenKind::Operation => {
                let op = self.parse_operation_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.operations.push(op);
                } else {
                    pkg.operation_defs.push(op);
                }
            }
            TokenKind::Interaction => {
                let inter = self.parse_interaction_decl(doc)?;
                if let Some(parent) = parent_part {
                    parent.interactions.push(inter);
                } else {
                    pkg.interaction_defs.push(inter);
                }
            }
            _ => {
                // Skip unknown statement or delimiter to maintain fault tolerance
                self.skip_until_semi_or_brace();
            }
        }

        Ok(())
    }

    fn peek_next_is_port(&self) -> bool {
        if self.pos + 1 < self.tokens.len() {
            self.tokens[self.pos + 1].kind == TokenKind::Port
        } else {
            false
        }
    }

    // --- Specific Parsers ---

    fn parse_part_decl(&mut self, doc: Option<String>) -> Result<PartDef, ParseError> {
        self.expect(&TokenKind::Part)?;
        let is_def = if self.check(&TokenKind::Def) {
            self.advance();
            true
        } else {
            false
        };

        let name = self.expect_ident()?;
        let mut type_name = None;

        if self.check(&TokenKind::Colon) || self.check(&TokenKind::ColonGt) {
            self.advance();
            type_name = Some(self.expect_ident()?);
        }

        let mut part = PartDef {
            name,
            doc,
            is_def,
            type_name,
            ..Default::default()
        };

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            self.skip_trivia();
            if part.doc.is_none() {
                part.doc = self.take_doc_comment();
            }
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                let mut dummy_pkg = PackageDef::default();
                self.parse_container_item(&mut dummy_pkg, Some(&mut part))?;
                // Merge any parsed top-level items into part
                part.parts.extend(dummy_pkg.part_defs);
                part.ports.extend(dummy_pkg.port_defs);
                part.attributes.extend(dummy_pkg.attribute_defs);
                part.actions.extend(dummy_pkg.action_defs);
                part.constraints.extend(dummy_pkg.constraint_defs);
                part.requirements.extend(dummy_pkg.requirement_defs);
                part.states.extend(dummy_pkg.state_defs);
                part.connections.extend(dummy_pkg.connection_defs);
                self.skip_trivia();
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(part)
    }

    fn parse_port_decl(&mut self, doc: Option<String>) -> Result<PortDef, ParseError> {
        let mut direction = "inout".to_string();
        if self.check(&TokenKind::In) {
            self.advance();
            direction = "in".to_string();
        } else if self.check(&TokenKind::Out) {
            self.advance();
            direction = "out".to_string();
        } else if self.check(&TokenKind::Inout) {
            self.advance();
            direction = "inout".to_string();
        }

        self.expect(&TokenKind::Port)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        if direction == "inout" {
            if self.check(&TokenKind::In) {
                self.advance();
                direction = "in".to_string();
            } else if self.check(&TokenKind::Out) {
                self.advance();
                direction = "out".to_string();
            } else if self.check(&TokenKind::Inout) {
                self.advance();
                direction = "inout".to_string();
            }
        }

        let name = self.expect_ident()?;
        self.expect(&TokenKind::Colon)?;

        let is_conjugated = if self.check(&TokenKind::Tilde) {
            self.advance();
            true
        } else {
            false
        };

        let type_name = self.expect_ident()?;
        let mut port = PortDef {
            name,
            type_name,
            direction,
            is_conjugated,
            doc,
            ..Default::default()
        };

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                let f_doc = self.take_doc_comment();
                if self.check(&TokenKind::Attribute) {
                    let attr = self.parse_attribute_decl(f_doc)?;
                    if attr.name == "protocol_family" {
                        port.protocol_family = attr.default_value.unwrap_or_default();
                    } else if attr.name == "port_category" {
                        port.port_category = attr.default_value.unwrap_or_default();
                    } else {
                        port.electrical_attributes
                            .insert(attr.name, attr.default_value.unwrap_or_default());
                    }
                } else if self.check(&TokenKind::Flow) || self.check(&TokenKind::In) || self.check(&TokenKind::Out) {
                    let mut flow_dir = "out".to_string();
                    if self.check(&TokenKind::In) {
                        self.advance();
                        flow_dir = "in".to_string();
                    } else if self.check(&TokenKind::Out) {
                        self.advance();
                        flow_dir = "out".to_string();
                    }
                    if self.check(&TokenKind::Flow) {
                        self.advance();
                    }
                    let flow_name = self.expect_ident()?;
                    let flow_type = if self.check(&TokenKind::Colon) {
                        self.advance();
                        self.expect_ident()?
                    } else {
                        "Item".to_string()
                    };
                    self.expect_semi()?;
                    port.item_flows.push(FlowDef {
                        name: flow_name,
                        direction: flow_dir,
                        item_type: flow_type,
                        doc: f_doc,
                        ..Default::default()
                    });
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(port)
    }

    fn parse_attribute_decl(&mut self, doc: Option<String>) -> Result<AttributeDef, ParseError> {
        self.expect(&TokenKind::Attribute)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        let name = self.expect_ident()?;
        let mut type_name = "String".to_string();
        let mut default_value = None;

        if self.check(&TokenKind::Colon) {
            self.advance();
            type_name = self.expect_ident()?;
        }

        if self.check(&TokenKind::Eq) || self.check(&TokenKind::ColonEq) {
            self.advance();
            default_value = Some(self.read_until_semi());
        } else {
            self.expect_semi()?;
        }

        Ok(AttributeDef {
            name,
            type_name,
            default_value,
            doc,
        })
    }

    fn parse_action_decl(&mut self, doc: Option<String>) -> Result<ActionDef, ParseError> {
        self.expect(&TokenKind::Action)?;
        let is_def = if self.check(&TokenKind::Def) {
            self.advance();
            true
        } else {
            false
        };

        let name = self.expect_ident()?;
        let mut in_params = Vec::new();
        let mut out_params = Vec::new();
        let mut performer = None;
        let mut steps = Vec::new();

        if self.check(&TokenKind::OpenParen) {
            self.advance();
            while !self.check(&TokenKind::CloseParen) && !self.is_at_end() {
                let mut is_out = false;
                if self.check(&TokenKind::In) {
                    self.advance();
                } else if self.check(&TokenKind::Out) {
                    self.advance();
                    is_out = true;
                }
                if self.check(&TokenKind::Attribute) {
                    self.advance();
                }
                let param_name = self.expect_ident()?;
                let param_type = if self.check(&TokenKind::Colon) {
                    self.advance();
                    self.expect_ident()?
                } else {
                    "Real".to_string()
                };
                let param = AttributeDef {
                    name: param_name,
                    type_name: param_type,
                    default_value: None,
                    doc: None,
                };
                if is_out {
                    out_params.push(param);
                } else {
                    in_params.push(param);
                }
                if self.check(&TokenKind::Comma) {
                    self.advance();
                }
            }
            self.expect(&TokenKind::CloseParen)?;
        }

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                if self.check(&TokenKind::Perform) {
                    self.advance();
                    performer = Some(self.read_until_semi());
                } else if self.check(&TokenKind::Step) {
                    self.advance();
                    steps.push(self.read_until_semi());
                } else if self.check(&TokenKind::In) || self.check(&TokenKind::Out) {
                    let is_out = self.check(&TokenKind::Out);
                    self.advance();
                    if self.check(&TokenKind::Attribute) {
                        self.advance();
                    }
                    let p_name = self.expect_ident()?;
                    let p_type = if self.check(&TokenKind::Colon) {
                        self.advance();
                        self.expect_ident()?
                    } else {
                        "Real".to_string()
                    };
                    self.expect_semi()?;
                    let p = AttributeDef {
                        name: p_name,
                        type_name: p_type,
                        default_value: None,
                        doc: None,
                    };
                    if is_out {
                        out_params.push(p);
                    } else {
                        in_params.push(p);
                    }
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(ActionDef {
            name,
            doc,
            in_params,
            out_params,
            parameters: Vec::new(),
            performer,
            steps,
            is_def,
        })
    }

    fn parse_constraint_decl(&mut self, doc: Option<String>) -> Result<ConstraintDef, ParseError> {
        let is_assertion = if self.check(&TokenKind::Assert) {
            self.advance();
            true
        } else {
            false
        };

        self.expect(&TokenKind::Constraint)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        let name = self.expect_ident()?;
        let mut parameters = Vec::new();

        if self.check(&TokenKind::OpenParen) {
            self.advance();
            let mut param_str = String::new();
            while !self.check(&TokenKind::CloseParen) && !self.is_at_end() {
                let tok = self.advance();
                match &tok.kind {
                    TokenKind::Comma => {
                        if !param_str.trim().is_empty() {
                            parameters.push(param_str.trim().to_string());
                            param_str.clear();
                        }
                    }
                    TokenKind::Ident(s) => {
                        param_str.push_str(s);
                        param_str.push(' ');
                    }
                    TokenKind::Colon => {
                        param_str.push_str(": ");
                    }
                    _ => {
                        param_str.push_str(tok.kind.as_str());
                        param_str.push(' ');
                    }
                }
            }
            if !param_str.trim().is_empty() {
                parameters.push(param_str.trim().to_string());
            }
            self.expect(&TokenKind::CloseParen)?;
        }

        let mut expression = String::new();
        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                let stmt = self.read_until_semi();
                if !stmt.trim().is_empty() {
                    if !expression.is_empty() {
                        expression.push_str(" && ");
                    }
                    expression.push_str(&stmt);
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(ConstraintDef {
            name,
            expression,
            parameters,
            is_assertion,
            doc,
            pre_conditions: Vec::new(),
            post_conditions: Vec::new(),
        })
    }

    fn parse_requirement_decl(&mut self, doc: Option<String>) -> Result<RequirementDef, ParseError> {
        self.expect(&TokenKind::Requirement)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        let name = self.expect_ident()?;
        let mut req_id = String::new();
        let mut text = String::new();
        let mut assumes = Vec::new();
        let mut requires = Vec::new();
        let mut verified_by = Vec::new();
        let mut satisfied_by = Vec::new();

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                let sub_doc = self.take_doc_comment();
                if self.check(&TokenKind::Id) {
                    self.advance();
                    if self.check(&TokenKind::Eq) {
                        self.advance();
                    }
                    req_id = self.expect_string_or_ident()?;
                    self.expect_semi()?;
                } else if self.check(&TokenKind::Text) || self.check(&TokenKind::Doc) {
                    self.advance();
                    if self.check(&TokenKind::Eq) {
                        self.advance();
                    }
                    text = self.expect_string_or_ident()?;
                    self.expect_semi()?;
                } else if let Some(d) = sub_doc {
                    text = d;
                } else if self.check(&TokenKind::Assume) {
                    self.advance();
                    assumes.push(self.read_until_semi());
                } else if self.check(&TokenKind::Require) {
                    self.advance();
                    requires.push(self.read_until_semi());
                } else if self.check(&TokenKind::Verify) {
                    self.advance();
                    if self.check(&TokenKind::By) {
                        self.advance();
                    }
                    verified_by.push(self.read_until_semi());
                } else if self.check(&TokenKind::Satisfy) {
                    self.advance();
                    if self.check(&TokenKind::By) {
                        self.advance();
                    }
                    satisfied_by.push(self.read_until_semi());
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(RequirementDef {
            name,
            req_id,
            text,
            doc,
            assumes,
            requires,
            verified_by,
            satisfied_by,
        })
    }

    fn parse_state_decl(&mut self, doc: Option<String>) -> Result<StateDef, ParseError> {
        self.expect(&TokenKind::State)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        let name = self.expect_ident()?;
        let mut entry_action = None;
        let mut do_action = None;
        let mut exit_action = None;
        let mut transitions = Vec::new();

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                if self.check(&TokenKind::Entry) {
                    self.advance();
                    entry_action = Some(self.read_until_semi());
                } else if self.check(&TokenKind::Do) {
                    self.advance();
                    do_action = Some(self.read_until_semi());
                } else if self.check(&TokenKind::Exit) {
                    self.advance();
                    exit_action = Some(self.read_until_semi());
                } else if self.check(&TokenKind::Transition) {
                    self.advance();
                    let t_stmt = self.read_until_semi();
                    transitions.push(TransitionDef {
                        name: Some(t_stmt.clone()),
                        source: None,
                        target: None,
                        trigger: None,
                        guard: None,
                        effect: None,
                        doc: None,
                    });
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(StateDef {
            name,
            doc,
            entry_action,
            do_action,
            exit_action,
            transitions,
            sub_states: Vec::new(),
        })
    }

    fn parse_connection_decl(
        &mut self,
        doc: Option<String>,
        is_flow: bool,
    ) -> Result<ConnectionDef, ParseError> {
        if is_flow {
            self.expect(&TokenKind::Flow)?;
        } else {
            self.expect(&TokenKind::Connection)?;
        }
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        let name = self.expect_ident()?;
        let mut source_port = String::new();
        let mut target_port = String::new();
        let mut protocol = None;
        let mut latency_ms = None;
        let mut severity = 1;

        let mut conn_doc = doc;
        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                if let Some(inner_doc) = self.take_doc_comment() {
                    if conn_doc.is_none() {
                        conn_doc = Some(inner_doc);
                    }
                    continue;
                }
                if self.check(&TokenKind::Connect) || (self.check(&TokenKind::Flow) && self.peek_next_is_from()) {
                    self.advance(); // connect / flow
                    if self.check(&TokenKind::From) {
                        self.advance();
                    }
                    source_port = self.expect_ident_or_dotted()?;
                    self.expect(&TokenKind::To)?;
                    target_port = self.expect_ident_or_dotted()?;
                    self.expect_semi()?;
                } else if self.check(&TokenKind::Attribute) {
                    let attr = self.parse_attribute_decl(None)?;
                    if attr.name == "protocol" {
                        protocol = attr.default_value.map(|v| v.trim_matches('"').to_string());
                    } else if attr.name == "latency_ms" || attr.name == "latency" {
                        latency_ms = attr.default_value.and_then(|v| v.parse::<f64>().ok());
                    } else if attr.name == "severity" {
                        severity = attr.default_value.and_then(|v| v.parse::<i32>().ok()).unwrap_or(1);
                    }
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
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

        Ok(ConnectionDef {
            name,
            source_port,
            target_port,
            source_part,
            target_part,
            doc: conn_doc,
            severity,
            item_flow_ref: None,
            protocol,
            latency_ms,
            is_flow,
        })
    }

    fn peek_next_is_from(&self) -> bool {
        if self.pos + 1 < self.tokens.len() {
            self.tokens[self.pos + 1].kind == TokenKind::From
        } else {
            false
        }
    }

    fn parse_use_case_decl(&mut self, doc: Option<String>) -> Result<UseCaseDef, ParseError> {
        self.expect(&TokenKind::UseCase)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        let name = self.expect_ident()?;
        let mut subject = None;
        let mut actor = None;
        let mut actors = Vec::new();
        let mut objective = None;
        let mut steps = Vec::new();

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                if self.check(&TokenKind::Subject) {
                    self.advance();
                    subject = Some(self.read_until_semi());
                } else if self.check(&TokenKind::Actor) {
                    self.advance();
                    let act = self.read_until_semi();
                    if actor.is_none() {
                        actor = Some(act.clone());
                    }
                    actors.push(act);
                } else if self.check(&TokenKind::Objective) {
                    self.advance();
                    objective = Some(self.read_until_semi());
                } else if self.check(&TokenKind::Step) {
                    self.advance();
                    steps.push(self.read_until_semi());
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(UseCaseDef {
            name,
            doc,
            subject,
            actor,
            actors,
            objective,
            includes: Vec::new(),
            extends: Vec::new(),
            steps,
            preconditions: Vec::new(),
            postconditions: Vec::new(),
        })
    }

    fn parse_item_decl(&mut self, doc: Option<String>) -> Result<ItemDef, ParseError> {
        self.expect(&TokenKind::Item)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        let name = self.expect_ident()?;
        let mut attributes = Vec::new();

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                let a_doc = self.take_doc_comment();
                if self.check(&TokenKind::Attribute) {
                    attributes.push(self.parse_attribute_decl(a_doc)?);
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(ItemDef {
            name,
            doc,
            attributes,
        })
    }

    fn parse_hazard_decl(&mut self, doc: Option<String>) -> Result<HazardDef, ParseError> {
        self.expect(&TokenKind::Hazard)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        let name = self.expect_ident()?;
        let mut severity = 1;
        let mut source_port = None;
        let mut target_port = None;
        let mut part_ref = None;

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                if self.check(&TokenKind::Attribute) {
                    let attr = self.parse_attribute_decl(None)?;
                    if attr.name == "severity" {
                        severity = attr.default_value.and_then(|v| v.parse::<i32>().ok()).unwrap_or(1);
                    } else if attr.name == "source_port" {
                        source_port = attr.default_value;
                    } else if attr.name == "target_port" {
                        target_port = attr.default_value;
                    } else if attr.name == "part_ref" {
                        part_ref = attr.default_value;
                    }
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(HazardDef {
            name,
            doc,
            severity,
            source_port,
            target_port,
            part_ref,
        })
    }

    fn parse_risk_decl(&mut self, doc: Option<String>) -> Result<RiskDef, ParseError> {
        self.expect(&TokenKind::Risk)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        let name = self.expect_ident()?;
        let mut severity = 1;
        let mut hazard_ref = None;
        let mut source_port = None;
        let mut target_port = None;

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                if self.check(&TokenKind::Attribute) {
                    let attr = self.parse_attribute_decl(None)?;
                    if attr.name == "severity" {
                        severity = attr.default_value.and_then(|v| v.parse::<i32>().ok()).unwrap_or(1);
                    } else if attr.name == "hazard_ref" {
                        hazard_ref = attr.default_value;
                    } else if attr.name == "source_port" {
                        source_port = attr.default_value;
                    } else if attr.name == "target_port" {
                        target_port = attr.default_value;
                    }
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(RiskDef {
            name,
            doc,
            severity,
            hazard_ref,
            source_port,
            target_port,
        })
    }

    fn parse_test_case_decl(&mut self, doc: Option<String>) -> Result<TestCaseDef, ParseError> {
        self.expect(&TokenKind::Test)?;
        if self.check(&TokenKind::Case) {
            self.advance();
        }
        if self.check(&TokenKind::Def) {
            self.advance();
        }

        let name = self.expect_ident()?;
        let mut subject_part = None;
        let mut verified_requirements = Vec::new();
        let mut objective = None;
        let mut test_steps = Vec::new();

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                if self.check(&TokenKind::Subject) {
                    self.advance();
                    subject_part = Some(self.read_until_semi());
                } else if self.check(&TokenKind::Verify) {
                    self.advance();
                    if self.check(&TokenKind::Requirement) {
                        self.advance();
                    }
                    verified_requirements.push(self.read_until_semi());
                } else if self.check(&TokenKind::Objective) {
                    self.advance();
                    objective = Some(self.read_until_semi());
                } else if self.check(&TokenKind::Step) {
                    self.advance();
                    test_steps.push(self.read_until_semi());
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(TestCaseDef {
            name,
            subject_part,
            verified_requirements,
            objective,
            test_steps,
            doc,
        })
    }

    fn parse_capability_decl(&mut self, doc: Option<String>) -> Result<CapabilityDef, ParseError> {
        self.expect(&TokenKind::Capability)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }
        let name = self.expect_ident()?;
        let mut subsystem = None;

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                if self.check(&TokenKind::Subsystem) {
                    self.advance();
                    subsystem = Some(self.read_until_semi());
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(CapabilityDef {
            name,
            description: doc.clone(),
            subsystem,
            package_ref: None,
            doc,
        })
    }

    fn parse_operation_decl(&mut self, doc: Option<String>) -> Result<OperationDef, ParseError> {
        self.expect(&TokenKind::Operation)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }
        let name = self.expect_ident()?;
        let mut return_type = None;
        let mut parameters = Vec::new();

        if self.check(&TokenKind::OpenParen) {
            self.advance();
            while !self.check(&TokenKind::CloseParen) && !self.is_at_end() {
                let mut dir = "in".to_string();
                if self.check(&TokenKind::In) {
                    self.advance();
                } else if self.check(&TokenKind::Out) {
                    self.advance();
                    dir = "out".to_string();
                } else if self.check(&TokenKind::Inout) {
                    self.advance();
                    dir = "inout".to_string();
                }
                let p_name = self.expect_ident()?;
                let p_type = if self.check(&TokenKind::Colon) {
                    self.advance();
                    self.expect_ident()?
                } else {
                    "String".to_string()
                };
                parameters.push(AttributeDef {
                    name: p_name,
                    type_name: p_type,
                    default_value: Some(dir),
                    doc: None,
                });
                if self.check(&TokenKind::Comma) {
                    self.advance();
                }
            }
            self.expect(&TokenKind::CloseParen)?;
        }

        if self.check(&TokenKind::Colon) {
            self.advance();
            return_type = Some(self.expect_ident()?);
        }

        self.expect_semi()?;

        Ok(OperationDef {
            name,
            direction: "inout".to_string(),
            param_type: "String".to_string(),
            return_type,
            doc,
            parameters,
        })
    }

    fn parse_interaction_decl(&mut self, doc: Option<String>) -> Result<InteractionDef, ParseError> {
        self.expect(&TokenKind::Interaction)?;
        if self.check(&TokenKind::Def) {
            self.advance();
        }
        let name = self.expect_ident()?;
        let mut lifelines = Vec::new();
        let mut messages = Vec::new();
        let mut triggers = Vec::new();

        if self.check(&TokenKind::OpenBrace) {
            self.advance();
            while !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
                self.skip_trivia();
                if self.check(&TokenKind::Lifeline) {
                    self.advance();
                    lifelines.push(self.read_until_semi());
                } else if self.check(&TokenKind::Message) {
                    self.advance();
                    messages.push(self.read_until_semi());
                } else if self.check(&TokenKind::Trigger) {
                    self.advance();
                    triggers.push(self.read_until_semi());
                } else {
                    self.skip_until_semi_or_brace();
                }
            }
            self.expect(&TokenKind::CloseBrace)?;
        } else {
            self.expect_semi()?;
        }

        Ok(InteractionDef {
            name,
            lifelines,
            messages,
            triggers,
            doc,
        })
    }

    // --- Helper Methods ---

    fn skip_trivia(&mut self) {
        while !self.is_at_end() {
            match self.peek_kind() {
                TokenKind::LineComment(_) => {
                    self.advance();
                }
                TokenKind::Semi => {
                    self.advance();
                }
                _ => break,
            }
        }
    }

    fn take_doc_comment(&mut self) -> Option<String> {
        if let TokenKind::DocComment(text) = self.peek_kind().clone() {
            self.advance();
            Some(text)
        } else {
            None
        }
    }

    fn check(&self, kind: &TokenKind) -> bool {
        if self.is_at_end() {
            false
        } else {
            std::mem::discriminant(&self.tokens[self.pos].kind) == std::mem::discriminant(kind)
        }
    }

    fn peek(&self) -> &Token {
        &self.tokens[self.pos]
    }

    fn peek_kind(&self) -> &TokenKind {
        if self.is_at_end() {
            &TokenKind::Eof
        } else {
            &self.tokens[self.pos].kind
        }
    }

    fn advance(&mut self) -> &Token {
        let tok = &self.tokens[self.pos];
        if self.pos < self.tokens.len() {
            self.pos += 1;
        }
        tok
    }

    fn is_at_end(&self) -> bool {
        self.pos >= self.tokens.len() || self.tokens[self.pos].kind == TokenKind::Eof
    }

    fn expect(&mut self, expected: &TokenKind) -> Result<&Token, ParseError> {
        if self.check(expected) {
            Ok(self.advance())
        } else {
            let tok = self.peek();
            Err(ParseError {
                message: format!("Expected '{:?}', found '{:?}'", expected, tok.kind),
                span: tok.span,
            })
        }
    }

    /// Parse an identifier or contextual keyword accepted in identifier positions.
    ///
    /// Realises: [REQ-SYSML-CONTEXTUAL-IDENTIFIERS]
    pub fn parse_identifier(&mut self) -> Result<String, ParseError> {
        let tok = self.peek();
        match &tok.kind {
            TokenKind::Ident(s) => {
                let name = s.clone();
                self.advance();
                Ok(name)
            }
            // Contextual keywords accepted as identifiers in KerML / SysML v2 syntax
            TokenKind::Text
            | TokenKind::Doc
            | TokenKind::Item
            | TokenKind::State
            | TokenKind::Action
            | TokenKind::Port
            | TokenKind::Requirement
            | TokenKind::Constraint
            | TokenKind::Assert
            | TokenKind::Assume
            | TokenKind::Require
            | TokenKind::Verify
            | TokenKind::Satisfy
            | TokenKind::Calc
            | TokenKind::Test
            | TokenKind::Case
            | TokenKind::Hazard
            | TokenKind::Risk
            | TokenKind::Objective
            | TokenKind::Capability
            | TokenKind::Interaction
            | TokenKind::Lifeline
            | TokenKind::Message
            | TokenKind::Connection
            | TokenKind::Connect
            | TokenKind::From
            | TokenKind::To
            | TokenKind::By
            | TokenKind::Attribute
            | TokenKind::Id
            | TokenKind::In
            | TokenKind::Out
            | TokenKind::Inout
            | TokenKind::Operation
            | TokenKind::Transition
            | TokenKind::Entry
            | TokenKind::Exit
            | TokenKind::Perform
            | TokenKind::Step
            | TokenKind::Trigger
            | TokenKind::Include
            | TokenKind::Extend
            | TokenKind::Precondition
            | TokenKind::Postcondition
            | TokenKind::Subsystem
            | TokenKind::Subject
            | TokenKind::Actor
            | TokenKind::Flow
            | TokenKind::Interface
            | TokenKind::Package
            | TokenKind::Part
            | TokenKind::Def
            | TokenKind::Do => {
                let name = tok.kind.as_str().to_string();
                self.advance();
                Ok(name)
            }
            _ => Err(ParseError {
                message: format!("Expected identifier, found '{:?}'", tok.kind),
                span: tok.span,
            }),
        }
    }

    fn expect_ident(&mut self) -> Result<String, ParseError> {
        self.parse_identifier()
    }

    fn expect_ident_or_dotted(&mut self) -> Result<String, ParseError> {
        let mut result = self.expect_ident()?;
        while self.check(&TokenKind::Dot) {
            self.advance();
            let next_part = self.expect_ident()?;
            result.push('.');
            result.push_str(&next_part);
        }
        Ok(result)
    }

    fn expect_string_or_ident(&mut self) -> Result<String, ParseError> {
        let tok = self.peek();
        if let TokenKind::StringLit(s) = &tok.kind {
            let val = s.clone();
            self.advance();
            return Ok(val);
        }
        self.parse_identifier().map_err(|_| {
            let tok = self.peek();
            ParseError {
                message: format!("Expected string or identifier, found '{:?}'", tok.kind),
                span: tok.span,
            }
        })
    }

    fn expect_semi(&mut self) -> Result<(), ParseError> {
        if self.check(&TokenKind::Semi) {
            self.advance();
            Ok(())
        } else {
            let tok = self.peek();
            Err(ParseError {
                message: format!("Expected ';' statement terminator, found '{:?}'", tok.kind),
                span: tok.span,
            })
        }
    }

    fn read_until_semi(&mut self) -> String {
        let mut pieces = Vec::new();
        while !self.check(&TokenKind::Semi) && !self.check(&TokenKind::CloseBrace) && !self.is_at_end() {
            let tok = self.advance();
            match &tok.kind {
                TokenKind::Ident(s) => pieces.push(s.clone()),
                TokenKind::StringLit(s) => pieces.push(format!("\"{}\"", s)),
                TokenKind::IntLit(n) => pieces.push(n.to_string()),
                TokenKind::RealLit(f) => {
                    if f.fract() == 0.0 {
                        pieces.push(format!("{:.1}", f));
                    } else {
                        pieces.push(f.to_string());
                    }
                }
                TokenKind::BoolLit(b) => pieces.push(b.to_string()),
                _ => pieces.push(tok.kind.as_str().to_string()),
            }
        }
        if self.check(&TokenKind::Semi) {
            self.advance();
        }
        pieces.join(" ")
    }

    fn skip_until_semi_or_brace(&mut self) {
        let mut depth = 0;
        while !self.is_at_end() {
            match self.peek_kind() {
                TokenKind::OpenBrace => {
                    depth += 1;
                    self.advance();
                }
                TokenKind::CloseBrace => {
                    if depth == 0 {
                        break;
                    }
                    depth -= 1;
                    self.advance();
                    if depth == 0 {
                        break;
                    }
                }
                TokenKind::Semi => {
                    if depth == 0 {
                        self.advance();
                        break;
                    }
                    self.advance();
                }
                _ => {
                    self.advance();
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_ground_truth_model_fixture() {
        let fixture = include_str!("../../../../tests/fixtures/safety/ground_truth_model.sysml");
        let pkg = SysmlParser::parse_source(fixture, "TestModel").unwrap();

        assert_eq!(pkg.name, "AutonomousVehicle_SSOT");
        assert_eq!(
            pkg.doc.as_deref(),
            Some("SSOT for Autonomous System Architecture and Safety Model")
        );
        assert_eq!(pkg.attribute_defs.len(), 4);
        assert_eq!(pkg.attribute_defs[0].name, "ruddervatorCount");
        assert_eq!(pkg.attribute_defs[0].type_name, "Integer");
        assert_eq!(pkg.attribute_defs[0].default_value.as_deref(), Some("4"));

        assert_eq!(pkg.part_defs.len(), 2);
        let airframe = &pkg.part_defs[0];
        assert_eq!(airframe.name, "Airframe");
        assert_eq!(airframe.attributes.len(), 1);
        assert_eq!(airframe.attributes[0].name, "massKg");
        assert_eq!(airframe.attributes[0].default_value.as_deref(), Some("25.0"));

        let fcc = &pkg.part_defs[1];
        assert_eq!(fcc.name, "FlightControlComputer");
        assert_eq!(fcc.ports.len(), 2);
        assert_eq!(fcc.ports[0].name, "c2_bus");
        assert_eq!(fcc.ports[0].type_name, "RS485");
        assert_eq!(fcc.ports[1].name, "telemetry");
        assert_eq!(fcc.ports[1].type_name, "MAVLink");
    }

    #[test]
    fn test_parse_grounded_limits_model_fixture() {
        let fixture = include_str!("../../../../tests/fixtures/safety/grounded_limits_model.sysml");
        let pkg = SysmlParser::parse_source(fixture, "TestLimits").unwrap();

        assert_eq!(pkg.name, "GroundedLimits_SSOT");
        assert_eq!(
            pkg.doc.as_deref(),
            Some("Ground truth limits for flight envelope verification")
        );
        assert_eq!(pkg.attribute_defs.len(), 5);
        assert_eq!(pkg.attribute_defs[0].name, "catapultPressureLimitBar");
        assert_eq!(pkg.attribute_defs[0].default_value.as_deref(), Some("15.0"));
    }

    #[test]
    fn test_parse_complex_system_model() {
        let source = r#"
package FlightControl_SSOT {
    doc /* Primary Flight Control and Mission Computer Architecture */

    attribute maxRollRateDps : Real = 45.0;
    attribute maxPitchAngleDeg : Real = 30.0;

    part def NavigationSubsystem {
        doc /* GPS, IMU and Sensor Fusion Unit */
        port out nav_solution : NavData;
        port in correction_stream : ~NavCorrection;

        action def ComputeNavigationState {
            in rawImu : ImuPacket;
            out filteredState : NavState;
        }

        state def NavFilterState {
            entry InitINS;
            do RunEKF;
            exit ResetCovariance;
        }
    }

    part def ActuatorController {
        port in servo_cmd : ~ServoCommand;
        port out status : ActuatorStatus;

        assert constraint DeflectionBounds {
            deflectionDeg >= -25.0 && deflectionDeg <= 25.0;
        }
    }

    connection def NavToActuatorBus {
        doc /* High speed deterministic bus connection */
        connect NavigationSubsystem.nav_solution to ActuatorController.servo_cmd;
        attribute protocol : String = "CANopen";
        attribute latency_ms : Real = 2.5;
    }

    requirement def Req_Nav_001 {
        id = "REQ-NAV-001";
        text = "Navigation system shall compute attitude at minimum 100 Hz.";
        require latency <= 10.0;
        verify by HardwareInLoopTest;
        satisfy by NavigationSubsystem;
    }
}
"#;
        let pkg = SysmlParser::parse_source(source, "Default").unwrap();
        assert_eq!(pkg.name, "FlightControl_SSOT");
        assert_eq!(
            pkg.doc.as_deref(),
            Some("Primary Flight Control and Mission Computer Architecture")
        );
        assert_eq!(pkg.attribute_defs.len(), 2);
        assert_eq!(pkg.part_defs.len(), 2);

        let nav = &pkg.part_defs[0];
        assert_eq!(nav.name, "NavigationSubsystem");
        assert_eq!(nav.doc.as_deref(), Some("GPS, IMU and Sensor Fusion Unit"));
        assert_eq!(nav.ports.len(), 2);
        assert_eq!(nav.ports[0].direction, "out");
        assert_eq!(nav.ports[0].name, "nav_solution");
        assert_eq!(nav.ports[1].direction, "in");
        assert_eq!(nav.ports[1].is_conjugated, true);
        assert_eq!(nav.ports[1].name, "correction_stream");
        assert_eq!(nav.actions.len(), 1);
        assert_eq!(nav.actions[0].name, "ComputeNavigationState");
        assert_eq!(nav.states.len(), 1);
        assert_eq!(nav.states[0].name, "NavFilterState");
        assert_eq!(nav.states[0].entry_action.as_deref(), Some("InitINS"));
        assert_eq!(nav.states[0].do_action.as_deref(), Some("RunEKF"));

        let actuator = &pkg.part_defs[1];
        assert_eq!(actuator.name, "ActuatorController");
        assert_eq!(actuator.constraints.len(), 1);
        assert_eq!(actuator.constraints[0].name, "DeflectionBounds");
        assert_eq!(actuator.constraints[0].is_assertion, true);
        assert!(actuator.constraints[0].expression.contains("deflectionDeg"));

        assert_eq!(pkg.connection_defs.len(), 1);
        let conn = &pkg.connection_defs[0];
        assert_eq!(conn.name, "NavToActuatorBus");
        assert_eq!(conn.source_port, "NavigationSubsystem.nav_solution");
        assert_eq!(conn.target_port, "ActuatorController.servo_cmd");
        assert_eq!(conn.source_part.as_deref(), Some("NavigationSubsystem"));
        assert_eq!(conn.target_part.as_deref(), Some("ActuatorController"));
        assert_eq!(conn.protocol.as_deref(), Some("CANopen"));
        assert_eq!(conn.latency_ms, Some(2.5));

        assert_eq!(pkg.requirement_defs.len(), 1);
        let req = &pkg.requirement_defs[0];
        assert_eq!(req.name, "Req_Nav_001");
        assert_eq!(req.req_id, "REQ-NAV-001");
        assert_eq!(
            req.text,
            "Navigation system shall compute attitude at minimum 100 Hz."
        );
        assert_eq!(req.verified_by, vec!["HardwareInLoopTest"]);
        assert_eq!(req.satisfied_by, vec!["NavigationSubsystem"]);
    }

    #[test]
    fn test_parse_contextual_keywords_as_identifiers() {
        let source = r#"
package TestPkg {
    part def Component {
        attribute text : String = "hello";
        attribute doc : String = "world";
        attribute item : String = "val";
        attribute state : String = "ready";
        attribute action : String = "run";
        attribute port : String = "port1";
    }
}
"#;
        let pkg = SysmlParser::parse_source(source, "Default").unwrap();
        assert_eq!(pkg.name, "TestPkg");
        let comp = &pkg.part_defs[0];
        assert_eq!(comp.name, "Component");
        assert_eq!(comp.attributes.len(), 6);
        assert_eq!(comp.attributes[0].name, "text");
        assert_eq!(comp.attributes[1].name, "doc");
        assert_eq!(comp.attributes[2].name, "item");
        assert_eq!(comp.attributes[3].name, "state");
        assert_eq!(comp.attributes[4].name, "action");
        assert_eq!(comp.attributes[5].name, "port");
    }
}

