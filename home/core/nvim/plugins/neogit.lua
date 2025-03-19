require("neogit").setup({
	kind = "auto",
	graph_style = "unicode",
	signs = {
		hunk = { "", "" },
		item = { "", "" },
		section = { "", "" },
	},
	commit_editor = {
		kind = "split",
	},
})
