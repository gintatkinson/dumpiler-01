# Implementation Plan: Push All Branches & Tags to `gintatkinson/dump-test01`

## Objective
Push all branches and tags from this repository (`dumpiler-01`) to [https://github.com/gintatkinson/dump-test01.git](https://github.com/gintatkinson/dump-test01), ensuring all branches, commits, crates, specifications, and pipeline trees are fully mirrored on GitHub.

---

## Proposed Execution Steps

### 1. Push All Branches to Remote
- Execute:
  ```bash
  git push --all --force https://github.com/gintatkinson/dump-test01.git
  ```
  *(Forces update of `main` and any other branches to overwrite the existing 6-file stub)*

### 2. Push All Tags to Remote
- Execute:
  ```bash
  git push --tags --force https://github.com/gintatkinson/dump-test01.git
  ```

### 3. Verify Remote GitHub Repository
- Verify all branches exist on the remote GitHub repository:
  ```bash
  gh api repos/gintatkinson/dump-test01/branches
  ```
- Verify root tree has all codebase directories (`crates/`, `docs/`, `schema/`, `.pipeline/`):
  ```bash
  gh api repos/gintatkinson/dump-test01/git/trees/main
  ```

### 4. Synchronize Local Sibling Clone
- Update `/Users/perkunas/jail/dump-test01`:
  ```bash
  git -C /Users/perkunas/jail/dump-test01 fetch origin
  git -C /Users/perkunas/jail/dump-test01 reset --hard origin/main
  ```

---

## Verification Criteria
- [ ] `git push --all --force` succeeds with exit code 0.
- [ ] `git push --tags --force` succeeds with exit code 0.
- [ ] `gh api repos/gintatkinson/dump-test01/branches` shows branches up to date with `dumpiler-01`.
- [ ] `gh api repos/gintatkinson/dump-test01/git/trees/main` confirms full directory tree is present on GitHub.
