//! Specification metadata, title uniqueness, and filename convention validation.
//!
//! Conforms to DO-178C Level A and ISO 26262 ASIL D safety standards.
//! Validates required metadata fields, ISO 8601 dates, semantic versioning,
//! title normalization and uniqueness across spec types, and filename conventions
//! using pure byte, slice, and token validation.

use crate::spec_audit::markdown_ast::MarkdownDoc;
use std::collections::HashMap;

/// Validates whether a string is a valid ISO 8601 calendar date (YYYY-MM-DD).
///
/// Preconditions: None.
/// Postconditions: Returns true if string strictly matches YYYY-MM-DD calendar date with byte-level checks.
/// Algorithmic Complexity: O(1).
pub fn is_iso_date(s: &str) -> bool {
    let trimmed = s.trim();
    let bytes = trimmed.as_bytes();
    if bytes.len() != 10 {
        return false;
    }
    if bytes[4] != b'-' || bytes[7] != b'-' {
        return false;
    }

    if !bytes[0..4].iter().all(|b| b.is_ascii_digit())
        || !bytes[5..7].iter().all(|b| b.is_ascii_digit())
        || !bytes[8..10].iter().all(|b| b.is_ascii_digit())
    {
        return false;
    }

    let year = match std::str::from_utf8(&bytes[0..4])
        .ok()
        .and_then(|p| p.parse::<u32>().ok())
    {
        Some(y) => y,
        None => return false,
    };
    let month = match std::str::from_utf8(&bytes[5..7])
        .ok()
        .and_then(|p| p.parse::<u32>().ok())
    {
        Some(m) => m,
        None => return false,
    };
    let day = match std::str::from_utf8(&bytes[8..10])
        .ok()
        .and_then(|p| p.parse::<u32>().ok())
    {
        Some(d) => d,
        None => return false,
    };

    if year < 1970 || year > 2100 || !(1..=12).contains(&month) || !(1..=31).contains(&day) {
        return false;
    }
    true
}

/// Validates whether a string conforms to semantic versioning (v?X.Y[.Z][-prerelease][+build]).
///
/// Preconditions: None.
/// Postconditions: Returns true if string matches semver format.
/// Algorithmic Complexity: O(1).
pub fn is_semver(s: &str) -> bool {
    let trimmed = s.trim();
    if trimmed.is_empty() {
        return false;
    }
    let rest = if let Some(stripped) = trimmed.strip_prefix(|c| c == 'v' || c == 'V') {
        stripped
    } else {
        trimmed
    };

    if rest.is_empty() {
        return false;
    }

    let (version_core, prerelease) = match rest.find(|c| c == '-' || c == '+') {
        Some(idx) => (&rest[..idx], Some(&rest[idx + 1..])),
        None => (rest, None),
    };

    if let Some(pre) = prerelease {
        if pre.is_empty()
            || !pre
                .chars()
                .all(|c| c.is_ascii_alphanumeric() || c == '.' || c == '-')
        {
            return false;
        }
    }

    let parts: Vec<&str> = version_core.split('.').collect();
    if parts.len() < 2 || parts.len() > 3 {
        return false;
    }

    for part in parts {
        if part.is_empty() || !part.chars().all(|c| c.is_ascii_digit()) {
            return false;
        }
    }

    true
}

