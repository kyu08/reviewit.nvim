# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

reviewit.nvim is a Neovim plugin for GitHub PR code review. It shows base branch diffs in a side pane, lets users create/view/reply to review comments with virtual text indicators, browse changed files via Telescope or quickfix, and view PR overviews. Requires Neovim >= 0.10 and GitHub CLI (`gh`).

## Development Tools

- **Formatter**: StyLua — `stylua lua/ plugin/`
  - Config: `.stylua.toml` (tabs, 120 col width, double quotes)
- **Linter**: Luacheck — `luacheck lua/ plugin/`
  - Config: `.luacheckrc` (global `vim`, 120 char lines)
- **Help tags**: `nvim --headless -c "helptags doc/" -c q`
- No test framework is currently configured.

## Architecture

All plugin code lives under `lua/reviewit/`. The plugin entry point is `plugin/reviewit.lua` which registers user commands.

### Module Responsibilities

- **`init.lua`** — Plugin lifecycle (`start`/`stop`/`toggle`). On start: detects PR via `gh`, fetches changed files and comments, sets up `BufEnter`/`WinClosed` autocmds, opens the diff preview, integrates with gitsigns, and applies diffopt settings. On stop: tears everything down and restores original state.
- **`config.lua`** — Holds `defaults`, merged `opts`, and mutable `state` (active flag, PR metadata, window/buffer handles, comments, namespace ID). `reset_state()` preserves the namespace ID.
- **`gh.lua`** — Async wrapper around `gh` CLI using `vim.system()`. All GitHub API calls go through `run()`/`run_json()` with callback-based async pattern. Uses `repos/{owner}/{repo}` path templates (resolved by `gh` automatically).
- **`diff.lua`** — Local git operations (sync). Gets repo root, converts paths to repo-relative, retrieves base branch file content via `git show`, and generates file diffs. Falls back to `origin/<ref>` when local ref isn't available.
- **`preview.lua`** — Manages the side-by-side diff preview window. Creates a scratch buffer with base branch content, opens it in a vsplit, and enables `diffthis` on both windows. Uses `noautocmd` to prevent BufEnter cascades. The `opening` flag guards against re-entrant calls.
- **`comments.lua`** — Fetches PR review comments, builds a `comment_map[path][line]` lookup, and provides navigation (`next_comment`/`prev_comment` with wrap-around), creation (single-line and multi-line range), viewing, and reply functionality.
- **`ui.lua`** — All floating window UI: comment input editor (markdown buffer with `<CR>` submit / `q` cancel), comment viewer, and PR overview window. Manages extmarks (virtual text) for comment indicators on lines.
- **`files.lua`** — Changed files display via Telescope picker (with diff preview) or quickfix list fallback.
- **`overview.lua`** — PR overview display: fetches extended PR info and issue-level comments, renders in a centered float with keymaps for commenting and refreshing.

### Key Patterns

- **Async flow**: GitHub API calls use `vim.system()` callbacks with `vim.schedule()` for safe UI updates.
- **State management**: All mutable state lives in `config.state`. Modules read/write this shared table directly.
- **Namespace**: A single Neovim namespace `"reviewit"` (created in `config.setup()`) is used for all extmarks across the plugin.
- **Window management**: Preview uses `noautocmd` commands to avoid triggering the plugin's own `BufEnter` handler during window operations.
