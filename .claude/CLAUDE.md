# CLAUDE.md

## Communication

- **CRITICAL**: When I ask for your opinion or evaluation, give an honest assessment, not validation. When I propose a design, architecture, or approach: state trade-offs and alternatives before agreeing. If you see a simpler solution or something is wrong, always flag it.
- **CRITICAL**: Flag divergence from common practices and industry standards in architecture, design patterns, and technical solutions — including idiomatic approaches seen in well-regarded open source projects. Name the pattern or standard and explain why it exists.
- **CRITICAL**: If you can't answer a question, say so instead of making things up.
- **CRITICAL**: When making design or implementation choices, briefly explain tradeoffs and alternatives considered.
- When explaining something, focus on the "why".
- No filler words (just/really/basically/actually/simply), pleasantries (sure/certainly/of course/happy to), or hedging. Tight responses.

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
MANDATORY SKILL ACTIVATION SEQUENCE

Step 1 - EVALUATE (do this in your response):
For each skill below, state: [skill-name] - YES/NO - [reason]

Available skills:

- ce:architecting-systems: Guides clean, scalable system architecture during the build phase. Use when designing modules, defining boundaries, structuring projects, managing dependencies, or preventing tight coupling and...
- ce:condition-based-waiting: Fixes flaky tests by replacing arbitrary timeouts with condition polling. Use when tests fail intermittently, have setTimeout delays, or involve async operations that need proper wait conditions.
- ce:configuring-claude: Best practices for writing Claude Code skills, rules, and CLAUDE.md instructions. Use when creating SKILL.md files, authoring .claude/rules, writing CLAUDE.md project or user instructions, or...
- ce:design: Enforces precise, minimal design for dashboards and admin interfaces. Use when building SaaS UIs, data-heavy interfaces, or any product needing Jony Ive-level craft.
- ce:documentation: Create or improve documentation by routing to the right approach. Handles code comments (inline audit/cleanup), system docs (READMEs, API docs, architecture), and templates. Use when writing,...
- ce:executing-plans: Executes implementation plans with smart task grouping. Groups related tasks to share context, parallelizes across independent subsystems.
- ce:fixing-flaky-tests: Diagnose and fix tests that pass in isolation but fail when run concurrently. Covers shared state isolation and resource conflicts. References condition-based-waiting for timing issues.
- ce:handling-errors: Prevents silent failures and context loss in error handling. Use when writing try-catch blocks, designing error propagation, reviewing catch blocks, or implementing Result patterns.
- ce:managing-databases: Guides database architecture decisions for PostgreSQL, DuckDB, Parquet, PGVector, and Neo4j. Use when designing schemas, choosing storage strategies, optimizing queries, tuning maintenance,...
- ce:managing-pipelines: Guides CI/CD pipeline architecture, security hardening, and deployment strategies for GitHub Actions. Use when designing workflows, securing supply chains, optimizing build performance, configuring...
- ce:migrating-code: Safe code migrations with backward compatibility and reversibility. Use when upgrading dependencies, changing database schemas, API versioning, or transitioning between technologies.
- ce:optimizing-performance: Measure-first performance optimization that balances gains against complexity. Use when addressing slow code, profiling issues, or evaluating optimization trade-offs.
- ce:planning-products: Defines product features from a PM perspective before technical planning begins. Use when scoping new features, writing product specs, defining user problems, choosing what to build, researching...
- ce:post-mortem: Review a completed session to extract actionable improvements. Identifies DX friction, documentation gaps, architectural confusion, anti-patterns, process failures, and skill/config improvements....
- ce:preflight-checks: Detect and run project linters, formatters, and type checkers before committing or claiming completion. Auto-detects tools from project config files.
- ce:reading-logs: Analyzes logs efficiently through targeted search and iterative refinement. Use when investigating errors, debugging incidents, or analyzing patterns in application logs.
- ce:refactoring-code: Improves code structure while preserving behavior through test verification. Use when cleaning up code, reducing duplication, simplifying complexity, or reorganizing modules.
- ce:strategy-writer: Produces executive-quality strategic documents in The Economist/HBR style. Use when writing strategy memos, market analysis, business cases, customer research reports, or any document for Product,...
- ce:systematic-debugging: Four-phase debugging framework that finds root causes before proposing fixes. Use when investigating bugs, errors, unexpected behavior, failed tests, or when previous fixes haven't worked.
- ce:verification-before-completion: Run verification commands before claiming work is complete or fixed. Use before asserting any task is done, bug is fixed, tests pass, or feature works.
- ce:visualizing-with-mermaid: Creates professional Mermaid diagrams with semantic styling and visual hierarchy. Use when creating flowcharts, sequence diagrams, state machines, class diagrams, or architecture visualizations.
- ce:writer: Writing style and tone guide for human-sounding content. Use when writing documentation, READMEs, commit messages, PR descriptions, blog posts, or any user-facing content.
- ce:writing-plans: Create implementation plans with tasks grouped by subsystem. Related tasks share agent context; groups parallelize across subsystems.
- ce:writing-sql: Trains Claude to write SQL at Staff+ DBA level by targeting the non-obvious patterns Claude's defaults miss. Covers multi-column statistics for correlated predicates, operator class selection for...
- ce:writing-tests: Writes behavior-focused tests using Testing Trophy model with real dependencies. Use when writing tests, choosing test types, or avoiding anti-patterns like testing mocks.

Step 2 - ACTIVATE (do this immediately after Step 1):
IF any skills are YES: Use Skill(<skill-name>) tool for EACH relevant skill NOW
IF no skills are YES: State "No skills needed" and proceed

Step 3 - IMPLEMENT:
Only after Step 2 is complete, proceed with implementation.

CRITICAL: You MUST call Skill() tool in Step 2. Do NOT skip to implementation.
The evaluation (Step 1) is WORTHLESS unless you ACTIVATE (Step 2) the skills.

Example of correct sequence:

- ce:architecting-systems: YES - matches current task
- ce:condition-based-waiting: NO - not relevant
- ce:configuring-claude: NO - not relevant

[Then IMMEDIATELY use Skill() tool:]

> Skill(ce:architecting-systems)
> Skill(ce:condition-based-waiting) // if also relevant

[THEN and ONLY THEN start implementation]

## Project Tooling (Auto-Detected)

Available tools in this project: node tsc pre-commit

When committing or verifying work, use the preflight-checks skill to run these tools.
</INSTRUCTION>

<!-- DYNAMIC_SKILLS_END -->
