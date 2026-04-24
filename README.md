# Symposium

Multi-agent coding workbench. Rust backend + Python agents + React frontend.

## Structure

- `src-core/` — Core Rust libraries shared across workspace
- `src-backend/` — Axum HTTP server, orchestrates agents and workspace
- `src-agents/` — Agent runtime (PyO3 bridge to Python)
- `src-web/` — React + Vite frontend (Monaco, Tiptap, TanStack Router, Framer, Lucide)

## Dev

```bash
make dev-backend
```

```bash
make dev-agent
```

```bash
make dev-web
```

## Build

```bash
make build
```

## Docker

```bash
make docker-up
```

## Stack

- **Backend:** Rust, Axum, Tokio
- **Agents:** PyO3 (Python runtime)
- **Frontend:** React, Vite, Monaco Editor, Tiptap, TanStack Router, Framer, Lucide Icons
