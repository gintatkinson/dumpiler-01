# Implementation Plan -- Synthesize 10-Pillar STPA Safety Assurance Suite for `uav-012`

**Objective**: Synthesize, verify, and deliver the complete 10-pillar STPA Safety Assurance Matrix and FMECA suite for `uav-012` (`/Users/perkunas/jail/uav-012`) derived from its authoritative SysML v2 AST model (`schema/model.sysml`), publish branch `stpa-baseline` to GitLab, and open a Merge Request targeting `Phase-1-baseline`.

---

## 1. Context & Completed Work Packages

- **Target Workspace**: `/Users/perkunas/jail/uav-012` (GitLab: `https://gitlab.com/gintatkinson/uav-012.git`, branch `Phase-1-baseline`).
- **Initial Delivery (WPs 1-5)**: Completed. Fixed SysML syntax, deployed toolchain, synthesized 10 safety deliverables under `uav-012/docs/safety/`, verified Check 17.
- **GLFM Mermaid Ergonomics (WP 6 & 7)**: Completed. Formatted Mermaid diagrams with `direction TB`, `<br/>` line wrapping ($\le 35$ characters), and dashes instead of commas. Check 13B and Check 17 pass. Pushed to `dumpiler-01:main` and `uav-012:feat/stpa-safety-assurance-suite`.
- **Merge Request for `stpa-baseline` (WP 8)**: Completed. Branch `stpa-baseline` created and pushed; GitLab MR !6 opened targeting `Phase-1-baseline`; prior MR !5 superseded.

---

## 2. Work Packages Decomposition

### Work Packages 1-5 [COMPLETED]
- Schema syntax fix, toolchain deployment, STPA synthesis, Check 17 verification.

### Work Packages 6-7 [COMPLETED]
- GLFM Mermaid ergonomics in compiler generator (`dumpiler-01`) and re-transpilation in `uav-012`. All checks verified.

### Work Package 8: `stpa-baseline` Branch Creation, Push & Merge Request (`uav-012`) [COMPLETED]
1. Created branch `stpa-baseline` from HEAD in `/Users/perkunas/jail/uav-012`.
2. Pushed `stpa-baseline` to remote `origin`. Verified `git diff origin/stpa-baseline` is empty.
3. Created Merge Request !6 targeting `Phase-1-baseline` via `glab mr create`.
4. Closed superseded MR !5 with reference to MR !6.

---

## 3. Acceptance Criteria

- [x] Complete 10-pillar STPA suite generated and verified in `uav-012/docs/safety/`.
- [x] Check 13B (Mermaid ergonomics) and Check 17 (Safety Integrity) passing.
- [x] Branch `stpa-baseline` created with commits `6016b12` and `0d0f275`.
- [x] Branch `stpa-baseline` pushed cleanly to GitLab (`origin/stpa-baseline`).
- [x] GitLab Merge Request !6 opened for `stpa-baseline` -> `Phase-1-baseline`.
- [x] MR verified with `glab mr view 6`.
