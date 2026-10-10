//! verify-baseline library crate.

pub mod checks;
pub mod runner;
pub mod spec_audit;

pub use runner::{run, BaselineOptions};
pub use spec_audit::{
    run_spec_audit, SpecAuditError, SpecAuditFinding, SpecAuditOptions, SpecAuditSummary,
};