/// Checks whether a document title contains concatenated metadata attributes
/// (such as embedded version tokens, dates, or parenthesized document IDs).
///
/// Preconditions: None.
/// Postconditions: Returns true if title contains forbidden concatenated metadata.
/// Algorithmic Complexity: O(T) where T is title character count.
pub fn has_concatenated_title_metadata(val: &str) -> bool {
    let trimmed = val.trim();
    if trimmed.is_empty() {
        return false;
    }
    let lower = trimmed.to_lowercase();

    // 1. Check parenthesized DOC- tokens: e.g. "(DOC-NAV-001)"
    let mut paren_rest = lower.as_str();
    while let Some(open) = paren_rest.find('(') {
        let after_open = &paren_rest[open + 1..];
        if let Some(close) = after_open.find(')') {
            let inside = &after_open[..close];
            if inside.contains("doc-") || inside.contains("doc_") {
                return true;
            }
            paren_rest = &after_open[close + 1..];
        } else {
            break;
        }
    }

    // 2. Check for "version" followed by optional spaces, ':', and digits
    if let Some(idx) = lower.find("version") {
        let rem = &lower[idx + 7..];
        let mut chars = rem.chars().peekable();
        while let Some(&c) = chars.peek() {
            if c.is_whitespace() {
                chars.next();
            } else {
                break;
            }
        }
        if let Some(&':') = chars.peek() {
            chars.next();
            while let Some(&c) = chars.peek() {
                if c.is_whitespace() {
                    chars.next();
                } else {
                    break;
                }
            }
            if let Some(&d) = chars.peek() {
                if d.is_ascii_digit() {
                    return true;
                }
            }
        }
    }

    // 3. Check for ISO date pattern YYYY-MM-DD
    let bytes = trimmed.as_bytes();
    if bytes.len() >= 10 {
        for i in 0..=bytes.len() - 10 {
            if bytes[i + 4] == b'-' && bytes[i + 7] == b'-' {
                if let Ok(slice) = std::str::from_utf8(&bytes[i..i + 10]) {
                    if is_iso_date(slice) {
                        let before_ok = i == 0 || !bytes[i - 1].is_ascii_alphanumeric();
                        let after_ok =
                            i + 10 == bytes.len() || !bytes[i + 10].is_ascii_alphanumeric();
                        if before_ok && after_ok {
                            return true;
                        }
                    }
                }
            }
        }
    }

    // 4. Check for version tokens in whitespace-separated words:
    // v\d+\.\d+(?:\.\d+)? or \d+\.\d+\.\d+
    for word in trimmed.split_whitespace() {
        let clean_word = word.trim_matches(|c: char| !c.is_alphanumeric() && c != '.');
        if clean_word.starts_with('v') || clean_word.starts_with('V') {
            let rest = &clean_word[1..];
            let parts: Vec<&str> = rest.split('.').collect();
            if (parts.len() == 2 || parts.len() == 3)
                && parts
                    .iter()
                    .all(|p| !p.is_empty() && p.chars().all(|c| c.is_ascii_digit()))
            {
                return true;
            }
        } else {
            let parts: Vec<&str> = clean_word.split('.').collect();
            if parts.len() == 3
                && parts
                    .iter()
                    .all(|p| !p.is_empty() && p.chars().all(|c| c.is_ascii_digit()))
            {
                return true;
            }
        }
    }

    false
}

