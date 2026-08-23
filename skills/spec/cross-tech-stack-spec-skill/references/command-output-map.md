# Cross-Tech Skill Command Output Map

This page explains the typical outputs produced when `cross-tech-stack-spec-skill` is enabled.

Diagram placement rule:

- embed diagrams directly in the corresponding document by default
- use `mydocs/diagrams/` only when the diagram needs reuse across documents, independent frequent updates, centralized asset management/export, or the user explicitly asks for diagram/text separation
- if a diagram is split into `mydocs/diagrams/`, the parent document should keep a short explanation and a direct link to that diagram
- mixed-stack diagrams should label edge type explicitly, such as `HTTP`, `Gateway`, `Bridge`, `MQ`, `Callback`, `Local dependency`, or `Runtime invocation`

## Base extension enabled without optional switches

Typical outputs:

- workspace layering page
- mixed-stack noise-control page
- communication evidence matrix
- interface mapping page
- mixed-stack key route page
- mixed-stack domain page
- mixed-stack architecture diagram in Markdown + Mermaid
- cross-layer call graph in Markdown + Mermaid

## `enable_contract_map`

Typical outputs:

- contract detail page
- request parameter table
- response field table
- caller/handler contract mapping
- interface mapping diagram

## `enable_gateway_map`

Typical outputs:

- gateway/forwarding route page
- gateway route list
- rewrite/auth summary
- gateway-to-handler mapping
- gateway forwarding diagram

## `enable_field_lineage`

Typical outputs:

- field lineage page
- caller -> DTO -> service -> downstream field flow table
- rename/transform notes
- field movement diagram when useful

## `enable_context_propagation_map`

Typical outputs:

- context propagation page
- header/token/user/tenant/trace propagation table
- injection and rewrite points
- context propagation diagram

## `enable_error_semantics`

Typical outputs:

- error semantics page
- error code / exception mapping
- retry/fallback/compensation summary
- failure-path sequence diagram when useful

## `enable_async_contract_map`

Typical outputs:

- async contract page
- producer -> topic/queue -> consumer mapping
- payload/schema clues
- retry / DLQ / idempotency summary
- producer/topic/consumer route diagram

## `enable_external_dependency_dossier`

Typical outputs:

- external dependency dossier page
- provider / consumer / interface-channel list
- owner / version / risk clues

## `enable_interface_verification_assets`

Typical outputs:

- verification assets page
- swagger/openapi/postman/mock/contract test inventory
- asset coverage page

## Full Analysis Mode

When the base skill, extension skill, and all 8 switches are enabled together, the full output set usually includes:

- workspace layering
- noise control
- codemap overview
- multiple service deep dives
- multiple router-map pages
- interface mapping
- contract details
- gateway forwarding
- field lineage
- context propagation
- error semantics
- async contracts
- mixed-stack architecture diagram
- multiple cross-layer call graphs
- multiple sequence diagrams
- mixed-stack interface/gateway/context/async diagrams
- external dependency dossier
- verification assets
- mixed-stack domain page
- validation page
- unresolved list
- index page
