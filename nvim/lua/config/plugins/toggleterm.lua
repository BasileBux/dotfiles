return {
	{
		"akinsho/toggleterm.nvim",
		config = true,

		-- toggle custom commands
		vim.api.nvim_create_user_command("Ft", function()
			vim.cmd("ToggleTerm direction=float")
		end, {}),
		vim.api.nvim_create_user_command("Vt", function()
			vim.cmd("ToggleTerm direction=vertical size=80")
		end, {}),
	},
}
