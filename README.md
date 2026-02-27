# reviewit.nvim

PR code review inside Neovim. Review GitHub pull requests without leaving your editor.

## Features

- **Base branch preview** - Side-by-side diff view showing the base branch version
- **Follow code jumps** - Preview updates when navigating to other files via LSP
- **PR comments** - Create, view, and reply to review comments on specific lines
- **Virtual text** - Comment indicators on lines with existing comments
- **Comment navigation** - Jump between comments with `]r` / `[r`
- **Changed files** - Browse PR changed files with Telescope (diff preview) or quickfix
- **PR overview** - View PR title, description, labels, and issue-level comments
- **Gitsigns integration** - Automatically switches gitsigns diff base to PR base branch

## Requirements

- Neovim >= 0.10
- [GitHub CLI](https://cli.github.com/) (`gh`) installed and authenticated
- Optional: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for file picker
- Optional: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) for diff base switching

## Installation

### lazy.nvim

```lua
{
  "flexphere/reviewit.nvim",
  opts = {},
  cmd = {
    "ReviewStart", "ReviewStop", "ReviewToggle",
    "ReviewComment", "ReviewViewComment",
    "ReviewFiles", "ReviewOverview",
  },
  keys = {
    { "<leader>et", "<cmd>ReviewToggle<cr>", desc = "Review: Toggle" },
    { "<leader>es", "<cmd>ReviewStart<cr>", desc = "Review: Start" },
    { "<leader>eq", "<cmd>ReviewStop<cr>", desc = "Review: Stop" },
    { "<leader>ec", "<cmd>ReviewComment<cr>", desc = "Review: Comment", mode = { "n" } },
    { "<leader>ec", ":<C-u>ReviewComment<cr>", desc = "Review: Comment (selection)", mode = { "v" } },
    { "<leader>ev", "<cmd>ReviewViewComment<cr>", desc = "Review: View comments" },
    { "<leader>ef", "<cmd>ReviewFiles<cr>", desc = "Review: Changed files" },
    { "<leader>eo", "<cmd>ReviewOverview<cr>", desc = "Review: PR Overview" },
    {
      "<leader>er",
      function() require("reviewit.comments").reply_to_comment() end,
      desc = "Review: Reply",
    },
    { "]r", function() require("reviewit.comments").next_comment() end, desc = "Review: Next comment" },
    { "[r", function() require("reviewit.comments").prev_comment() end, desc = "Review: Prev comment" },
  },
}
```

## Usage

1. Checkout a PR branch: `gh pr checkout <number>`
2. Start review mode: `:ReviewStart`
3. Open files changed in the PR - a side pane shows the base branch version with diff highlighting
4. Navigate code normally - the preview follows your movements
5. Comment on lines with `:ReviewComment`
6. View existing comments with `:ReviewViewComment`
7. Browse changed files with `:ReviewFiles`
8. View PR overview with `:ReviewOverview`
9. Stop review mode: `:ReviewStop`

## Commands

| Command | Description |
|---------|-------------|
| `:ReviewStart` | Start review mode |
| `:ReviewStop` | Stop review mode |
| `:ReviewToggle` | Toggle review mode |
| `:ReviewComment` | Comment on current line/selection |
| `:ReviewViewComment` | View comments on current line |
| `:ReviewFiles` | List PR changed files (Telescope/quickfix) |
| `:ReviewOverview` | Show PR overview and issue-level comments |

## Configuration

```lua
require("reviewit").setup({
  -- File list mode: "telescope" or "quickfix"
  file_list_mode = "telescope",
  -- Diff filler character (nil to keep user's default)
  diff_filler_char = nil,
  -- Additional diffopt values applied during review
  diffopt = { "algorithm:histogram", "linematch:60", "indent-heuristic" },
  signs = {
    comment = "#",
    comment_hl = "DiagnosticInfo",
  },
  float = {
    border = "single",
    max_width = 80,
    max_height = 20,
  },
  overview = {
    -- Width/height as percentage of screen (1-100)
    width = 80,
    height = 80,
  },
})
```

## License

MIT
