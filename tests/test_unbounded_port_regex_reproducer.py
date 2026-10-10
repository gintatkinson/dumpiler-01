"""
Regression test for Unbounded Port Regex Defect in sysmlv2_ast.py and compile_sysml.py.

Verifies:
1. SysMLParser does not classify import statements as phantom PortDef objects.
2. Package-level and part-level import statements are cleanly ignored or preserved without phantom port pollution.
3. Genuine port definitions (directional, conjugated, def/usage) are parsed accurately.
4. compile_sysml.parse_sysml does not emit phantom 'Port' in ast['port_defs'].
"""

import os
import sys
import unittest

WORKSPACE_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SPEC_SCRIPTS_DIR = os.path.join(WORKSPACE_ROOT, "skills", "spec-orchestrator", "scripts")
if SPEC_SCRIPTS_DIR not in sys.path:
    sys.path.insert(0, SPEC_SCRIPTS_DIR)
SCRIPTS_DIR = os.path.join(WORKSPACE_ROOT, "scripts")
if SCRIPTS_DIR not in sys.path:
    sys.path.insert(0, SCRIPTS_DIR)

from sysmlv2_ast import SysMLParser, PortDef
from compile_sysml import parse_sysml


class TestUnboundedPortRegexReproducer(unittest.TestCase):
    """Reproduces and verifies remediation for unbounded port regex matching import statements."""

    def test_package_level_import_does_not_create_phantom_port(self):
        snippet = """
        package TestPackage {
            import ConOps::*;
            import Subsystem_1::*;
        }
        """
        pkg = SysMLParser.parse_text(snippet)
        self.assertIsNotNone(pkg)
        self.assertEqual(
            [p.name for p in pkg.port_defs],
            [],
            "Package port_defs must not contain phantom ports from import statements",
        )

    def test_part_level_import_does_not_create_phantom_port(self):
        snippet = """
        package TestPackage {
            part def Foo {
                import ConOps::*;
            }
        }
        """
        pkg = SysMLParser.parse_text(snippet)
        self.assertIsNotNone(pkg)
        self.assertEqual(len(pkg.part_defs), 1)
        part = pkg.part_defs[0]
        self.assertEqual(
            [p.name for p in part.ports],
            [],
            "Part ports must not contain phantom ports from import statements",
        )

    def test_compile_sysml_parse_sysml_no_phantom_ports(self):
        snippet = """
        package TestPackage {
            import ConOps::*;
            part def Controller {
                import Subsystem_2::*;
                port inout c2_bus : RS485;
            }
        }
        """
        ast = parse_sysml(snippet)
        self.assertNotIn("Port", ast.get("port_defs", []))
        self.assertIn("c2_bus", ast.get("port_defs", []))

    def test_genuine_port_variants_still_parse_correctly(self):
        snippet = """
        package TestPackage {
            part def Controller {
                port cmd_in : Command;
                in port telemetry_in : Telemetry;
                out port status_out : Status;
                port inout data_bus : Bus;
                ~port conjugated_port : Signal;
            }
        }
        """
        pkg = SysMLParser.parse_text(snippet)
        self.assertIsNotNone(pkg)
        part = pkg.part_defs[0]
        port_names = [p.name for p in part.ports]
        self.assertIn("cmd_in", port_names)
        self.assertIn("telemetry_in", port_names)
        self.assertIn("status_out", port_names)
        self.assertIn("data_bus", port_names)
        self.assertIn("conjugated_port", port_names)
        self.assertNotIn("Port", port_names)


if __name__ == "__main__":
    unittest.main()
