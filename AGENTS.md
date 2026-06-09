# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Project Overview

Lab website with public-facing pages and admin backend. Vue3 SPA frontend, SpringBoot REST API backend, MySQL database. Single admin role manages all content via JWT-authenticated admin panel.

## Development Commands

### Frontend (`labweb-frontend/`)

```bash
cd labweb-frontend
npm install                # Install dependencies
npm run dev                # Start dev server on :3000 (proxies /api to :8080)
npm run build              # Production build
```

### Backend (`labweb-backend/`)

```bash
cd labweb-backend
mvn spring-boot:run        # Start backend on :8080
mvn clean package          # Build JAR
mvn test                   # Run tests
```

### Database

MySQL 8.0+ on `localhost:3306/labweb`. Tables are auto-created on startup via `schema.sql` (`spring.sql.init.mode=always`). Default credentials in `application.yml` (root/root). Change before deploying.

## Architecture

### Frontend (`labweb-frontend/src/`)

- **Framework**: Vue3 (Composition API, `<script setup>`), Vite, Element Plus (Chinese locale)
- **State**: Pinia stores (`stores/auth.js` for JWT token/username, `stores/lab.js` for lab info cache)
- **Routing**: `router/index.js` — public routes (`/`, `/about`, `/research`, `/research/:id`, `/publications`, `/tools`, `/agents`, `/contact`, `/admin/login`), admin routes nested under `/admin/*` with auth guard
- **API layer**: `api/index.js` creates an Axios instance (baseURL `/api/v1`, auto-attaches JWT `Authorization` header). Each domain module (`api/auth.js`, `api/publication.js`, etc.) exports typed request functions
- **Layout**: Public pages use `NavBar` + `Footer` wrappers. Admin uses `Layout.vue` with sidebar (`el-aside` + `el-menu` with `router` mode) and `<router-view>` outlet
- **Global CSS**: `assets/styles/global.css` — reset, `.page-banner` gradient (dark blue), `.card-item` with hover lift, CSS custom properties override Element Plus primary to `#2a6496`

### Backend (`labweb-backend/src/main/java/com/labweb/`)

- **Framework**: SpringBoot 3.2.5, MyBatis-Plus 3.5.6, JWT (jjwt 0.12.5), BCrypt via spring-security-crypto
- **Package structure**:
  - `entity/` — MyBatis-Plus entities (User, LabInfo, ResearchDirection, Publication, Tool, Agent, FileResource)
  - `mapper/` — MyBatis-Plus BaseMapper interfaces
  - `service/` + `service/impl/` — service interfaces + implementations
  - `controller/` — REST controllers
  - `common/` — `Result<T>` unified response wrapper, `JwtUtil`
  - `config/` — `AppConfig` (BCryptPasswordEncoder bean), `InterceptorConfig` (registers JwtInterceptor), `MyBatisPlusConfig`, `WebMvcConfig`
  - `interceptor/` — `JwtInterceptor` extracts JWT from `Authorization` header
- **Auth flow**: `POST /api/v1/auth/login` → returns JWT token. `JwtInterceptor` protects all `/api/v1/admin/**` paths except `/api/v1/admin/login`
- **Admin API pattern**: CRUD controllers at `/api/v1/admin/{resource}` (e.g., `POST /api/v1/admin/publications`, `PUT /api/v1/admin/publications/{id}`, `DELETE /api/v1/admin/publications/{id}`)
- **Public API pattern**: Read-only GET endpoints at `/api/v1/{resource}` (e.g., `GET /api/v1/publications` with query params for filtering/pagination, `GET /api/v1/research-directions/{id}` for detail)
- **Response format**: `{"code": 200, "message": "...", "data": {}}` via `Result<T>`
- **File uploads**: `FileController` at `/api/v1/admin/files/upload` — images only (validated MIME types), 10MB limit, stored to `./uploads/`, records saved to `file_resource` table
- **DB init**: `schema.sql` creates all tables with `CREATE TABLE IF NOT EXISTS`, seeds default data with `INSERT IGNORE` (admin user bcrypt hash, lab info placeholder, 4 research directions with full descriptions)

### Database Tables

- `user` — admin accounts (username UNIQUE, password_hash bcrypt)
- `lab_info` — single-row lab profile
- `research_direction` — 4 fixed directions with `sort_order`
- `publication` — papers/patents/awards with type/year filtering, `is_representative` flag
- `tool` — research tools with access_url, doc_url, status
- `agent` — 4 AI agents with `integration_type` (link/iframe/api), api_host/port/path for API forwarding, status tracking
- `file_resource` — uploaded file metadata

### Key Routing Detail

The `AgentController` maps public `/agents` to `/api/v1/agents` and admin `/admin/agents` to `/api/v1/admin/agents` (same controller class, `@RequestMapping("/api/v1")` at class level). Other controllers follow the same pattern.

### Agent Integration Boundary

The project handles agent display/card + admin configuration only. Agent internal logic, model training, deployment are out of scope. Integration types: `link` (external URL), `iframe` (embed), `api` (API forwarding — configured via api_host/api_port/api_path fields).
