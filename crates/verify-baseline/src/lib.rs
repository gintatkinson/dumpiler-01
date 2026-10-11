//! verify-baseline library crate.

pub mod checks;
pub mod commit_msg;
pub mod defect_dossier;
pub mod output_integrity;
pub mod runner;
pub mod spec_audit;

pub use commit_msg::{scan_commit_message, CommitMsgArgs, CommitViolation};
pub use defect_dossier::{validate_defect_dossier, DefectDossierArgs, DefectSchemaValidation};
pub use output_integrity::{verify_file_output, OutputIntegrityArgs};
pub use runner::{run, BaselineOptions};
pub use spec_audit::{
    run_spec_audit, SpecAuditError, SpecAuditFinding, SpecAuditOptions, SpecAuditSummary,
};
