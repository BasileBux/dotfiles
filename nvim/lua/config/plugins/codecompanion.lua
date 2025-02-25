return {
	{
		"olimorris/codecompanion.nvim",
		config = function()
			require("codecompanion").setup({
				-- Owned: gemini, anthropic, copilot
				adapters = {
					anthropic = function()
						return require("codecompanion.adapters").extend("anthropic", {
							name = "anthropic_cheaper",
							schema = {
								model = {
									default = "claude-3-5-sonnet-20241022",
								},
							},
						})
					end,

					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							name = "copilot",
							schema = {
								model = {
									default = "claude-3.5-sonnet",
								},
							},
						})
					end,
				},

				strategies = {
					-- Copilot uses claude-3.5-sonnet which has a small context window.
					-- For bigger context windows, use default model (4o) or directly use
					-- Anthropic adapter (which defaults to 3.5-sonnet for cost reasons).
					chat = {
						adapter = "copilot",
					},
					inline = {
						adapter = "copilot",
					},
				},
				display = {
					chat = {
						show_settings = false, -- Set to true to show settings in chat
					},
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
