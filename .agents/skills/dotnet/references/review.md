# Code Review

Use this reference when reviewing a diff, pull request, implementation, or completed change. Review the change as a senior engineer: identify concrete risks and regressions, not stylistic disagreements.

## Review workflow

1. Read repository and project-specific instructions.
2. Understand the task and intended behavior.
3. Inspect the complete diff, not only the first suspicious file.
4. Read surrounding code and relevant call sites.
5. Trace changed behavior across API, application, domain, persistence, and infrastructure boundaries as applicable.
6. Check tests and identify important untested behavior.
7. Continue reviewing the entire change after finding an issue.
8. Classify findings by impact and provide actionable evidence.

Do not review from the diff alone when surrounding context is required to determine correctness.

## Finding standard

Raise a finding when the change introduces a concrete or strongly supported problem such as:

- incorrect behavior
- security vulnerability
- data loss or corruption risk
- concurrency bug
- broken API contract
- database/query regression
- reliability or resource-management issue
- significant performance regression
- architecture violation that creates real coupling or maintenance risk
- unnecessary complexity that materially increases failure or change cost

Do not report a preference as a defect merely because another implementation would look different.

## Severity

Use severity proportional to impact:

- **Critical** — severe security, data integrity, availability, or production failure risk.
- **High** — likely serious defect, security issue, compatibility break, or major operational impact.
- **Medium** — meaningful correctness, maintainability, performance, or reliability problem with a bounded impact.
- **Low** — minor issue worth fixing when practical.

Avoid inflating severity. A code smell without a concrete consequence is not automatically a bug.

## Correctness

Check:

- normal and edge-case behavior
- null/empty inputs
- boundary conditions
- state transitions
- exception and failure paths
- cancellation behavior
- retries and duplicate execution
- ordering assumptions
- race conditions
- resource disposal/lifetime

Trace assumptions across method and process boundaries rather than evaluating each changed method in isolation.

## API review

Check:

- HTTP method and status semantics
- request/response contract
- validation behavior
- authorization
- information disclosure
- pagination and unbounded results
- idempotency and retries
- concurrency/conflict behavior
- OpenAPI accuracy

See `references/api.md` for detailed API guidance.

## Security review

Check authentication, authorization, input handling, injection, SSRF, deserialization, file handling, secrets, sensitive logging, transport security, rate limiting, and tenant isolation where relevant.

Do not accept security-sensitive custom primitives when established framework/library mechanisms are available.

See `references/security.md`.

## EF Core review

Check:

- query shape and projection
- unnecessary tracking
- N+1 queries
- cartesian explosion
- unbounded result sets
- pagination ordering
- indexes where relevant
- transaction scope
- concurrency handling
- migration safety
- accidental client-side evaluation/materialization
- database round-trip count

See `references/efcore.md`.

## Architecture review

Ask whether the change respects the existing architecture and dependency direction.

Be especially alert for:

- business logic leaking into infrastructure
- persistence concerns leaking into public contracts
- unnecessary generic repositories
- abstraction added without a real boundary
- feature logic scattered across unrelated layers
- circular dependencies
- premature service/microservice boundaries
- accidental coupling between modules

Do not demand Clean Architecture, Vertical Slice Architecture, CQRS, or another pattern when the project does not need it.

## Performance review

Do not flag a performance issue solely from intuition unless the cost is obvious and significant.

When performance is relevant, identify the mechanism causing the cost and prefer measurement. Common issues include unnecessary allocations, blocking I/O, excessive network/database calls, unbounded concurrency, large materializations, and inefficient queries.

See `references/performance.md`.

## Testing review

Check whether tests verify behavior rather than implementation details.

Look for missing coverage around changed behavior, error paths, authorization, concurrency, persistence semantics, and API contracts when applicable.

Do not require tests for trivial changes solely to increase a coverage number, but do require confidence appropriate to the risk of the change.

## Maintainability and dependencies

Prefer simple, explicit code when it communicates intent clearly.

Review new dependencies based on justification rather than personal preference. Ask:

- Does the dependency solve meaningful complexity?
- Does the project already use it?
- Could the framework or a small implementation suffice?
- What maintenance/security/licensing cost does it add?
- Is migration or long-term coupling justified?

Do not request replacement of an established dependency merely because a different library is preferred.

## Review output

Each finding should state:

1. What is wrong.
2. Why it matters.
3. Where it occurs.
4. A concrete remediation when one is reasonably clear.

Prefer a small number of high-confidence findings over a long list of speculative concerns.

If no substantive problems are found, say so clearly after actually reviewing the full change and relevant context.
