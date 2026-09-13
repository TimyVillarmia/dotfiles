---
name: dotnet-scaffold
description: Scaffold new .NET solutions, projects, or features while preserving repository conventions and applying proportional architecture and dependency decisions. Use when creating a .NET solution/project, adding a project to a solution, or generating a complete feature/entity/API slice in an existing .NET project.
---

# .NET Scaffolding

Use this workflow to create a complete, working .NET solution, project, or feature. Reuse the `dotnet` skill for engineering principles, architecture, C#/.NET version guidance, APIs, EF Core, testing, security, and dependency decisions. Do not duplicate those rules here.

## Scope

First determine what is being scaffolded:

1. **New solution/repository** — establish the solution and required projects.
2. **New project** — add a project to an existing solution/repository.
3. **New feature/entity** — add a complete vertical slice or feature to an existing project.

Do not turn a feature-scaffolding request into a broader solution redesign. Do not impose a project template, architecture, mediator, mapper, validation library, or other dependency before inspecting requirements and the repository.

## Workflow

### 1. Understand the request

Identify the minimum information needed to scaffold correctly:

- intended application/project type and purpose
- required capabilities and boundaries
- feature/entity name and operations when applicable
- persistence, external integrations, or infrastructure requirements
- testing and deployment/runtime expectations when relevant

Do not ask questions that can be answered by inspecting the repository or environment.

### 2. Inspect the environment

Before generating files, inspect:

- repository instructions and conventions
- installed .NET SDKs and relevant workloads/templates
- target framework and C# language version when already established
- solution/project structure
- existing dependencies and package versions
- entry points, DI/registration, endpoint organization, persistence, and test projects
- existing architecture and representative features

For a genuinely new project, establish the target SDK/framework and required capabilities before selecting the project shape.

### 3. Choose the project shape and architecture

Use the requirements and repository evidence to decide:

- solution/project structure
- executable/library/API/worker/web shape
- boundaries and dependency direction
- whether CQRS, Vertical Slice, Clean Architecture, Modular Monolith, or other patterns provide concrete value

Prefer the simplest architecture that protects the real boundaries and requirements. Existing repository conventions take precedence. For a new project, apply the `dotnet` skill's personal defaults only after requirements and architecture have been established.

### 4. Decide dependencies

Follow the dependency decision rules in the `dotnet` skill. In order:

```text
Framework/platform capability
        ↓
Existing project dependency
        ↓
Small explicit implementation for simple, non-sensitive functionality
        ↓
New third-party dependency when justified
```

Do not ask for approval before using an existing dependency. For a new dependency, explain the trade-off and obtain approval when an interactive channel exists. In explicitly autonomous/headless execution, do not silently introduce a new third-party dependency; report the decision and alternatives if approval is unavailable.

### 5. Scaffold

Generate only what the requirements call for, matching established conventions.

For a new solution/project, create the required solution/project files and only the infrastructure needed to make the intended application shape coherent.

For a feature/entity, generate the applicable parts of the feature such as:

- request/command/query types
- handler/use-case logic
- endpoint/API contract
- validation
- DTOs and explicit mapping where applicable
- persistence model/configuration where applicable
- DI or endpoint registration where the existing project requires it
- tests at the appropriate behavioral boundary

Do not generate ceremony merely because a reference template contains it. Do not overwrite existing files or conventions without a concrete reason.

### 6. Configure

Wire the generated pieces into the application using its established conventions. Account for:

- dependency injection
- endpoint/route registration
- configuration and Options patterns
- persistence and migrations when applicable
- serialization/OpenAPI behavior when applicable
- local development/orchestration when the repository uses Aspire or similar tooling

Keep infrastructure concerns in their appropriate project/boundary.

### 7. Verify

Choose verification proportional to the change. At minimum, prove that generated code is structurally valid and builds when the environment permits it.

Typical verification:

- restore
- build affected project, then broader solution when warranted
- focused tests, then broader tests when relevant
- formatter/analyzers when appropriate
- application startup or API smoke test for runnable applications
- database/migration checks when persistence changed
- inspect generated dependencies and project references

Do not claim scaffolding is complete merely because files were generated. Report checks that could not be run and why.

## Completeness checklist

Before reporting completion, verify the applicable items:

- [ ] Correct solution/project structure
- [ ] Required application/domain components
- [ ] Required endpoint/API surface
- [ ] Handler/use-case implementation where applicable
- [ ] Validation where required
- [ ] DTO/request/response contracts where appropriate
- [ ] Explicit mapping where the project uses it
- [ ] Persistence configuration where applicable
- [ ] DI/registration where required
- [ ] `CancellationToken` propagation across meaningful async boundaries
- [ ] Result/error to transport mapping where applicable
- [ ] Tests for important behavior and boundaries
- [ ] OpenAPI metadata where applicable
- [ ] Configuration/Options wiring where applicable
- [ ] Restore/build/tests or the appropriate verification subset passed
- [ ] No unintended changes or unnecessary dependencies

Do not require every item for every project. "Applicable" is determined by the requirements and existing architecture.

## Boundaries

This skill does not:

- replace the `dotnet` skill's engineering guidance
- automatically migrate an existing architecture to personal preferences
- require a specific mediator, mapper, Result library, validation library, or architecture
- introduce third-party dependencies silently
- perform unrelated refactoring
- replace a dedicated code-review workflow
- require MCP servers, plugins, hooks, or other agent-specific tooling

If semantic code-navigation tooling is available, prefer bounded semantic inspection for large or unfamiliar codebases when it materially improves accuracy or reduces unnecessary context. The workflow must remain useful without it.

## Reporting

Report:

1. What was scaffolded.
2. Key architecture/dependency decisions and any deviations from repository conventions.
3. Files/projects added or materially changed.
4. Verification performed and results.
5. Any unresolved decision, failed check, or follow-up required.
