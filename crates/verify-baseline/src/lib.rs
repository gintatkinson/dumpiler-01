//! verify-baseline library crate.

pub mod checks;
pub mod runner;

pub use runner::{run, BaselineOptions};
