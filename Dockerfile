# Multi-stage build for Symposium
# Stage 1: rust-builder
# Stage 2: web-builder
# Stage 3: runtime

FROM rust:1.82-slim-bookworm as rust-builder

RUN apt-get update && apt-get install -y \
	pkg-config \
	libssl-dev \
	python3 \
	python3-dev \
	python3-pip \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Cargo.toml ./
COPY src-core/Cargo.toml ./src-core/
COPY src-core/src ./src-core/src
COPY src-backend/Cargo.toml ./src-backend/
COPY src-backend/src ./src-backend/src
COPY src-agents/Cargo.toml ./src-agents/
COPY src-agents/src ./src-agents/src

RUN cargo build --release --workspace

FROM node:24-slim as web-builder

WORKDIR /app

COPY src-web/package*.json ./

RUN npm ci

COPY src-web/ ./

RUN npm run build

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
	python3 \
	libssl3 \
	ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=rust-builder /app/target/release/symposium-backend /usr/local/bin/
COPY --from=rust-builder /app/target/release/agent /usr/local/bin/
COPY --from=web-builder /app/dist /srv/web

EXPOSE 8080

CMD ["symposium-backend"]
