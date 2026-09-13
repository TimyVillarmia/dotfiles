# Architecture

Use this reference when designing or changing application structure, boundaries, dependency direction, or major components.

## Start from requirements

Architecture is a means to satisfy requirements and constraints. Do not choose an architecture because it is fashionable or because a template exists.

Consider business/domain complexity, team ownership, deployment topology, operational requirements, change patterns, integration boundaries, testing needs, performance/scaling, security, and compliance.

Prefer the least complex architecture that preserves the boundaries the system actually needs.

## Architecture decision flow

```text
Is there a real boundary or invariant to protect?
├─ No -> keep the code local and simple.
└─ Yes
   ├─ Is the boundary a business capability/use case?
   │  └─ Consider a vertical slice/module.
   ├─ Does dependency direction/domain isolation matter?
   │  └─ Consider Clean Architecture principles.
   ├─ Do commands and queries materially differ?
   │  └─ Consider CQRS.
   └─ Does deployment/ownership/scaling require separation?
      └─ Consider a service boundary.
```

A pattern is justified by the problem it solves, not by its popularity.

## Pragmatic default

A modular monolith is often a strong starting point for business applications. Keep modules cohesive and boundaries explicit before introducing distributed deployment boundaries.

Do not introduce microservices merely to create architectural separation. A service boundary should have a concrete reason such as independent scaling, deployment, ownership, isolation, or integration requirements.

## Vertical Slice Architecture

Vertical slices organize code around business capabilities or use cases rather than technical layers.

A useful shape is:

```text
Feature
├── Command / Query
├── Handler
├── Validation
├── Mapping
└── Tests
```

Use this when feature cohesion and independent change are more valuable than shared horizontal layers.

CQRS fits naturally when commands and queries have materially different behavior, data access, performance, or models. It does not require separate databases or services.

```text
Command -> Mediator -> Application/Domain -> Persistence
Query   -> Mediator -> Persistence -> Projection -> DTO
```

## Clean Architecture

Clean Architecture is useful when dependency direction and domain isolation are important. Its value comes from controlling dependencies and protecting business rules, not from creating a fixed number of projects.

Avoid layers that contain no meaningful behavior merely to satisfy an architectural diagram. Combining Clean Architecture principles with vertical slices can be a pragmatic choice.

## Dependency direction

Ask:

- Who owns this behavior?
- Who needs to change together?
- Which dependency is likely to vary?
- Is this boundary protecting a real invariant or merely adding indirection?

Dependencies should point toward stable business rules when isolation is required, while infrastructure remains replaceable where that boundary has real value.

Do not create abstractions solely because a dependency is technically replaceable.

## Repositories and persistence abstractions

EF Core already provides substantial abstraction over database access. Do not introduce a generic repository or unit-of-work wrapper by default.

Good abstraction:

```csharp
public interface IAssetNumberGenerator
{
    Task<string> GenerateAsync(CancellationToken cancellationToken);
}
```

This can represent a meaningful external/business boundary.

Poor abstraction:

```csharp
public interface IRepository<T>
{
    Task<T?> GetAsync(Guid id);
    Task AddAsync(T entity);
    Task SaveAsync();
}
```

If it merely renames `DbSet`, LINQ, and `SaveChangesAsync`, it adds indirection without protecting a useful boundary.

## Mapping

Keep mappings explicit when they clarify transformations and boundaries. For new projects, explicit `ToEntity()` / `ToDto()` methods are a preferred default when they remain readable.

```csharp
public static UserDto ToDto(this User user) =>
    new(user.Id, user.Email);
```

Existing projects may use Mapster, AutoMapper, or another mapper. Do not replace an established mapper without a concrete reason.

## Dependency selection

For new projects, evaluate options in this order:

1. Existing platform/framework capability.
2. Existing dependency already accepted by the project.
3. Small explicit implementation when the problem is simple and non-sensitive.
4. New dependency when complexity, reliability, ecosystem support, or security makes it worthwhile.

For a new third-party dependency not already established by the repository, explain the trade-off and ask the user before adding it unless the task explicitly requested it or the repository requires it.

Never implement security-sensitive primitives yourself merely to avoid a package.

## Architecture anti-patterns

The following are common architectural warning signs, not automatic defects. Evaluate them against the project's requirements, constraints, existing conventions, and actual abstraction boundaries before recommending changes.

❌ Microservices without independent deployment, ownership, scaling, or isolation needs.

❌ Generic repositories that only wrap EF Core.

❌ An abstraction for every class “just in case” it needs mocking.

❌ A shared utility/project that becomes a dumping ground for unrelated behavior.

❌ Business rules implemented in controllers/endpoints, persistence hooks, or AppHost orchestration merely because those layers are convenient.

❌ Architecture where every feature crosses many projects for trivial changes.

## Review questions

Before introducing a layer, project, service, abstraction, or dependency:

- What problem does this solve?
- What coupling does it remove?
- What invariant does it protect?
- What complexity does it introduce?
- Could the existing framework or architecture solve this cleanly?
- Will common changes become easier or harder?
- Is the boundary likely to remain stable?

If the answer is primarily “future flexibility,” prefer waiting until the need is demonstrated.
