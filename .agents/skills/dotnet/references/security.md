# Security

Use this reference whenever code handles authentication, authorization, untrusted input, secrets, sensitive data, network boundaries, serialization, or security-sensitive infrastructure.

## Security principles

- Treat all external input as untrusted.
- Prefer established .NET/framework/library security primitives over custom cryptography or protocol implementations.
- Fail closed for authentication and authorization decisions.
- Minimize privileges, data exposure, and trust boundaries.
- Make security behavior explicit and testable.
- Do not weaken security merely to simplify development or tests.

## Authentication

Choose authentication based on the actual client and deployment model:

- OAuth 2.0 / OpenID Connect for delegated or federated identity scenarios.
- JWT bearer authentication when stateless bearer tokens are actually required.
- Cookies for browser-oriented session authentication when appropriate.
- API keys only for scenarios where their operational and security properties are acceptable.

Validate tokens using established framework components. Do not manually implement JWT parsing, signature validation, key rotation, or OAuth/OIDC protocol behavior.

Authentication answers **who is the caller**. Authorization answers **what the caller may do**.

## Authorization

Authorize as close as practical to the protected resource and operation.

Use policies, claims, roles, or resource-based authorization according to the actual access model. Do not rely solely on hiding UI controls or trusting client-supplied identity/role information.

For multi-tenant systems, enforce tenant boundaries server-side on every relevant access path. A tenant identifier supplied by a client is not proof that the caller may access that tenant.

## Input and output

Validate shape and basic constraints at the boundary. Enforce business invariants in the appropriate application/domain layer.

Avoid mass assignment and over-posting. Explicit request models should determine which fields a client may change.

Do not expose internal entities, stack traces, database details, secrets, tokens, or sensitive fields through API responses.

## Injection

Use parameterized APIs and framework abstractions for database access. Never concatenate untrusted values into SQL, shell commands, LDAP queries, or other interpreters.

Validate or constrain dynamic identifiers such as column names, file paths, hostnames, and URLs rather than treating them as ordinary values.

## SSRF and outbound requests

Treat user-controlled URLs and network destinations as security-sensitive.

When accepting or deriving remote destinations:

- validate allowed schemes
- constrain hosts/domains where appropriate
- prevent access to internal/private network ranges when the threat model requires it
- limit redirects when necessary
- apply timeouts and response-size limits
- avoid exposing raw network errors to clients

Do not assume a URL is safe merely because it uses HTTPS.

## Deserialization

Use safe, typed serialization formats and trusted framework configuration. Do not enable unsafe polymorphic deserialization or deserialize attacker-controlled type metadata without a clear security model.

Treat uploaded documents, images, archives, and other files as untrusted input.

## Path traversal and file handling

Never combine untrusted path fragments with filesystem paths without validation and containment checks.

Apply size limits, extension/content validation, storage isolation, and safe generated names when accepting uploads.

Do not serve arbitrary filesystem paths directly from user input.

## Browser security

For browser applications, consider CSRF, XSS, CORS, cookie flags, content security policy, and secure transport as part of the threat model.

CORS is not an authentication mechanism. It controls browser-origin access; server-side authorization must still be enforced.

For cookie authentication, configure `Secure`, `HttpOnly`, and an appropriate `SameSite` policy for the deployment model.

## Secrets and sensitive data

Do not commit credentials, private keys, access tokens, or connection secrets.

Use the environment's supported secret-management mechanism. Avoid logging secrets or sensitive personal data.

Review logs, telemetry, exceptions, traces, and metrics for accidental data disclosure.

Encrypt sensitive data in transit and at rest when required by the threat model and operational environment. Prefer established platform/library implementations.

## HTTPS and transport

Use HTTPS in production and configure certificate validation correctly. Do not disable TLS certificate validation as a troubleshooting shortcut that reaches production code.

Set appropriate timeouts and limits for network-facing operations.

## Rate limiting and abuse

Apply rate limiting where an endpoint can be abused through high request volume, expensive computation, authentication attempts, resource enumeration, or external-service fan-out.

Rate limiting is one control among authentication, authorization, validation, quotas, and resource limits.

## Dependencies

Keep dependencies minimal and maintained, but do not reject a mature security library merely because it adds a package.

For cryptography, password hashing, token validation, OAuth/OIDC, TLS, and other security-sensitive primitives, prefer established implementations over custom code.

Review dependency vulnerabilities and transitive dependencies as part of normal maintenance.

## Threat modeling

For meaningful security-sensitive features, identify:

1. Assets being protected.
2. Trust boundaries.
3. Actors and attacker capabilities.
4. Entry points and untrusted inputs.
5. Authorization decisions.
6. Abuse cases and likely failure modes.
7. Mitigations and residual risk.

## Security review checklist

Before completing a security-sensitive change, verify:

- Authentication is appropriate and correctly validated.
- Authorization is enforced for the actual resource/action.
- Tenant boundaries are enforced when applicable.
- Inputs are validated and constrained.
- Injection paths are parameterized or otherwise safely handled.
- Outbound requests cannot create an unintended SSRF boundary.
- Deserialization and file handling are safe.
- Secrets and sensitive data are not exposed in source, responses, or telemetry.
- Transport security is preserved.
- Abuse/rate limits are appropriate.
- Security-sensitive primitives rely on established implementations.
- Failure behavior does not accidentally fail open.
