---
name: dotnet
description: Senior-level guidance for building, modifying, debugging, architecting, and reviewing .NET/C# applications. Use when a task involves .NET implementation or engineering decisions, especially ASP.NET Core APIs, EF Core, architecture, dependencies, security, performance, testing, Aspire, or code review.
---

# .NET Engineering

Use this skill as the default engineering guide for modern .NET work. It is project-neutral: repository-specific instructions, established conventions, and explicit task requirements take precedence over these defaults.

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
3. Locate application boundaries, entry points, tests, and affected code paths.
4. Understand existing architecture, dependency direction, and data flow.
5. Translate the task into concrete behavioral and technical requirements.
6. Read only the references relevant to the task.
7. Check whether the required capability already exists in the framework or an existing dependency.
8. For a new dependency, evaluate complexity, maintenance, security, performance, licensing, and whether a small explicit implementation would be sufficient.

For a new project, choose architecture and dependencies from requirements and constraints rather than starting from a favorite template or library list.

## Scale the process to the task

Match investigation, implementation, and validation depth to scope, risk, and uncertainty.

- **Tiny change:** inspect the necessary context, make the smallest correct change, and run focused validation.
- **Normal feature:** inspect affected architecture, dependencies, call sites, and relevant tests; use applicable references.
- **Cross-cutting, security-sensitive, performance-sensitive, data-sensitive, or architectural change:** broaden investigation and validation proportionally.

Do not perform heavyweight architectural analysis or broad refactoring for a trivial change without a concrete reason.

## Modern C# and .NET

Use language and framework features supported by the repository's actual target version. For .NET 10/C# 14, be familiar with extension blocks, the `field` keyword, primary constructors, collection expressions, pattern matching, records, required members, nullable reference types, `IAsyncEnumerable<T>`, and other modern APIs.

Use newer syntax when it improves clarity, correctness, or maintainability—not merely because it is new. Do not rewrite stable code solely to adopt newer syntax unless modernization is part of the task or the change has a concrete benefit.

For detailed language-feature guidance, use `references/csharp.md` when the task involves C# syntax, idioms, language-version decisions, type-system design, async patterns, or modernization.

Prefer framework-provided abstractions for common concerns. Examples include `TimeProvider` for testable time, `IHttpClientFactory`/HTTP resilience infrastructure for outbound HTTP, built-in validation/OpenAPI/problem-details facilities where they fit, and `Channel<T>` for in-process producer/consumer workflows.

Always verify version-sensitive APIs and behavior against the repository's actual target and installed packages before relying on them.

## API and endpoint organization

For Minimal API applications, prefer clear endpoint organization that matches the size and architecture of the application.

For larger APIs or feature/vertical-slice-oriented applications, a small endpoint abstraction such as `IEndpoint` is a useful personal default when it improves discoverability, registration, and separation of HTTP concerns from application logic. Keep the abstraction small and framework-aligned.

Example pattern:

```csharp
public interface IEndpoint
{
    void Map(IEndpointRouteBuilder endpoints);
}
```

Use an endpoint implementation to keep route definitions and HTTP concerns close to the feature while delegating business behavior to the appropriate application/use-case layer. Endpoint registration should remain explicit and easy to discover.

This is a personal/project pattern, not a universal .NET requirement. Do not introduce `IEndpoint` into an existing project merely because this skill recommends it. Follow an established endpoint organization unless there is a concrete reason to change it. For small APIs, direct `MapGet`, `MapPost`, and similar route registration may be clearer.

When designing endpoints, also apply `references/api.md`.

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

## Patterns and anti-patterns

For non-trivial patterns, reason about: **when to use → principle → implementation → why → trade-offs → anti-pattern → exceptions.**

Actively check for concrete risks such as blocking async work, unmanaged HTTP clients, unbounded work, fire-and-forget request work, N+1 database access, persistence entities exposed through public APIs, generic repositories without a real boundary, incorrect time semantics, and custom security primitives.

These are review signals, not automatic prohibitions. Evaluate the actual context and distinguish a real defect from a stylistic preference. Use the domain reference for detailed guidance when the task warrants it.

## Dependency decisions

Use this decision order:

