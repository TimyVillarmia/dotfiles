# API Engineering

Use this reference when a .NET application exposes or consumes HTTP APIs.

## Contract first

- Treat the API contract as a deliberate public boundary.
- Design resource names, HTTP methods, status codes, request/response shapes, and error behavior intentionally.
- When OpenAPI is used, keep the document aligned with the actual implementation; avoid documenting behavior that the server does not provide.
- Prefer stable contracts over leaking internal domain or persistence models.

## HTTP semantics

Use HTTP semantics consistently:

- `GET` retrieves representations and should not mutate state.
- `POST` creates resources or performs non-idempotent operations where appropriate.
- `PUT` replaces a resource representation and is idempotent when the contract defines it that way.
- `PATCH` performs partial updates when supported by the chosen patch semantics.
- `DELETE` removes or logically removes a resource according to the contract.

Choose status codes based on the operation's externally observable result rather than implementation details.

Typical mappings include:

- `200 OK` — successful response with a representation.
- `201 Created` — resource created; provide its location when meaningful.
- `202 Accepted` — work accepted for asynchronous processing.
- `204 No Content` — successful operation with no response body.
- `400 Bad Request` — malformed or invalid request semantics.
- `401 Unauthorized` — authentication is required or invalid.
- `403 Forbidden` — authenticated caller is not permitted.
- `404 Not Found` — requested resource does not exist or is intentionally undiscoverable.
- `409 Conflict` — state conflict or concurrency conflict.
- `422 Unprocessable Content` — use only when the API contract deliberately distinguishes semantic validation from malformed requests.
- `429 Too Many Requests` — rate limit exceeded.
- `500 Internal Server Error` — unexpected server failure.

## Result pattern at the boundary

If the application uses a Result/ErrorOr-style model, translate expected failures at the HTTP boundary. Do not expose internal result types as the API contract unless that is an intentional public design.

Map domain/application errors to meaningful HTTP semantics. Keep unexpected exceptions on the centralized error-handling path rather than converting every exception into an application-level result.

## Validation

Validate input at the boundary and enforce business invariants in the appropriate application/domain layer. Do not rely on client validation for security or correctness.

Return consistent validation errors. Prefer ProblemDetails-compatible responses where appropriate.

Avoid duplicating validation rules across controller, handler, and domain layers unless each layer is enforcing a different invariant.

## OpenAPI and API UI

Generate or maintain OpenAPI documentation from the actual contract. Include meaningful descriptions, parameters, request/response schemas, authentication requirements, and error responses.

Scalar can be used as an interactive API UI when the project chooses it. Scalar is presentation tooling; it does not replace OpenAPI contract design.

## Pagination, filtering, and sorting

For collection endpoints:

- Bound result sizes.
- Define pagination semantics explicitly.
- Prefer stable ordering before applying pagination.
- Validate page size and filter/sort inputs.
- Avoid exposing arbitrary database expressions or column names directly from clients.
- Consider cursor/keyset pagination when large or frequently changing datasets make offset pagination unsuitable.

## Idempotency and concurrency

For operations that may be retried, explicitly decide whether the operation is naturally idempotent or requires an idempotency mechanism.

For concurrent updates, define the conflict behavior. Optimistic concurrency commonly maps a detected state conflict to `409 Conflict` when that matches the API contract.

Do not silently overwrite newer state merely because the client submitted an older representation.

## Authentication and authorization

API design identifies where authentication and authorization participate in the contract; security guidance determines how they are safely implemented.

Do not confuse authentication (`401`) with authorization (`403`). Resource-level authorization must happen against the actual resource being accessed, not only against an endpoint or broad role.

See `references/security.md` for implementation guidance.

## API design checklist

Before completing an API change, verify:

- Request and response contracts are intentional.
- Status codes match HTTP semantics.
- Validation behavior is consistent.
- Error responses are documented and stable.
- Authorization is enforced at the correct resource boundary.
- Pagination/filtering/sorting cannot create unbounded or unsafe queries.
- OpenAPI reflects actual behavior.
- Serialization does not accidentally expose internal fields or sensitive data.
- Retries, idempotency, and concurrency behavior are understood.
- Tests cover the externally observable contract.
