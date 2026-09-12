# Architecture

Use this reference when designing or changing application structure, boundaries, dependency direction, or major components.

## Start from requirements

Architecture is a means to satisfy requirements and constraints. Do not choose an architecture because it is fashionable or because a template exists.

Consider:

- business/domain complexity
- team size and ownership
- deployment topology
- operational requirements
- expected change patterns
- integration boundaries
- testing needs
- performance and scaling requirements
- security and compliance constraints

Prefer the least complex architecture that preserves the boundaries the system actually needs.

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

Use this when feature cohesion and independent change are more valuable than a shared horizontal layer structure.

CQRS fits naturally when commands and queries have materially different behavior, data access, performance, or models. It does not require separate databases or services.

A common flow is:

```text
Command -> Mediator -> Application/Domain -> Persistence
Query   -> Mediator -> Persistence -> Projection -> DTO
```

This is a pattern, not a universal requirement.

## Clean Architecture

Clean Architecture is useful when dependency direction and domain isolation are important. Its value comes from controlling dependencies and protecting business rules, not from creating a fixed number of projects.

Avoid layers that contain no meaningful behavior merely to satisfy an architectural diagram.

A pragmatic implementation may combine Clean Architecture principles with vertical slices when that better matches the system.

## Dependency direction

Dependencies should point toward stable, meaningful abstractions and business rules rather than toward implementation details when isolation is required.

Ask:

- Who owns this behavior?
- Who needs to change together?
- Which dependency is likely to vary?
- Is this boundary protecting a real invariant or merely adding indirection?

Do not create abstractions solely because a dependency is technically replaceable.

## Repositories and persistence abstractions

EF Core already provides substantial abstraction over database access. Do not introduce a generic repository or unit-of-work wrapper by default.

Add a persistence abstraction when it provides a concrete architectural benefit, such as isolating a meaningful external boundary, enforcing a domain-specific persistence contract, or enabling a required testing strategy.

Avoid abstractions that simply rename `DbSet`, `SaveChangesAsync`, or LINQ without adding useful behavior.

## Mapping

Keep mappings explicit when they clarify boundaries and transformations. Explicit `ToEntity()` and `ToDto()` methods are a preferred default for new projects when they keep transformations obvious and easy to debug.

Existing projects may use Mapster, AutoMapper, or another mapping approach. Do not replace an established mapper without a concrete reason.

## Dependency selection

For new projects, evaluate implementation options in this order:

1. Existing project/framework capability.
2. Existing dependency already accepted by the project.
3. Small explicit implementation when the problem is simple and non-sensitive.
4. New dependency when complexity, reliability, ecosystem support, or security makes it worthwhile.

For a new third-party dependency, explain the trade-off before adding it unless the task explicitly requested it or the repository already establishes that dependency.

Never implement security-sensitive primitives yourself merely to avoid a package.

## Architecture review questions

Before introducing a new layer, project, service, abstraction, or dependency, ask:

- What problem does this solve?
- What coupling does it remove?
- What invariant does it protect?
- What complexity does it introduce?
- Could the existing framework or architecture solve this cleanly?
- Will this make common changes easier or harder?
- Is the boundary likely to remain stable?

If the answer is primarily "future flexibility," prefer waiting until the need is demonstrated.