```text
Framework/platform capability
        ↓
Existing project dependency
        ↓
Small explicit implementation for simple, non-sensitive functionality
        ↓
New third-party dependency when its value justifies the added cost
```

Before adding a new dependency, consider complexity, reliability, ecosystem support, security, performance, licensing, maintenance, and migration/lock-in cost.

For a new dependency that is not already established by the repository, explain the trade-off and ask the user before adding it unless the task explicitly requested it or the repository requires it. Do not ask before using an existing dependency.

Security-sensitive primitives are an explicit exception: prefer established framework/library implementations for cryptography, password hashing, token validation, OAuth/OIDC protocol behavior, and similar primitives rather than writing them yourself to save a dependency.

## Testing

Choose tests by the behavior and boundary being verified:

- Unit tests for pure domain/application logic and deterministic transformations.
- Integration tests for HTTP wiring, serialization, dependency injection, authentication/authorization, and externally observable API behavior.
- Relational database tests for behavior that depends on real database semantics when practical.
- Contract tests when compatibility with external consumers is important.

Do not mock EF Core into behaving like a relational database. Do not test implementation details merely to increase coverage. Test risk and behavior.

## .NET Aspire

Use Aspire when the repository already uses it or when the task explicitly calls for Aspire-based orchestration. Aspire is an orchestration/developer-experience layer for distributed .NET applications; it should not be treated as a replacement for application architecture.

- Inspect the existing AppHost, service projects, resources, and Aspire version before changing orchestration.
- Prefer Aspire's built-in integrations and established repository patterns over custom orchestration code.
- Keep application logic in application/service projects rather than moving business behavior into the AppHost.
- Treat resource references, endpoints, configuration, service discovery, health checks, and environment wiring as deployment/runtime concerns.
- Avoid coupling application code unnecessarily to Aspire-specific APIs when a normal .NET abstraction is sufficient.
- Use the installed/official Aspire skill for detailed Aspire-specific workflows and current APIs when available.
- When Aspire behavior is version-sensitive, verify it against the repository and current official documentation rather than relying on remembered APIs.

## Personal defaults

These are defaults for new projects, not universal rules:

- CQRS where separate command/query models provide value.
- Martinothamar.Mediator for mediator-based application flow.
- A Result/ErrorOr-style result model for expected application failures.
- Explicit `ToEntity()` / `ToDto()` mapping rather than mapping magic.
- `IEndpoint` for feature-oriented Minimal API endpoint organization when the application is large enough to benefit from the abstraction.
- Fewer dependencies and explicit implementations for small, non-sensitive functionality.

Existing projects may use MediatR, Mapster, another result library, a different mediator, direct route mapping, another endpoint abstraction, or a different architecture. Follow the project unless migration is part of the task.

## Validation

After changes, validate proportionally to risk:

1. Format/analyze the affected project when appropriate.
2. Build the smallest useful scope first, then the relevant solution when warranted.
3. Run focused tests, followed by broader tests when practical and relevant.
4. Verify API contracts, database behavior, migrations, or security behavior when affected.
5. Review the final diff for unintended changes, unnecessary complexity, and regressions.
6. If performance is relevant, compare measurements before and after.

Do not claim a change is verified when the relevant validation was not actually performed.

## Reference routing

Read only the reference needed for the current task. Do not load unrelated references merely because they exist.

| Task involves | Reference |
|---|---|
| C# language features, syntax, idioms, type-system design, async patterns, modernization, language-version decisions | `references/csharp.md` |
| ASP.NET Core HTTP APIs, endpoint contracts, OpenAPI, validation, errors, pagination | `references/api.md` |
| Architecture, CQRS, Vertical Slice, Clean Architecture, boundaries, dependency direction | `references/architecture.md` |
| EF Core, database queries, modeling, transactions, concurrency, migrations, persistence testing | `references/efcore.md` |
| A measured/suspected performance problem or optimization work | `references/performance.md` |
| Authentication, authorization, untrusted input, secrets, injection, SSRF, browser security, threat modeling | `references/security.md` |
| Reviewing a diff, pull request, implementation, or completed change | `references/review.md` |

If a task crosses multiple areas, read the smallest combination of references that covers the affected decisions.