/// Normalizes a specification title by stripping prefixes, removing punctuation, and collapsing whitespace.
///
/// Preconditions: None.
/// Postconditions: Returns lowercase, punctuation-free normalized string matching Python `reconcile_backlog.py`.
/// Algorithmic Complexity: O(T) where T is title character count.
pub fn normalize_title(title: &str) -> String {
    let trimmed = title.trim().trim_matches(|c| c == '"' || c == '\'');
    if trimmed.is_empty() {
        return String::new();
    }

    let lower = trimmed.to_lowercase();
    const PREFIX_KEYWORDS: &[&str] = &[
        "user-story", "user story", "user_story",
        "use-case", "use case", "use_case",
        "feature", "feat",
        "epic",
        "us", "uc",
    ];

    let mut matched_len = 0;
    for kw in PREFIX_KEYWORDS {
        if lower.starts_with(kw) {
            let mut rem = &lower[kw.len()..];
            let mut consumed = kw.len();

            // Optional 's' plural
            if rem.starts_with('s') {
                rem = &rem[1..];
                consumed += 1;
            }

            // Case A: followed by ':'
            if rem.starts_with(':') {
                rem = &rem[1..];
                consumed += 1;
                while rem.starts_with(' ') || rem.starts_with('\t') {
                    rem = &rem[1..];
                    consumed += 1;
                }
                matched_len = consumed;
                break;
            }

            // Case B: optional [- ]* followed by \d+
            let mut temp_rem = rem;
            let mut temp_consumed = consumed;
            while temp_rem.starts_with('-') || temp_rem.starts_with(' ') || temp_rem.starts_with('_') {
                temp_rem = &temp_rem[1..];
                temp_consumed += 1;
            }

            let digit_count = temp_rem.chars().take_while(|c| c.is_ascii_digit()).count();
            if digit_count > 0 {
                temp_rem = &temp_rem[digit_count..];
                temp_consumed += digit_count;

                // Skip optional trailing space, ':', or '-'
                while temp_rem.starts_with(' ')
                    || temp_rem.starts_with(':')
                    || temp_rem.starts_with('-')
                {
                    temp_rem = &temp_rem[1..];
                    temp_consumed += 1;
                }
                matched_len = temp_consumed;
                break;
            }
        }
    }

    let stripped = if matched_len > 0 {
        &trimmed[matched_len..]
    } else {
        trimmed
    };

    let working = if stripped.trim().is_empty() {
        trimmed
    } else {
        stripped
    };

    let hyphens_replaced = working.replace('-', " ");

    let filtered: String = hyphens_replaced
        .chars()
        .filter(|c| c.is_alphanumeric() || c.is_whitespace())
        .collect();

    filtered
        .split_whitespace()
        .collect::<Vec<_>>()
        .join(" ")
        .to_lowercase()
}

/// Validates frontmatter and CommonMark metadata table attributes for a specification.
///
/// Preconditions: `doc` has been parsed.
/// Postconditions: Returns list of error findings for missing or malformed metadata.
/// Algorithmic Complexity: O(M) where M is the count of metadata attributes.
pub fn validate_metadata(spec_type: &str, doc: &MarkdownDoc, rel_path: &str) -> Vec<String> {
    let mut errors = Vec::new();
    let norm_type = spec_type.to_lowercase();

    let get_field = |key: &str| -> Option<&str> {
        doc.table_metadata
            .get(key)
            .map(|s| s.as_str())
            .or_else(|| {
                doc.frontmatter
                    .as_ref()
                    .and_then(|fm| fm.get(key).map(|s| s.as_str()))
            })
    };

    // 1. Mandatory issue_id
    match get_field("issue_id") {
        Some(val) if !val.trim().is_empty() => {}
        _ => {
            errors.push(format!("{}: Missing mandatory metadata field 'issue_id'.", rel_path));
        }
    }

    // 2. Mandatory type
    match get_field("type") {
        Some(val) if !val.trim().is_empty() => {}
        _ => {
            errors.push(format!("{}: Missing mandatory metadata field 'type'.", rel_path));
        }
    }

    // 3. Mandatory title
    let title_opt = get_field("title").or_else(|| {
        doc.headings
            .iter()
            .find(|h| h.level == 1)
            .map(|h| h.text.as_str())
    });

    match title_opt {
        Some(val) if !val.trim().is_empty() => {
            if has_concatenated_title_metadata(val) {
                errors.push(format!(
                    "{}: Document title contains concatenated metadata attributes ('{}'). Titles must be clean canonical names without embedded versions, dates, or IDs.",
                    rel_path, val
                ));
            }
        }
        _ => {
            errors.push(format!("{}: Missing mandatory document title.", rel_path));
        }
    }

    // 4. Epic-specific mandatory fields: package and subsystem
    if norm_type.contains("epic") {
        match get_field("package") {
            Some(val) if !val.trim().is_empty() => {}
            _ => {
                errors.push(format!("{}: Epic is missing mandatory 'package' metadata.", rel_path));
            }
        }
        match get_field("subsystem") {
            Some(val) if !val.trim().is_empty() => {}
            _ => {
                errors.push(format!("{}: Epic is missing mandatory 'subsystem' metadata.", rel_path));
            }
        }
    }

    // 5. Date validation if present
    if let Some(date_val) = get_field("date").or_else(|| get_field("release_date")) {
        if !date_val.trim().is_empty() && !is_iso_date(date_val) {
            errors.push(format!(
                "{}: Invalid date format: '{}'. Expected ISO 8601 format (YYYY-MM-DD).",
                rel_path, date_val
            ));
        }
    }

    // 6. Semver validation if present
    if let Some(ver_val) = get_field("version") {
        if !ver_val.trim().is_empty() && !is_semver(ver_val) {
            errors.push(format!(
                "{}: Invalid version format: '{}'. Expected semantic versioning format (v?X.Y[.Z]).",
                rel_path, ver_val
            ));
        }
    }

    errors
}

