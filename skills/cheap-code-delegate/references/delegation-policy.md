# Delegation Policy

## Allowed by Default

- S0 mechanical work.
- S1 small localized work following obvious local patterns.
- Safe S2 read-only exploration, test drafts, implementation plans, or narrow patch drafts.

## Not Allowed

Do not use a cheap worker for final decisions or sensitive work:

- Architecture decisions
- Security logic
- Auth, permissions, payments, crypto
- Database migrations
- Concurrency
- Data deletion
- Production configuration
- Secrets and credentials
- Ambiguous root-cause debugging
- Public API design
- Broad rewrites
- Final merge decisions

## Acceptance Gate

Worker output is only a draft. Codex must:

1. Review the diff.
2. Verify behavior.
3. Decide final acceptance.
4. Explain residual risks.

