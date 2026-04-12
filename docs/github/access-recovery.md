# GitHub Access Recovery

This repo currently has local git remote configuration but not working GitHub automation access.

## Observed state

As checked on April 12, 2026:

- local remote is `https://github.com/Jesssullivan/Dell-7810`
- `gh auth status` reports invalid tokens
- the connected GitHub app installation is visible on `kulits`
- the private repo `Jesssullivan/Dell-7810` is not visible through the connector

## What this means

Two separate access paths are currently broken or incomplete:

1. GitHub App / connector access
2. local `gh` CLI authentication

Either one can help, but for private-repo automation it is best to fix both.

## Recommended repair order

## 1. Install or grant the GitHub app on the target repo

Goal:

- make `Jesssullivan/Dell-7810` visible to the connector

Expected action in GitHub UI:

- install the app on the `Jesssullivan` account or grant the existing installation access to the `Dell-7810` repository

Verification:

- connector repo search should return `Dell-7810`

## 2. Re-authenticate `gh`

Recommended commands:

```bash
gh auth logout -h github.com -u Jesssullivan
gh auth login -h github.com -p https -w
gh auth status
```

Notes:

- `-w` opens the browser-based web flow
- if you prefer a PAT, use `gh auth login --with-token`
- the PAT needs repo scope for private repo issue and milestone work

## 3. Verify repo visibility

Once auth is fixed, these checks should succeed:

```bash
gh repo view Jesssullivan/Dell-7810
gh issue list --repo Jesssullivan/Dell-7810
gh api repos/Jesssullivan/Dell-7810/milestones
```

## 4. Apply the setup plan

After access is restored:

1. push the `.github/` templates if they are not already on the default branch
2. create milestones M0-M4
3. create the label set from `docs/github/project-setup.md`
4. open the initial M0 and M1 issues from `docs/github/initial-issues.md`

## Minimal success condition

You do not need every integration working to move forward. The minimum viable GitHub state is:

- working `gh` auth for the private repo
- milestone set created
- initial issues created

The connector can be fixed after that if needed.
