---
description: Feature Development Workflow
---

This workflow is used when starting work on a new feature.

1.  **Understand Requirements**: Ask questions if something needs to be clarified.
2.  **Create Plan**: As a Senior Engineer, draft an `implementation_plan.md`. Do not just list files to change. Provide a high-level architectural rationale, discuss potential trade-offs, identify edge cases, and propose a robust testing strategy along with the architecture and UI updates. Add to plans list of AI agent skills you plan to use. Mention if there are any skills not defined in the project but would be good to use.
3.  **Wait for Plan Approval**: Request a review of the `implementation_plan.md` and wait for explicit user approval before proceeding to code.
4.  **Implementation**: Once the plan is approved, implement the feature code, following project rules and guidelines in `.agents/rules/`.
5.  **Pre-compile Checks**: After the explicit code implementation is done, run the `/pre-compile-check` workflow to run linter, tests, and build runner to verify everything is green before concluding the feature explicitly.