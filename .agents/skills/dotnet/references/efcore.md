# EF Core

Use this reference when working with Entity Framework Core, relational persistence, queries, transactions, migrations, or database-related performance.

## DbContext

- Treat `DbContext` as a short-lived unit of work.
- Use dependency injection with an appropriate lifetime for the application model.
- Do not share a context concurrently across unrelated operations.
- Keep persistence configuration close to the model while avoiding unnecessary infrastructure abstraction.

## Modeling

Model actual domain and data constraints explicitly:

- required vs optional properties
- keys and alternate keys
- indexes
- foreign keys and relationships
- delete behavior
- unique constraints
- value conversions
- owned/complex types where appropriate

Prefer database-enforced constraints for invariants that must hold regardless of application path.

## Querying

Design queries around the data actually needed.

- Prefer projection over loading full entities when only a subset is required.
- Use `AsNoTracking()` for read-only entity queries when tracking provides no value.
- Consider identity resolution or tracking when duplicate entity instances would cause correctness issues.
- Avoid unnecessary `Include`; projection is often a better read model.
- Bound result sets.
- Apply filtering and ordering before materialization.
- Avoid loading large collections into memory when the database can perform the operation.
- Inspect generated SQL when query behavior or performance is uncertain.

For CQRS-style queries, projecting directly to a DTO/read model is often preferable to materializing domain entities first.

## Pagination

Always consider result size for collection queries. Use deterministic ordering before pagination.

Offset pagination is simple and appropriate for many cases. For large datasets or frequently changing ordered data, consider keyset/cursor pagination.

Never construct SQL fragments from untrusted column names, filter expressions, or sort input.

## Related data

Be deliberate about eager, explicit, and lazy loading. Lazy loading can hide database round trips and create N+1 behavior; do not enable it without understanding the trade-offs.

When multiple collection relationships are included, evaluate whether a single query creates cartesian explosion. Split queries can help, but they also introduce additional round trips; choose based on measured query shape and consistency requirements.

## Writes and transactions

Keep write operations within a clear unit of work. EF Core's `SaveChanges` transaction behavior is often sufficient for a single save operation.

Use explicit transactions when multiple database operations must commit atomically or when the workflow spans multiple saves that share transactional invariants.

Do not wrap every operation in an explicit transaction by habit.

## Concurrency

Prefer optimistic concurrency when appropriate. Configure a concurrency token/version and handle `DbUpdateConcurrencyException` intentionally.

Do not silently retry or overwrite conflicting state without understanding the business semantics.

Concurrency failures should be translated at the application/API boundary into an appropriate conflict result.

## Migrations

Migrations are part of the application's schema evolution process.

- Review generated migrations instead of blindly applying them.
- Check destructive operations carefully.
- Consider deployment ordering for schema changes that must support multiple application versions.
- Keep data migrations explicit when transformations cannot safely be represented as simple schema operations.
- Never treat production schema changes as an incidental side effect of application startup unless that is an intentional deployment strategy.

## Raw SQL and database-specific features

EF Core LINQ should be the default when it expresses the query clearly and efficiently.

Raw SQL is appropriate when it provides a concrete benefit, such as database-specific functionality, a query shape EF cannot express well, or a measured performance requirement.

Always parameterize values. Do not interpolate untrusted input into SQL or database identifiers.

## Interceptors and conversions

Interceptors, value converters, conventions, and save/query hooks are powerful. Use them for cross-cutting persistence behavior that genuinely belongs at that boundary.

Avoid hiding significant business behavior inside persistence hooks where it becomes difficult to reason about control flow.

## Testing

Test persistence behavior that depends on relational semantics against a relational database provider when practical. In-memory substitutes can behave differently from a relational database and should not be treated as equivalent merely because tests pass.

Prefer focused integration tests for:

- mappings and constraints
- important queries
- transactions
- concurrency behavior
- migrations/schema compatibility

## EF Core performance checklist

When performance matters:

1. Measure the actual operation.
2. Inspect query count and generated SQL.
3. Check indexes and execution plans when appropriate.
4. Reduce unnecessary columns and rows.
5. Check tracking and materialization costs.
6. Look for N+1 queries and cartesian explosion.
7. Check pagination and result bounds.
8. Consider database-side computation before application-side materialization.
9. Re-measure after the smallest useful change.

Do not add compiled queries, caching, raw SQL, or other optimizations without evidence that they address a real bottleneck.
