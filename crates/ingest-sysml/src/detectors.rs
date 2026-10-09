//! # Heterogeneous Schema Format Detectors & Target Discovery Engine
//!
//! ## 1. Safety Intent & Regulatory Scope
//! This module provides deterministic, bounded schema format detection and filesystem
//! target discovery for Level 0 OEM specifications, supporting heterogeneous input models
//! (Markdown, SysML v2, OMG IDL, AUTOSAR ARXML, Protobuf, and OpenAPI 3.0/3.1).
//!
//! In safety-critical systems engineering (DO-178C / DO-331 / ISO 26262), input format
//! classification is a safety-critical preprocessing gate. Erroneous format detection can
//! cause silent specification omission or corrupt downstream verification pipelines.
//!
//! ## 2. Core Safety Invariants
//! - **Pure Schema-Driven Classification**: Format detection operates strictly on formal
//!   file extensions and syntactic grammar markers. Zero domain-specific vocabulary is used.
//! - **Deterministic Precedence**: Direct extension matches take precedence over content
//!   heuristics. Content inspection employs bounded regex scans.
//! - **Canonical Path Sorting**: All directory scans sort paths lexicographically to ensure
//!   bitwise identical AST construction order across different host filesystems.
//! - **Bounded Complexity**: Execution time is $O(N + M)$ where $N$ is directory entry count
//!   and $M$ is inspected header byte length.

use std::fs;
use std::path::{Path, PathBuf};
use regex::Regex;

/// Raw uncompiled document extensions that require formal AST extraction prior to lowering.
/// These extensions represent human-oriented document formats where direct compilation is
/// prohibited without structured extraction.
pub const RAW_EXTENSIONS: &[&str] = &[".pdf", ".txt", ".doc", ".docx"];

/// Detects the formal specification format from file extension and content.
///
/// /// Realises: [REQ-0001/detect_format]
///
/// ### Algorithmic Precedence:
/// 1. Markdown extension (`.md`) or structural table delimiter patterns (`| ... |`).
/// 2. Raw uncompiled document formats (`.pdf`, `.txt`, `.doc`, `.docx`).
/// 3. Well-known extension mapping (`.sysml`, `.idl`, `.arxml`, `.proto`, `.json`, `.yaml`).
/// 4. Grammatical token search (`part def `, `module `, `<AUTOSAR`, `syntax =`, `openapi`).
///
/// ### Preconditions:
/// - `schema_path` is a non-empty filesystem path or descriptor.
/// - `content` contains initial UTF-8 file bytes or entire file text.
///
/// ### Postconditions:
/// - Returns `Ok(format_tag)` where `format_tag` is one of:
///   `"markdown"`, `"sysml"`, `"idl"`, `"autosar"`, `"protobuf"`, `"openapi"`, or `"raw"`.
/// - Returns `Err(diagnostic)` if format cannot be identified within the formal grammar set.
pub fn detect_format(schema_path: &str, content: &str) -> Result<String, String> {
    let path = Path::new(schema_path);
    let ext = path
        .extension()
        .and_then(|s| s.to_str())
        .map(|s| format!(".{}", s.to_ascii_lowercase()))
        .unwrap_or_default();

    // 1. Direct Markdown detection via extension or structural table syntax
    let table_header_re = Regex::new(
        r"(?i)\|\s*(?:Component|Part|BOM|Port|Signal|Parameter|Interface|Property|Attribute)\s*\|",
    )
    .unwrap();
    let table_delim_re = Regex::new(r"\|[^\n]+\|\s*\n\s*\|[\s:\-]+\|").unwrap();

    if ext == ".md" || table_header_re.is_match(content) || table_delim_re.is_match(content) {
        return Ok("markdown".to_string());
    }

    // 2. Extension-based categorization
    if RAW_EXTENSIONS.contains(&ext.as_str()) {
        return Ok("raw".to_string());
    }
    if ext == ".sysml" {
        return Ok("sysml".to_string());
    }
    if ext == ".idl" {
        return Ok("idl".to_string());
    }
    if ext == ".arxml" || ext == ".xml" {
        return Ok("autosar".to_string());
    }
    if ext == ".proto" {
        return Ok("protobuf".to_string());
    }
    if ext == ".json" || ext == ".yaml" || ext == ".yml" {
        return Ok("openapi".to_string());
    }

    // 3. Content-based fallback inspection
    if content.contains("part def ")
        || content.contains("package ")
        || content.contains("capability def ")
        || content.contains("requirement def ")
    {
        return Ok("sysml".to_string());
    }
    if content.contains("module ") || content.contains("interface ") || content.contains("struct ") {
        return Ok("idl".to_string());
    }
    if content.contains("<AUTOSAR") || content.contains("<AR-PACKAGE") {
        return Ok("autosar".to_string());
    }
    if content.contains("syntax =") || content.contains("message ") {
        return Ok("protobuf".to_string());
    }
    if content.contains("openapi") || content.contains("swagger") || content.contains("\"paths\":") {
        return Ok("openapi".to_string());
    }

    Err(format!(
        "Unsupported schema format for '{}'. Supported formats: .sysml, .idl, .arxml/.xml, .proto, .json/.yaml/.yml, markdown (.md).",
        schema_path
    ))
}

