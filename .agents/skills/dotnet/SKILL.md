---
name: dotnet
description: Senior-level engineering guidance for building, modifying, debugging, and reviewing modern .NET and C# applications. Use when working in a .NET repository, especially when making architectural, API, EF Core, Aspire, security, performance, dependency, or code-review decisions.
---

# .NET Engineering

Use this skill as the default engineering guide for modern .NET work. It is intentionally project-neutral: repository-specific instructions, established conventions, and explicit task requirements take precedence over these defaults.

## Core principles

- Understand the repository before changing it.
- Prefer the simplest correct solution that satisfies the requirement.
- Preserve existing project conventions unless there is a concrete reason to change them.
- Prefer framework/platform capabilities before introducing custom infrastructure.
- Minimize unnecessary dependencies, not dependencies at all costs.
- Do not add a third-party dependency merely because a library exists.
- Do not implement security-sensitive primitives yourself merely to avoid a dependency.
- Prefer explicit behavior over magic, hidden conventions, and unnecessary abstraction.
- Optimize for correctness, maintainability, observability, and performance together.
- Measure performance before making optimization claims.
- Make surgical changes; avoid unrelated refactoring.

## Instruction precedence

When guidance conflicts, use this order:

1. Security and correctness constraints.
2. Explicit task requirements.
3. Repository/project-specific instructions and conventions.
4. Existing architectural decisions.
5. This skill and its references.
6. Personal/default technology preferences.
7. Agent preferences.

An existing dependency or architecture is not automatically wrong because it differs from a preferred default. Change it only when the task requires it or the benefit clearly justifies the migration cost.

## Before implementation

1. Inspect repository instructions and relevant agent guidance.
2. Identify the target .NET SDK, C# language version, frameworks, and package versions.
3. Locate the application boundaries, entry points, tests, and affected code paths.
4. Understand the existing architecture, dependency direction, and data flow.
5. Translate the task into concrete behavioral and technical requirements.
6. Determine which references apply: API, architecture, EF Core, performance, security, or review.
7. Check whether the required capability already exists in the framework or an existing dependency.
8. For a new dependency, evaluate complexity, maintenance, security, performance, licensing, and whether a small explicit implementation would be sufficient.

For a new project, choose architecture and dependencies from requirements and constraints rather than starting from a favorite template or library list.

## Implementation guidance

- Use modern idiomatic C# appropriate to the repository's language version.
- Prefer clear types, explicit contracts, small cohesive components, and dependency injection where it improves composition and testability.
- Use async APIs for asynchronous I/O; do not introduce blocking waits to hide asynchronous work.
- Pass `CancellationToken` through meaningful asynchronous boundaries.
- Treat logging, metrics, tracing, configuration, and health behavior as production concerns where applicable.
- Keep public API contracts deliberate and stable.
- Keep persistence concerns appropriate to the application's architecture; do not add generic abstractions over EF Core without a concrete benefit.
- Keep security decisions explicit and verify authorization at the resource boundary.
- Avoid premature abstractions, speculative extensibility, and ceremony without a demonstrated need.

## .NET Aspire

Use Aspire when the repository already uses it or when the task explicitly calls for Aspire-based orchestration. Aspire is an orchestration/developer-experience layer for distributed .NET applications; it should not be treated as a replacement for application architecture.

- Inspect the existing AppHost, service projects, resources, and Aspire version before changing orchestration.
- Prefer Aspire's built-in integrations and established repository patterns over custom orchestration code.
- Keep application logic in the application/service projects rather than moving business behavior into the AppHost.
- Treat resource references, endpoints, configuration, service discovery, health checks, and environment wiring as deployment/runtime concerns.
- Avoid coupling application code unnecessarily to Aspire-specific APIs when a normal .NET abstraction is sufficient.
- Do not create a separate custom Aspire skill in this collection when the installed/official Aspire skill is available; use that official skill for detailed Aspire-specific workflows and current APIs.
- When Aspire behavior is version-sensitive, consult the official Aspire documentation and the repository's installed Aspire skill rather than relying on remembered APIs.

Official Aspire documentation: https://learn.microsoft.com/dotnet/aspire/

## Personal defaults

These are defaults for new projects, not universal rules:

- CQRS where separate command/query models provide value.
- Martinothamar.Mediator for mediator-based application flow.
- A Result/ErrorOr-style result model for expected application failures.
- Explicit `ToEntity()` / `ToDto()` mapping rather than mapping magic.
- Fewer dependencies and explicit implementations for small, non-sensitive functionality.

Existing projects may use MediatR, Mapster, another result library, a different mediator, or a different architecture. Follow the project unless migration is part of the task.

## Validation

After changes:

1. Format/analyze the affected project when appropriate.
2. Build the smallest useful scope first, then the relevant solution.
3. Run focused tests, followed by broader tests when practical.
4. Verify API contracts, database behavior, migrations, or security behavior when affected.
5. Review the final diff for unintended changes, unnecessary complexity, and regressions.
6. If performance is relevant, compare measurements before and after.

Do not claim a change is verified when the relevant validation was not actually performed.

## Reference guidance

Read only the reference needed for the current task:

- `references/api.md` — ASP.NET Core APIs, HTTP semantics, OpenAPI, validation, errors, pagination, concurrency, and API boundaries.
- `references/architecture.md` — pragmatic architecture, CQRS, Vertical Slice, Clean Architecture, boundaries, and dependency direction.
- `references/efcore.md` — EF Core modeling, querying, transactions, concurrency, migrations, testing, and performance.
- `references/performance.md` — measurement-first optimization across CPU, memory, async I/O, database, HTTP, serialization, and caching.
- `references/security.md` — authentication, authorization, validation, secrets, injection, SSRF, CSRF/CORS, transport security, and threat modeling.
- `references/review.md` — senior-level defect-focused review across correctness, security, architecture, data access, performance, testing, and maintainability.
