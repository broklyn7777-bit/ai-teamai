# Mixed-Stack Diagram Output Guidelines

This page defines how `cross-tech-stack-spec-skill` should output diagrams for mixed-stack repositories.

## Default Format

- prefer `.md` files with Mermaid fenced blocks
- avoid image-only output as the primary artifact
- keep nearby explanatory text so both humans and AI can read the diagram in context

## Recommended Diagram Types

- global mixed-stack architecture
- cross-layer call graph
- sequence flow across page/app/backend/task/callback/bridge layers
- code dependency graph versus runtime dependency graph
- interface mapping
- context propagation
- gateway forwarding
- async contract routes

## Placement Rule

Default strategy:

- embed the diagram directly into the corresponding document first

Only split to `mydocs/diagrams/` when at least one of these is true:

- the same diagram must be reused across multiple documents
- the diagram is expected to change independently and frequently
- the team wants centralized diagram export or asset management
- the user explicitly asks for diagram/text separation

If the diagram is split out:

- keep a short summary in the parent document
- add a direct link to the standalone diagram file
- keep enough local wording around the link so AI can still understand the diagram's role

## Edge Label Rule

Always label edge types explicitly in mixed-stack diagrams, for example:

- `HTTP`
- `Gateway`
- `Bridge`
- `MQ`
- `Callback`
- `Local dependency`
- `Runtime invocation`

## Explanation Rule

Below each diagram, add a short explanation that covers:

- what the main nodes represent
- what the main edge labels mean
- which evidence sources support the visible relationships
- which parts are fully closed, partially closed, or unresolved

Do not present guessed relationships as confirmed relationships in either the diagram or the explanatory text.

## Mermaid Compatibility Baseline

To reduce parser differences across Mermaid renderers, mixed-stack diagrams should also follow these rules:

- prefer role-semantic or action-semantic node labels instead of full method signatures
- avoid packing `method(arg)`, generics, JSON fragments, unescaped quotes, or dense punctuation into one node
- keep exact method names, DTO names, enum names, Redis keys, and topic names in the explanatory text below the diagram
- if you need to express a lookup by field, prefer a short phrase such as `query relation by businessId`
- if a node needs multiple ideas, shorten it; the node should optimize for stable rendering and fast recognition, while the surrounding text carries code-level precision
- after generating the diagram, explicitly compare it against `mermaid-safety-checklist.zh-CN.md` and its good/bad examples before delivery

## Minimal Mermaid Template

```mermaid
flowchart LR
    Page[Page / Screen]
    App[App / Client Module]
    Api[Backend API]
    Task[Async Task]

    Page -->|HTTP| Api
    Page -->|Bridge| App
    Api -->|Runtime invocation| Task
```

## Read Next

- [Mixed-Stack Diagram Output Example Template](./diagram-output-example-template.md)
