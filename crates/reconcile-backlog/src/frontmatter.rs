//! Specification frontmatter extraction and updating.
//!
//! Realises: [Zero-Placeholder Invariant, Strict Schema-Driven Spec Frontmatter]

use std::collections::HashMap;

/// Parsed metadata from a specification file.
#[derive(Debug, Clone, PartialEq, Default)]
pub struct SpecFrontmatter {
    pub title: String,
    pub spec_type: String,
    pub issue_id: Option<u64>,
    pub epic: Option<String>,
    pub subsystem: Option<String>,
    pub part: Option<String>,
    pub version: Option<String>,
    pub date: Option<String>,
    pub raw_fields: HashMap<String, String>,
}

/// Extracts YAML frontmatter key-value pairs and metadata from markdown content.
pub fn parse_frontmatter(content: &str) -> Option<SpecFrontmatter> {
    let trimmed = content.trim_start();
    if !trimmed.starts_with("---") {
        return None;
    }
    let rest = trimmed.strip_prefix("---")?;
    let end_idx = rest.find("\n---")?;
    let fm_block = rest.get(..end_idx)?;

    let mut raw_fields = HashMap::new();
    let mut title = String::new();
    let mut spec_type = String::new();
    let mut issue_id = None;
    let mut epic = None;
    let mut subsystem = None;
    let mut part = None;
    let mut version = None;
    let mut date = None;

    for line in fm_block.lines() {
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        if let Some((k, v)) = line.split_once(':') {
            let key = k.trim().trim_matches(|c| c == '\'' || c == '"').to_lowercase();
            let val = v.trim().trim_matches(|c| c == '\'' || c == '"').to_string();
            if key.is_empty() {
                continue;
            }

            match key.as_str() {
                "title" => title = val.clone(),
                "type" => spec_type = val.clone(),
                "issue_id" => {
                    let cleaned = val.trim_start_matches('#').trim();
                    if let Ok(id) = cleaned.parse::<u64>() {
                        issue_id = Some(id);
                    }
                }
                "epic" => epic = Some(val.clone()),
                "subsystem" => subsystem = Some(val.clone()),
                "part" => part = Some(val.clone()),
                "version" => version = Some(val.clone()),
                "date" => date = Some(val.clone()),
                _ => {}
            }
            raw_fields.insert(key, val);
        }
    }

    // Fallback: title from # H1 heading if not in frontmatter
    if title.is_empty() {
        for line in content.lines() {
            let trimmed_line = line.trim();
            if trimmed_line.starts_with("# ") {
                title = trimmed_line.trim_start_matches("# ").trim().to_string();
                break;
            }
        }
    }

    Some(SpecFrontmatter {
        title,
        spec_type,
        issue_id,
        epic,
        subsystem,
        part,
        version,
        date,
        raw_fields,
    })
}

/// Updates or injects `issue_id: <num>` in the YAML frontmatter and CommonMark metadata table.
///
/// Preserves existing formatting, comments, and field ordering.
pub fn update_frontmatter_issue_id(content: &str, issue_id: u64) -> String {
    let trimmed = content.trim_start();
    if !trimmed.starts_with("---") {
        // No frontmatter, inject at start
        let new_fm = format!("---\nissue_id: {}\n---\n\n{}", issue_id, content);
        return new_fm;
    }

    let rest = match trimmed.strip_prefix("---") {
        Some(r) => r,
        None => return content.to_string(),
    };

    let end_idx = match rest.find("\n---") {
        Some(idx) => idx,
        None => return content.to_string(),
    };

    let fm_block = &rest[..end_idx];
    let after_fm = &rest[end_idx..]; // Starts with "\n---"

    let mut has_issue_id = false;
    let mut new_lines = Vec::new();

    for line in fm_block.lines() {
        let trimmed_line = line.trim();
        if let Some((k, _)) = trimmed_line.split_once(':') {
            let key = k.trim().trim_matches(|c| c == '\'' || c == '"').to_lowercase();
            if key == "issue_id" {
                new_lines.push(format!("issue_id: {}", issue_id));
                has_issue_id = true;
                continue;
            }
        }
        new_lines.push(line.to_string());
    }

    if !has_issue_id {
        new_lines.push(format!("issue_id: {}", issue_id));
    }

    let updated_fm = format!("---\n{}\n---", new_lines.join("\n"));
    let body_with_closing = after_fm.strip_prefix("\n---").unwrap_or(after_fm);
    let mut updated_full = format!("{}{}", updated_fm, body_with_closing);

    // Also update CommonMark metadata table if present:
    // | **Issue ID** | #... |  or  | **Issue ID** | #[IssueID] |
    let table_issue_regex = regex::Regex::new(r"(?i)(\|\s*\*\*Issue ID\*\*\s*\|\s*)(#[^\s|]+|\d+)(\s*\|)").unwrap();
    if table_issue_regex.is_match(&updated_full) {
        let replacement = format!("${{1}}#{}${{3}}", issue_id);
        updated_full = table_issue_regex.replace(&updated_full, replacement.as_str()).to_string();
    }

    updated_full
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_frontmatter_epic() {
        let content = r#"---
title: "Epic 01: System Architecture"
version: "1.0.0"
date: "2026-10-10"
type: epic
package: "DEAP_Compiler_System"
subsystem: "System Architecture"
issue_id: 101
generation_mode: subagent
---

# Epic 01: System Architecture
"#;
        let fm = parse_frontmatter(content).expect("Parsed frontmatter");
        assert_eq!(fm.title, "Epic 01: System Architecture");
        assert_eq!(fm.spec_type, "epic");
        assert_eq!(fm.issue_id, Some(101));
        assert_eq!(fm.subsystem.as_deref(), Some("System Architecture"));
    }

    #[test]
    fn test_update_frontmatter_issue_id_existing() {
        let content = r#"---
title: "Feature 01: Test"
type: feature
issue_id: 10
---

## Metadata
| Attribute | Specification Detail |
| :--- | :--- |
| **Title** | Feature 01: Test |
| **Issue ID** | #10 |
"#;
        let updated = update_frontmatter_issue_id(content, 42);
        assert!(updated.contains("issue_id: 42"));
        assert!(updated.contains("| **Issue ID** | #42 |"));
        assert!(!updated.contains("issue_id: 10"));
    }

    #[test]
    fn test_update_frontmatter_issue_id_insert() {
        let content = r#"---
title: "Feature 01: Test"
type: feature
---

## Metadata
| Attribute | Specification Detail |
| :--- | :--- |
| **Issue ID** | #[IssueID] |
"#;
        let updated = update_frontmatter_issue_id(content, 55);
        assert!(updated.contains("issue_id: 55"));
        assert!(updated.contains("| **Issue ID** | #55 |"));
    }
}