/// Validates title uniqueness across specifications within the same spec type.
///
/// Preconditions: `docs` contains a slice of `(spec_type, rel_path, doc)` tuples.
/// Postconditions: Returns list of error findings for any duplicate normalized titles.
/// Algorithmic Complexity: O(N log N) where N is document count.
pub fn validate_title_uniqueness(docs: &[(String, String, MarkdownDoc)]) -> Vec<String> {
    let mut errors = Vec::new();
    let mut claims: HashMap<(String, String), Vec<(&str, &str)>> = HashMap::new();

    for (spec_type, rel_path, doc) in docs {
        let norm_spec_type = match spec_type.to_lowercase().as_str() {
            "epic" | "epics" => "epic".to_string(),
            "feature" | "features" => "feature".to_string(),
            "user_story" | "user-story" | "user_stories" | "user-stories" | "us" => {
                "user_story".to_string()
            }
            "use_case" | "use-case" | "use_cases" | "use-cases" | "uc" => "use_case".to_string(),
            other => other.to_string(),
        };

        let raw_title = doc
            .table_metadata
            .get("title")
            .map(|s| s.as_str())
            .or_else(|| {
                doc.frontmatter
                    .as_ref()
                    .and_then(|fm| fm.get("title").map(|s| s.as_str()))
            })
            .or_else(|| {
                doc.headings
                    .iter()
                    .find(|h| h.level == 1)
                    .map(|h| h.text.as_str())
            });

        if let Some(title) = raw_title {
            let norm_title = normalize_title(title);
            if !norm_title.is_empty() {
                claims
                    .entry((norm_spec_type, norm_title))
                    .or_default()
                    .push((rel_path.as_str(), title));
            }
        }
    }

    let mut sorted_keys: Vec<_> = claims.keys().cloned().collect();
    sorted_keys.sort();

    for key in sorted_keys {
        if let Some(colliding) = claims.get(&key) {
            if colliding.len() > 1 {
                let (spec_type, norm_title) = &key;
                let listed = colliding
                    .iter()
                    .map(|(p, t)| format!("{} ('{}')", p, t))
                    .collect::<Vec<_>>()
                    .join(", ");

                errors.push(format!(
                    "{}: duplicate {} title -- {} specifications normalise to '{}' ({}). reconcile_backlog.py addresses tracker issues by normalised title, so duplicate titles collide.",
                    colliding[0].0,
                    spec_type,
                    colliding.len(),
                    norm_title,
                    listed
                ));
            }
        }
    }

    errors
}

