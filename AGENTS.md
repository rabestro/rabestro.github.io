# AGENTS.md

Branch naming rules and agent guidance for the Blog repository.

## Branch Naming Conventions

Allowed branch prefixes:

- `post` — new blog posts
- `fix` — fixes for existing content or links
- `feat` — new site features or theme adjustments
- `task` — maintenance tasks (updates, configuration)

Branch name pattern (required):
(post|fix|feat|task)/<short-description>
Example: `post/magic-bitboards-explanation`

## Agent Rules (AI Assistance)

- Do not implement changes directly in `main` unless explicitly requested for minor fixes.
- Always create a dedicated branch for each task.
- Agents must run `mise run check` to ensure all links and math rendering are correct before proposing a merge.
- Human retains the ultimate authority to review and merge the PR.

## Developer Workflows

- **Core Runner**: Use `mise run <task>` for all development activities.
- **Local Preview**: `mise run dev` spins up the Jekyll server at `http://localhost:4000`.
- **Validation**: `mise run check` runs HTML-Proofer to verify all internal links and site structure.
- **Cleanup**: `mise run clean` removes build artifacts and caches.
- **Updates**: `mise run update` keeps the theme and dependencies up to date.

## Workflow

1. Create a branch: `git checkout -b post/my-new-article`.
2. Write content and preview locally using `mise run dev`.
3. Verify integrity with `mise run check`.
4. Create a Pull Request and wait for CI results.
