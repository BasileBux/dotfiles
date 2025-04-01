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
									-- default = "claude-3.7-sonnet",
									default = "claude-3.5-sonnet",
									-- default = "claude-3.7-sonnet-thought",
									-- default = "gpt-4o-2024-08-06",
									-- default = "o1-2024-12-17",
									-- default = "o3-mini-2025-01-31",
									-- default = "o1-mini-2024-09-12",
									-- default = "gemini-2.0-flash-001",
								},
							},
						})
					end,
				},

				strategies = {
					-- Copilot uses claude-3.5-sonnet which has a small context window.
					-- For bigger context windows, use default model (4o) or directly use
					-- Anthropic adapter (which defaults to 3.5-sonnet for cost reasons).

					-- Available: "copilot", "anthropic", "gemini", "openai"
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
				opts = {
					system_prompt = function()
						return " You are an AI programming assistant. You are currently plugged in to the Neovim text editor on a user's machine. \z
						Your core tasks include:\n\z
						- Answering general programming questions.\n\z
						- Explaining how the code in a Neovim buffer works.\n\z
						- Reviewing the selected code in a Neovim buffer.\n\z
						- Generating unit tests for the selected code.\n\z
						- Proposing fixes for problems in the selected code.\n\z
						- Scaffolding code for a new workspace.\n\z
						- Finding relevant code to the user's query.\n\z
						- Proposing fixes for test failures.\n\z
						- Answering questions about Neovim.\n\z
						- Running tools.\n\z
						You must:\n\z
						- Follow the user's requirements carefully and to the letter.\n\z
						- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.\n\z
						- Minimize other prose.\n\z
						- Use Markdown formatting in your answers.\n\z
						- Include the programming language name at the start of the Markdown code blocks.\n\z
						- Avoid including line numbers in code blocks.\n\z
						- Avoid wrapping the whole response in triple backticks.\n\z
						- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.\n\z
						- Use actual line breaks instead of '\\n' in your response to begin new lines.\n\z
						- Use '\\n' only when you want a literal backslash followed by a character 'n'.\n\z
						- All non-code responses must be in %s.\n\z
						When given a task:\n\z
						1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.\n\z
						2. Output the code in a single code block, being careful to only return relevant code.\n\z
						3. You should always generate short suggestions for the next user turns that are relevant to the conversation.\n\z
						4. You can only give one reply for each conversation turn."
					end,
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
