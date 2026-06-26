# CLAUDE.md

## Communication

- **CRITICAL**: If you can't answer a question, say so instead of making things up.
- **CRITICAL**: No filler words (just/really/basically/actually/simply), pleasantries (sure/certainly/of course/happy to), or hedging. Tight responses.
- **IMPORTANT**: When I ask for your opinion or evaluation, give an honest assessment, not validation. When I propose a design, architecture, or approach: state trade-offs and alternatives before agreeing. If you see a simpler solution or something is wrong, always flag it.
- **IMPORTANT**: Flag divergence from common practices and industry standards in architecture, design patterns, and technical solutions — including idiomatic approaches seen in well-regarded open source projects. Name the pattern or standard and explain why it exists.
- **IMPORTANT**: When making design or implementation choices, briefly explain tradeoffs and alternatives considered.
- When explaining something, focus on the "why".

## Code

Before writing or accepting a change, apply these checks:

1. **Does it earn its place?** Remove if callers can use what's underneath directly with no loss of clarity or safety. Wrappers that forward arguments, single-use abstractions, re-exports, and scaffold left from project init all fail this.
2. **Is it in the right place?** A file's location should reflect who uses it, not who wrote it. Grab-bag utils and misplaced helpers are organizational debt.
3. **Does it exist only once?** Consolidate near-duplicates and dead exports. But two similar blocks beat a wrong abstraction — only deduplicate when the shared concept is real.
4. **Is the intent clear?** Named constants over magic values, descriptive conditions, intermediate variables when chains obscure meaning.
5. **Is it conventional?** Default to framework conventions and established patterns before inventing new ones.
6. **Is it ordered top-down?** Within a file, lead with the primary concept, then supporting types and helpers.

### Comments

- Add comments only to explain **why**, not **what**: workarounds, non-obvious business rules, partial-behavior warnings. No per-line comments restating names, no descriptions of obvious structure. File-level headers follow the same rule.
- Don't describe the code's role in wider flows or its history ("used by X", "added for X-123", "for the onboarding flow") — those rot. That context belongs in the PR description. Ticket refs inside TODO/FIXME/HACK markers are fine.
- No banner comments for dividing sections.
- Markers: `NOTE:` (limitation), `TODO:` (planned improvement), `HACK:` (workaround around external behavior), `FIXME:` (bug/broken behavior). Always explain why.

## Testing

- Be sure to verify your changes when you're done by testing, formatting, linting, type-checking, and building.
- Prefer running single tests, and not the whole test suite, for performance.

## Git Workflow

- **CRITICAL**: Atomic commits — EXACTLY one logical change per commit. Do not mix unrelated file changes. ALWAYS commit after completing a change — do not leave the worktree dirty. If you discover a separate issue while working on a fix (e.g. a missing parameter, a wrong comment, a related FIXME), commit your current work first, then address the discovery in its own commit. "Found during the same investigation" is not "same logical change."
- Commit messages: `<type>: <subject>`, e.g. `fix: correct pagination offset`. No scope. Subject in imperative mood. Keep subject and body concise. Body = intent (why), not diff paraphrase (what changed where — already in `git show`).
- Type selection: `fix` = broken behavior fixed. `feat` = new user-facing capability. `refactor` = restructure without behavior change (includes adding implementations behind an existing interface). `test` = test-only changes. `docs` = docs-only. If the change is only tests, the type is `test` — not `fix`. If no user-facing behavior changes, it's `refactor` — not `feat`.

## Writing

Write lean in all artifacts: no excess scope, no excess construction. Cut what shouldn't be there first; compress what remains; check it still decodes. Applies to commits, PR descriptions, comments, docs, tickets — the axis mix shifts per artifact but the principle doesn't.

### PR descriptions

- Two readers: the reviewer (what to check, edge cases, risk) and the future archaeologist (why this shipped, what it replaces).
- Default structure: problem → approach → test plan → risks/rollback. Skip empty sections rather than filling them.
- If the description keeps growing, the PR probably wants to be split.