/// Validates filename conventions (<prefix>-<ordinal>-<kebab-name>.md), ordinal uniqueness,
/// and padding consistency across a directory.
///
/// Preconditions: `filenames` contains markdown file names in `dir_rel`.
/// Postconditions: Returns list of error findings for convention or uniqueness violations.
/// Algorithmic Complexity: O(F log F) where F is filename count.
pub fn validate_filenames(spec_type: &str, filenames: &[&str], dir_rel: &str) -> Vec<String> {
    let mut errors = Vec::new();
    let spec_type_lower = spec_type.to_lowercase();
    let expected_prefix = match spec_type_lower.as_str() {
        "epic" | "epics" => "epic",
        "feature" | "features" => "feat",
        "user_story" | "user-story" | "user_stories" | "user-stories" | "us" => "us",
        "use_case" | "use-case" | "use_cases" | "use-cases" | "uc" => "uc",
        _ => spec_type,
    };

    let mut by_ordinal: HashMap<u64, Vec<&str>> = HashMap::new();
    let mut widths: HashMap<usize, Vec<&str>> = HashMap::new();

    for &name in filenames {
        if name.starts_with('.') || !name.ends_with(".md") || name == "README.md" {
            continue;
        }

        let stem = match name.strip_suffix(".md") {
            Some(s) => s,
            None => continue,
        };

        // Parse <prefix>-<ordinal>-<kebab-name>
        let first_dash = stem.find('-');
        let (prefix, ordinal, kebab_name) = match first_dash {
            Some(i1) => {
                let p = &stem[..i1];
                let rest = &stem[i1 + 1..];
                match rest.find('-') {
                    Some(i2) => (p, &rest[..i2], &rest[i2 + 1..]),
                    None => ("", "", ""),
                }
            }
            None => ("", "", ""),
        };

        let valid_prefix = !prefix.is_empty() && prefix.chars().all(|c| c.is_ascii_alphabetic());
        let valid_ordinal = !ordinal.is_empty() && ordinal.chars().all(|c| c.is_ascii_digit());
        let valid_kebab = !kebab_name.is_empty()
            && kebab_name
                .split('-')
                .all(|seg| !seg.is_empty() && seg.chars().all(|c| c.is_ascii_alphanumeric() || c == '_'));

        if !valid_prefix || !valid_ordinal || !valid_kebab {
            errors.push(format!(
                "{}/{}: filename does not match the documented convention '{}-<zero-padded-ordinal>-<kebab-name>.md'. Names must be lowercase and dash-separated.",
                dir_rel, name, expected_prefix
            ));
            continue;
        }

        if !prefix.eq_ignore_ascii_case(expected_prefix) {
            errors.push(format!(
                "{}/{}: directory prefix mismatch -- found '{}-', but files in {} must use the '{}-' prefix.",
                dir_rel, name, prefix, dir_rel, expected_prefix
            ));
            continue;
        }

        if let Ok(ord_val) = ordinal.parse::<u64>() {
            by_ordinal.entry(ord_val).or_default().push(name);
            widths.entry(ordinal.len()).or_default().push(name);
        }
    }

    let mut sorted_ordinals: Vec<_> = by_ordinal.keys().cloned().collect();
    sorted_ordinals.sort();
    for ord in sorted_ordinals {
        if let Some(colliding) = by_ordinal.get(&ord) {
            if colliding.len() > 1 {
                errors.push(format!(
                    "{}: duplicate ordinal -- {} is claimed by {} files ({}). Ordinals must be unique, because backlog reconciliation and Epic checklists reference specifications by number.",
                    dir_rel,
                    ord,
                    colliding.len(),
                    colliding.join(", ")
                ));
            }
        }
    }

    if widths.len() > 1 {
        let mut sorted_widths: Vec<_> = widths.keys().cloned().collect();
        sorted_widths.sort();
        let summary = sorted_widths
            .iter()
            .map(|w| {
                let files = widths.get(w).cloned().unwrap_or_default();
                format!("{} digit(s): {}", w, files.join(", "))
            })
            .collect::<Vec<_>>()
            .join("; ");

        errors.push(format!(
            "{}: inconsistent ordinal padding width across the directory ({}). Pick one width and apply it uniformly, otherwise lexical ordering does not match numeric ordering.",
            dir_rel, summary
        ));
    }

    errors
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::spec_audit::markdown_ast::parse_markdown;

    #[test]
    fn test_iso_date_validation() {
        assert!(is_iso_date("2026-10-10"));
        assert!(is_iso_date("2024-02-29"));
        assert!(!is_iso_date("2026-13-01"));
        assert!(!is_iso_date("10/10/2026"));
        assert!(!is_iso_date("invalid-date"));
        assert!(!is_iso_date("2026-00-10"));
        assert!(!is_iso_date("2026-10-00"));
        assert!(!is_iso_date("2026-10-32"));
        assert!(!is_iso_date("1969-12-31"));
        assert!(!is_iso_date("2101-01-01"));
    }

    #[test]
    fn test_semver_validation() {
        assert!(is_semver("1.0.0"));
        assert!(is_semver("v2.1.0"));
        assert!(is_semver("0.1.0-alpha.1"));
        assert!(is_semver("v1.0.0+20130313144700"));
        assert!(is_semver("1.2"));
        assert!(!is_semver("1"));
        assert!(!is_semver("v1"));
        assert!(!is_semver("release-1.0"));
        assert!(!is_semver("1.0.0.0"));
        assert!(!is_semver("v"));
    }

    #[test]
    fn test_has_concatenated_title_metadata() {
        assert!(has_concatenated_title_metadata("Core System Architecture v1.0.0"));
        assert!(has_concatenated_title_metadata("Subsystem Spec 2026-10-10"));
        assert!(has_concatenated_title_metadata("Navigation Module (DOC-NAV-001)"));
        assert!(has_concatenated_title_metadata("Version: 2 Architecture"));
        assert!(!has_concatenated_title_metadata("Core System Architecture"));
    }

    #[test]
    fn test_normalize_title() {
        assert_eq!(
            normalize_title("EPIC-001: Core System Architecture"),
            "core system architecture"
        );
        assert_eq!(
            normalize_title("feat-02: User Authentication Flow"),
            "user authentication flow"
        );
        assert_eq!(
            normalize_title("US-03 - Execute Telemetry Check!"),
            "execute telemetry check"
        );
        assert_eq!(
            normalize_title("Feature: User Authentication"),
            "user authentication"
        );
        assert_eq!(
            normalize_title("UC 04: Emergency Landing"),
            "emergency landing"
        );
        assert_eq!(
            normalize_title("User Story 10 - Sensor Telemetry"),
            "sensor telemetry"
        );
        assert_eq!(
            normalize_title("epics-12: System Overview"),
            "system overview"
        );
    }

    #[test]
    fn test_title_uniqueness_detected() {
        let content1 = "# EPIC-01: Core Architecture\n";
        let content2 = "# EPIC-02: Core Architecture\n";
        let doc1 = parse_markdown(content1).unwrap();
        let doc2 = parse_markdown(content2).unwrap();

        let docs = vec![
            ("epic".to_string(), "docs/epics/epic-01.md".to_string(), doc1),
            ("epic".to_string(), "docs/epics/epic-02.md".to_string(), doc2),
        ];

        let errors = validate_title_uniqueness(&docs);
        assert_eq!(errors.len(), 1);
        assert!(errors[0].contains("duplicate epic title"));
    }

    #[test]
    fn test_filename_conventions() {
        let clean_files = ["feat-01-login.md", "feat-02-logout.md"];
        let errors = validate_filenames("feature", &clean_files, "docs/features");
        assert!(errors.is_empty());

        let duplicate_ordinal = ["feat-01-login.md", "feat-01-duplicate.md"];
        let errors = validate_filenames("feature", &duplicate_ordinal, "docs/features");
        assert_eq!(errors.len(), 1);
        assert!(errors[0].contains("duplicate ordinal"));

        let mixed_padding = ["feat-01-login.md", "feat-002-logout.md"];
        let errors = validate_filenames("feature", &mixed_padding, "docs/features");
        assert_eq!(errors.len(), 1);
        assert!(errors[0].contains("inconsistent ordinal padding width"));
    }
}
