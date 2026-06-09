# LabWeb Visual Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refresh the LabWeb frontend into a polished modern Chinese research portal.

**Architecture:** Keep the existing Vue single page app and Element Plus components. Concentrate design primitives in global CSS, then update public shell components and high-impact pages.

**Tech Stack:** Vue 3, Vite, Element Plus, Pinia, Axios.

---

### Task 1: Shared Visual Foundation

**Files:**
- Modify: `labweb-frontend/src/assets/styles/global.css`

- [ ] Replace the flat blue theme with CSS variables for text, surfaces, borders, primary colors, shadows, and responsive containers.
- [ ] Redesign `.page-banner`, `.page-content`, `.card-item`, `.tag`, and Element Plus primary variables.
- [ ] Add utility classes for section headings and subtle metadata text.

### Task 2: Public Shell

**Files:**
- Modify: `labweb-frontend/src/components/front/NavBar.vue`
- Modify: `labweb-frontend/src/components/front/Footer.vue`

- [ ] Replace mojibake labels with Chinese labels.
- [ ] Give the navbar a modern translucent white surface, stronger brand block, and responsive wrapping.
- [ ] Give the footer structured Chinese content with research direction links and contact details.

### Task 3: Homepage Refresh

**Files:**
- Modify: `labweb-frontend/src/views/front/Home.vue`

- [ ] Replace the old gradient hero with a content-led research portal hero.
- [ ] Add research metric chips and a visual research panel.
- [ ] Restyle research direction cards, representative publications, and tools/agents quick links.
- [ ] Remove unused functions and repair Chinese fallback copy.

### Task 4: Agents Page Refresh

**Files:**
- Modify: `labweb-frontend/src/views/front/Agents.vue`

- [ ] Replace mojibake labels with Chinese labels.
- [ ] Use a stronger page banner and richer agent cards.
- [ ] Improve status badges, integration labels, empty state text, and action button copy.

### Task 5: Admin Shell Polish

**Files:**
- Modify: `labweb-frontend/src/views/admin/Layout.vue`

- [ ] Replace mojibake labels with Chinese labels.
- [ ] Improve sidebar, header, spacing, and active states while preserving current routes.

### Task 6: Verification

**Commands:**
- `cd labweb-frontend && npm run build`

- [ ] Build the frontend.
- [ ] Fix any syntax or CSS issues surfaced by the build.
- [ ] Summarize changed files and remaining risks.

