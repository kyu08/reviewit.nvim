local M = {}

M.defaults = {
	-- File list mode: "telescope" or "quickfix"
	file_list_mode = "telescope",
	-- Diff filler character (nil to keep user's default)
	diff_filler_char = nil,
	-- Additional diffopt values applied during review (nil to keep user's default)
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
	keymaps = {
		create_comment = "<leader>Rc",
		view_comments = "<leader>Rv",
		reply_comment = "<leader>Rr",
		next_comment = "]r",
		prev_comment = "[r",
	},
}

M.state = {
	active = false,
	pr_number = nil,
	base_ref = nil,
	head_ref = nil,
	pr_url = nil,
	changed_files = {},
	comments = {},
	comment_map = {},
	preview_win = nil,
	preview_buf = nil,
	source_win = nil,
	augroup = nil,
	ns_id = nil,
	original_diffopt = nil,
}

M.opts = {}

function M.setup(user_opts)
	M.opts = vim.tbl_deep_extend("force", M.defaults, user_opts or {})
	M.state.ns_id = vim.api.nvim_create_namespace("reviewit")
end

function M.reset_state()
	local ns = M.state.ns_id
	M.state = {
		active = false,
		pr_number = nil,
		base_ref = nil,
		head_ref = nil,
		pr_url = nil,
		changed_files = {},
		comments = {},
		comment_map = {},
		preview_win = nil,
		preview_buf = nil,
		source_win = nil,
		augroup = nil,
		ns_id = ns,
		original_diffopt = nil,
	}
end

return M