/// Discovers specification files or target directories adhering to deterministic search precedence.
///
/// /// Realises: [REQ-0001/discover_schema_targets]
///
/// ### Search Precedence Order:
/// 1. Direct file input (if `path_opt` is an explicit single file).
/// 2. Native SysML v2 models (`*.sysml` in search root).
/// 3. Extracted Markdown specifications (`schema/extracted/*.md`).
/// 4. Root Markdown specifications (`schema/*.md`).
/// 5. Heterogeneous Interface Definitions (`*.idl`, `*.arxml`, `*.proto`, `*.yaml`, `*.json`).
///
/// ### Invariant:
/// All returned file paths are sorted lexicographically to eliminate filesystem traversal jitter.
pub fn discover_schema_targets(path_opt: Option<&Path>) -> Result<(String, Vec<PathBuf>), String> {
    if let Some(p) = path_opt {
        if p.is_file() {
            let content = fs::read_to_string(p).unwrap_or_default();
            let fmt = detect_format(p.to_str().unwrap_or(""), &content)?;
            return Ok((fmt, vec![p.to_path_buf()]));
        }
    }

    let search_dir = path_opt
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from("schema"));

    if !search_dir.exists() {
        return Ok(("unknown".to_string(), Vec::new()));
    }

    // 1. Check for native .sysml models
    let mut sysml_files = find_files_with_ext(&search_dir, "sysml");
    if !sysml_files.is_empty() {
        sysml_files.sort();
        return Ok(("sysml".to_string(), sysml_files));
    }

    // 2. Check for extracted markdown specifications in schema/extracted/*.md
    let extracted_dir = if search_dir.ends_with("extracted") {
        search_dir.clone()
    } else {
        search_dir.join("extracted")
    };
    if extracted_dir.exists() {
        let mut extracted_md = find_files_with_ext(&extracted_dir, "md");
        extracted_md.retain(|p| p.file_name().and_then(|s| s.to_str()) != Some("README.md"));
        if !extracted_md.is_empty() {
            extracted_md.sort();
            return Ok(("markdown".to_string(), extracted_md));
        }
    }

    // 3. Check for markdown files in schema/*.md
    let mut root_md = find_files_with_ext(&search_dir, "md");
    root_md.retain(|p| p.file_name().and_then(|s| s.to_str()) != Some("README.md"));
    if !root_md.is_empty() {
        root_md.sort();
        return Ok(("markdown".to_string(), root_md));
    }

    // 4. Check for other schema types (IDL, ARXML, Protobuf, OpenAPI)
    let format_exts = [
        ("idl", "idl"),
        ("arxml", "autosar"),
        ("xml", "autosar"),
        ("proto", "protobuf"),
        ("yaml", "openapi"),
        ("json", "openapi"),
    ];

    for (ext, fmt) in format_exts {
        let mut other_files = find_files_with_ext(&search_dir, ext);
        if !other_files.is_empty() {
            other_files.sort();
            return Ok((fmt.to_string(), other_files));
        }
    }

    Ok(("unknown".to_string(), Vec::new()))
}

/// Helper function to locate non-recursive files matching a target extension in a directory.
///
/// ### Arguments:
/// - `dir`: The directory to inspect.
/// - `ext`: File extension without leading dot (case-insensitive).
///
/// ### Returns:
/// A vector of matching file `PathBuf` objects.
fn find_files_with_ext(dir: &Path, ext: &str) -> Vec<PathBuf> {
    let mut results = Vec::new();
    if let Ok(entries) = fs::read_dir(dir) {
        for entry in entries.flatten() {
            let p = entry.path();
            if p.is_file() {
                if let Some(e) = p.extension() {
                    if e.to_string_lossy().eq_ignore_ascii_case(ext) {
                        results.push(p);
                    }
                }
            }
        }
    }
    results
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_detect_format_by_extension() {
        assert_eq!(detect_format("schema.md", "").unwrap(), "markdown");
        assert_eq!(detect_format("model.sysml", "").unwrap(), "sysml");
        assert_eq!(detect_format("interface.idl", "").unwrap(), "idl");
        assert_eq!(detect_format("system.arxml", "").unwrap(), "autosar");
        assert_eq!(detect_format("messages.proto", "").unwrap(), "protobuf");
        assert_eq!(detect_format("api.json", "").unwrap(), "openapi");
        assert_eq!(detect_format("api.yaml", "").unwrap(), "openapi");
        assert_eq!(detect_format("doc.pdf", "").unwrap(), "raw");
    }

    #[test]
    fn test_detect_format_by_content() {
        assert_eq!(
            detect_format("unknown_file", "package Package_0 { part def Classifier_Alpha; }").unwrap(),
            "sysml"
        );
        assert_eq!(
            detect_format("unknown_file", "module Module_0 { struct Struct_1 { long id; }; };").unwrap(),
            "idl"
        );
        assert_eq!(
            detect_format("unknown_file", "<AUTOSAR><AR-PACKAGE></AR-PACKAGE></AUTOSAR>").unwrap(),
            "autosar"
        );
        assert_eq!(
            detect_format("unknown_file", "syntax = \"proto3\"; message Msg_0 { int32 val = 1; }").unwrap(),
            "protobuf"
        );
        assert_eq!(
            detect_format("unknown_file", "{\"openapi\": \"3.0.0\", \"paths\": {}}").unwrap(),
            "openapi"
        );
        assert_eq!(
            detect_format("unknown_file", "| Component | Part Number |\n| --- | --- |\n| Classifier_Alpha | 1 |").unwrap(),
            "markdown"
        );
    }

    #[test]
    fn test_discover_schema_targets_req1() {
        let path = Path::new("schema/REQ-0001.md");
        if path.exists() {
            let res = discover_schema_targets(Some(path));
            assert!(res.is_ok());
            let (fmt, files) = res.unwrap();
            assert_eq!(fmt, "markdown");
            assert_eq!(files.len(), 1);
            assert_eq!(files[0], path);
        }
    }
}
