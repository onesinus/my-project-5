# Prompt: Write API documentation

## When to use

You have an API endpoint and need to document it — OpenAPI spec, JSDoc, or markdown docs.

## Template

```
Context:
- Endpoint: [method] [path]
- Source file: [path to handler/route file]
- Existing docs: [path to OpenAPI spec or docs file to extend]
- Format: [OpenAPI 3.0 / JSDoc / markdown]

Task:
Write documentation for the [endpoint name] endpoint.

Include:
- Description of what the endpoint does
- Request parameters (path, query, headers, body)
- Request body schema (required and optional fields, types, examples)
- Response codes and schemas (200, 201, 4xx, 5xx)
- Authentication requirements
- Example request and response (one happy path, one error)

Constraints:
- Match existing documentation style and format
- Do not change the API behaviour, add new fields, or fix bugs
- Flag any inconsistencies between code and existing docs

Output format:
Complete documentation block ready to insert.
```

## Example

```
Context:
- Endpoint: POST /api/checkout
- Source file: src/routes/checkout.ts
- Existing docs: docs/api/openapi.yaml
- Format: OpenAPI 3.0

Task: Write documentation for the checkout endpoint...
```
