//! CLI entrypoint for verify-baseline utility.

use clap::Parser;
use std::path::PathBuf;
use std::process;
use verify_baseline::runner::{run, BaselineOptions};

#[derive(Parser, Debug)]
#[command(name = "verify-baseline")]
#[command(about = "Verify downstream project baseline conformance", long_about = None)]
struct Cli {
    /// Target destination directory or repository root (defaults to current directory)
    #[arg(default_value = ".")]
    destination: String,

    /// Skip domain type compatibility validation and build/test commands
    #[arg(long)]
    no_domain: bool,

    /// Enforce strict baseline conformance (reject pending or missing specifications)
    #[arg(long)]
    strict: bool,

    /// Gracefully allow missing specifications if in downstream customer mode
    #[arg(long)]
    allow_missing_specs: bool,

    /// Target execution platform profile (e.g. flutter, react)
    #[arg(long)]
    target: Option<String>,

    /// Optional path to write output report or defect dossier
    #[arg(long)]
    output: Option<String>,

    /// Run only the specification quality and coverage audit suite
    #[arg(long)]
    spec_only: bool,

    /// Audit only a specific markdown file
    #[arg(long)]
    only: Option<String>,

    /// Filter to run a specific audit gate
    #[arg(long)]
    gate: Option<String>,
}

fn main() {
    let cli = Cli::parse();

    let options = BaselineOptions {
        destination: PathBuf::from(&cli.destination),
        no_domain: cli.no_domain,
        strict: cli.strict,
        allow_missing_specs: cli.allow_missing_specs,
        target: cli.target,
        output: cli.output,
        spec_only: cli.spec_only,
        only: cli.only,
        gate: cli.gate,
    };

    if let Err(()) = run(&options) {
        process::exit(1);
    }
}
