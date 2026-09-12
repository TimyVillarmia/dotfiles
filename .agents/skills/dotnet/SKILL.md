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
3. Locate application boundaries, entry points, tests, and affected code paths.
4. Understand existing architecture, dependency direction, and data flow.
5. Translate the task into concrete behavioral and technical requirements.
6. Determine which references apply: API, architecture, EF Core, performance, security, or review.
7. Check whether the required capability already exists in the framework or an existing dependency.
8. For a new dependency, evaluate complexity, maintenance, security, performance, licensing, and whether a small explicit implementation would be sufficient.

For a new project, choose architecture and dependencies from requirements and constraints rather than starting from a favorite template or library list.

## Modern C# and .NET

Use language and framework features supported by the repository's actual target version. For .NET 10/C# 14, be familiar with extension blocks, the `field` keyword, primary constructors, collection expressions, pattern matching, records, required members, nullable reference types, `IAsyncEnumerable<T>`, and other modern APIs.

Use newer syntax when it improves clarity, correctness, or maintainability—not merely because it is new. Do not rewrite stable code solely to adopt newer syntax unless modernization is part of the task or the change has a concrete benefit.

Prefer framework-provided abstractions for common concerns. Examples include `TimeProvider` for testable time, `IHttpClientFactory`/HTTP resilience infrastructure for outbound HTTP, built-in validation/OpenAPI/problem-details facilities where they fit, and `Channel<T>` for in-process producer/consumer workflows.

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

When designing endpoints, also apply the API guidance in `references/api.md`: deliberate HTTP semantics, validation, error contracts, authorization boundaries, pagination, idempotency, concurrency, and OpenAPI behavior.

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

Use this reasoning sequence for non-trivial patterns:

**When to use → principle → implementation → why → trade-offs → anti-pattern → exceptions.**

Common anti-patterns to actively check for include blocking async work (`.Result`, `.Wait()`), `new HttpClient()` for managed application HTTP, unbounded fan-out, fire-and-forget request work, N+1 database access, leaking persistence entities through public APIs, generic repositories over EF Core without a real boundary, local wall-clock time for domain/persistence semantics, and custom security primitives.

These are not all absolute prohibitions. Evaluate the actual context and mechanism; distinguish a real defect from a stylistic preference.

## Dependencies

Before adding a dependency:

1. Check whether the platform/framework already solves the problem.
2. Check whether an existing project dependency already provides the capability.
3. Consider a small explicit implementation when the problem is simple and non-sensitive.
4. Add a third-party dependency when complexity, reliability, ecosystem support, or security makes it worthwhile.

For a new dependency that is not already established by the repository, explain the trade-off and ask the user before adding it unless the task explicitly requested it or the repository requires it. Do not ask before using an existing dependency.

Never implement cryptography, password hashing, token validation, OAuth/OIDC protocol behavior, or other security-sensitive primitives yourself merely to avoid a package.

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
- Do not create a separate custom Aspire skill in this collection when the installed/official Aspire skill is available; use that official skill for detailed Aspire-specific workflows and current APIs.
- When Aspire behavior is version-sensitive, consult the official Aspire documentation and the repository's installed Aspire skill rather than relying on remembered APIs.

Official Aspire documentation: https://learn.microsoft.com/dotnet/aspire/

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
- `references/performance.md` — measurement-first optimization across CPU, memory, async I/O, database, HTTP, serialization, caching, resilience, and concurrency.
- `references/security.md` — authentication, authorization, validation, secrets, injection, SSRF, CSRF/CORS, transport security, and threat modeling.
- `references/review.md` — senior-level defect-focused review across correctness, security, architecture, data access, performance, testing, and maintainability.
