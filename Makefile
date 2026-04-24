.PHONY: help dev-backend dev-agent dev-web check build-rust build-web build clean docker-build docker-up docker-down

help:
	@echo "Symposium — Multi-agent coding workbench"
	@echo ""
	@echo "Development:"
	@echo "  make dev-backend    Run backend server"
	@echo "  make dev-agent      Run agent binary"
	@echo "  make dev-web        Run Vite dev server"
	@echo ""
	@echo "Build & Check:"
	@echo "  make check          cargo check --workspace"
	@echo "  make build-rust     cargo build --release (Rust)"
	@echo "  make build-web      npm run build (React)"
	@echo "  make build          build-rust + build-web"
	@echo "  make clean          Clean all build artifacts"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build   Build Docker image"
	@echo "  make docker-up      Start containers"
	@echo "  make docker-down    Stop containers"

dev-backend:
	cd src-backend && cargo run -p symposium-backend

dev-agent:
	cargo run -p symposium-agents --bin agent -- run

dev-web:
	cd src-web && npm run dev

check:
	cargo check --workspace

build-rust:
	cargo build --workspace --release

build-web:
	cd src-web && npm run build

build: build-rust build-web

clean:
	cargo clean
	rm -rf src-web/dist
	rm -rf src-web/node_modules

docker-build:
	docker compose build

docker-up:
	docker compose up -d

docker-down:
	docker compose down
