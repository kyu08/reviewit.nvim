if vim.g.loaded_reviewit then
	return
end
vim.g.loaded_reviewit = true

vim.api.nvim_create_user_command("ReviewStart", function()
	require("reviewit").start()
end, { desc = "Start PR review mode" })

vim.api.nvim_create_user_command("ReviewStop", function()
	require("reviewit").stop()
end, { desc = "Stop PR review mode" })

vim.api.nvim_create_user_command("ReviewToggle", function()
	require("reviewit").toggle()
end, { desc = "Toggle PR review mode" })

vim.api.nvim_create_user_command("ReviewComment", function(opts)
	require("reviewit.comments").create_comment(opts.range > 0)
end, { desc = "Create PR review comment", range = true })

vim.api.nvim_create_user_command("ReviewViewComment", function()
	require("reviewit.comments").view_comments()
end, { desc = "View PR review comments on current line" })

vim.api.nvim_create_user_command("ReviewFiles", function()
	require("reviewit.files").show()
end, { desc = "List PR changed files" })

vim.api.nvim_create_user_command("ReviewOverview", function()
	require("reviewit.overview").show()
end, { desc = "Show PR overview" })
