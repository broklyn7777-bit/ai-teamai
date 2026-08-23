# Backend Skill Command Output Map

This page explains the typical outputs produced by the common commands in `backend-service-spec-skill`, and which layer inside `mydocs/` those outputs usually belong to.

Diagram placement rule:

- embed diagrams directly in the corresponding document by default
- use `mydocs/diagrams/` only when the diagram needs reuse across documents, independent frequent updates, centralized asset management/export, or the user explicitly asks for diagram/text separation
- if a diagram is split into `mydocs/diagrams/`, the parent document should keep a short explanation and a direct link to that diagram

## `create_codemap`

Typical outputs:

- service inventory page
- service relationship overview
- technology and module layering page
- upstream/downstream dependency summary
- scope note for the current pass
- architecture diagram in Markdown + Mermaid
- service call graph in Markdown + Mermaid

Typical directory:

```text
mydocs/codemap/
```

Recommended companion diagram directories:

```text
mydocs/diagrams/architecture/
mydocs/diagrams/call-graph/
```

## `service_deep_dive`

Typical outputs:

- single-service structure page
- interface inventory page
- module partition page
- dependency page
- service rules/spec page
- open gaps and risks page
- upstream/downstream dependency diagram in Markdown + Mermaid
- internal module architecture diagram in Markdown + Mermaid

Typical directory:

```text
mydocs/services/
```

Recommended companion diagram directories:

```text
mydocs/diagrams/upstream-downstream/
mydocs/diagrams/architecture/
```

## `crate_router_map`

Typical outputs:

- key route page
- segmented call path page
- synchronous call page
- asynchronous message page
- retry/compensation/realtime channel page
- route closure status page
- sequence diagram in Markdown + Mermaid
- route call graph in Markdown + Mermaid

Typical directory:

```text
mydocs/routermap/
```

Recommended companion diagram directories:

```text
mydocs/diagrams/sequence/
mydocs/diagrams/call-graph/
```

## `build_domain_map`

Typical outputs:

- domain page
- domain -> service -> spec mapping page
- domain-level key route summary
- domain rules page
- fact boundary note
- domain context diagram in Markdown + Mermaid

Typical directory:

```text
mydocs/domains/
```

Recommended companion diagram directory:

```text
mydocs/diagrams/architecture/
```

## Recommended Directory Layout

```text
mydocs/
  README.md
  codemap/
  services/
  domains/
  routermap/
  diagrams/
  context/
  specs/
  validation/
  index/
```

Diagram artifact format:

- use `.md` by default
- embed Mermaid in fenced code blocks
- treat image export as a derived result, not the primary source

## Lightweight Full Analysis

Typical output set:

- 1 scope page
- 1 codemap overview
- 1 to 2 service deep-dive pages
- 1 to 2 key route pages
- 1 index page

## Heavy Full Analysis

Typical output set:

- 1 scope page
- 1 codemap overview
- multiple service deep-dive pages
- multiple key route pages
- 1 domain page
- 1 validation page
- 1 unresolved list
- 1 index page