### Jira tickets

- Required: problem statement, acceptance criteria, scope boundary (what's NOT in this ticket).
- Keep implementation details out of the description — they drift. Put them in sub-tasks or a linked design doc.
- Audience includes non-engineers. Prioritize clarity and specificity over density.

### Notion pages

- State freshness policy up front (snapshot / in-sync / last-reviewed date).
- Open with a TL;DR matched to the likely reader.
- Structure (headings, tables, callouts) beats prose for reference docs.
- Flag assumptions separately from facts — Notion pages get quoted long after writing.

<!-- DYNAMIC_SKILLS_START -->
### Available Skills (Auto-Generated)

<INSTRUCTION>
Load a skill when the task clearly matches its description. Use Skill(<name>) immediately when you recognize a match — don't wait or evaluate all skills first.

Available skills:
- architecting-systems: Guides clean, scalable system architecture during the build phase. Use when designing modules, defining boundaries, structuring projects, managing dependencies, or preventing tight coupling and...
- design: Enforces precise, minimal design for dashboards and admin interfaces. Use when building SaaS UIs, data-heavy interfaces, or any product needing Jony Ive-level craft.
- executing-plans: Executes implementation plans with smart task grouping. Groups related tasks to share context, parallelizes across independent subsystems.
- fixing-flaky-tests: Diagnose and fix tests that pass in isolation but fail when run concurrently. Covers shared state isolation, resource conflicts, and timing-based flakiness.
- handling-errors: Prevents silent failures and context loss in error handling. Use when writing try-catch blocks, designing error propagation, reviewing catch blocks, or implementing Result patterns.
- managing-databases: Guides database architecture decisions for PostgreSQL, DuckDB, Parquet, PGVector, and Neo4j. Use when designing schemas, choosing storage strategies, optimizing queries, tuning maintenance,...
- managing-pipelines: Guides CI/CD pipeline architecture, security hardening, and deployment strategies for GitHub Actions. Use when designing workflows, securing supply chains, optimizing build performance, configuring...
- optimizing-performance: Measure-first performance optimization that balances gains against complexity. Use when addressing slow code, profiling issues, or evaluating optimization trade-offs.
- planning-products: Defines product features from a PM perspective before technical planning begins. Use when scoping new features, writing product specs, defining user problems, choosing what to build, researching...
- post-mortem: Review a completed session to extract actionable improvements. Identifies DX friction, documentation gaps, architectural confusion, anti-patterns, process failures, and skill/config improvements....
- reading-logs: Analyzes logs efficiently through targeted search and iterative refinement. Use when investigating errors, debugging incidents, or analyzing patterns in application logs.
- strategy-writer: Produces executive-quality strategic documents in The Economist/HBR style. Use when writing strategy memos, market analysis, business cases, customer research reports, or any document for Product,...
- structuring-articles: Selects and applies professional journalistic story structures (WSJ Formula, Inverted Pyramid, Hourglass, Tick-Tock, etc.) based on the content being written. Use when writing articles, blog posts,...
- systematic-debugging: Debugging framework that finds root causes before proposing fixes. Use when investigating bugs, errors, unexpected behavior, failed tests, or when previous fixes haven't worked.
- visualizing-with-mermaid: Creates professional Mermaid diagrams with semantic styling and visual hierarchy. Use when creating flowcharts, sequence diagrams, state machines, class diagrams, or architecture visualizations.
- writer: Writing style and tone guide for human-sounding content. Use when writing documentation, READMEs, commit messages, PR descriptions, blog posts, LinkedIn posts, social media content, or any...
- writing-sql: Trains Claude to write SQL at Staff+ DBA level by targeting the non-obvious patterns Claude's defaults miss. Covers multi-column statistics for correlated predicates, operator class selection for...
- writing-tests: Writes behavior-focused tests using Testing Trophy model with real dependencies. Use when writing tests, choosing test types, or avoiding anti-patterns like testing mocks.

</INSTRUCTION>
<!-- DYNAMIC_SKILLS_END -->
