local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

--[[ local status_ok, git_blame = pcall(require, "gitblame")
if not status_ok then
	return
end ]]

local icons = require("general.icons")

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " " },
	colored = true,
	update_in_insert = true,
	always_visible = true,
}

local diff = {
	"diff",
	symbols = {
        added = icons.git.Add .. " ",
        modified = icons.git.Mod .. " ",
        removed = icons.git.Remove .. " ",
    },
	colored = true,
}

local mode = {
	"mode",
	-- fmt = function(str)
		-- return "-- " .. str .. " --"
	-- end,
}

local filetype = {
	"filetype",
	icons_enabled = true,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = icons.git.Branch,
}

local location = {
	"location",
	padding = 1,
}

local encoding = {
	"encoding",
}

--[[ -- cool function for progress but I prefer %
local block_progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")

	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }

	local line_ratio = current_line / total_lines

	local index = math.ceil(line_ratio * #chars)

	return chars[index]
end ]]

local progress = {
  "progress",
  fmt = function(_)
    return "%P/%L"
  end
}

local filename = {
	"filename",
	file_status = true,
	path = 1,
	symbols = { modified = " " .. icons.documents.Mod, readonly = " " .. icons.documents.ReadOnly, },
}

--[[ local git_blame_feature = {
    git_blame.get_current_blame_text,
    cond = git_blame.is_blame_text_available
} ]]

lualine.setup({
	options = {
        theme = 'ayu_mirage',
		icons_enabled = true,
		disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { filename },
		lualine_c = { branch, diff },
		lualine_x = { diagnostics },
		lualine_y = { filetype, encoding, },
		lualine_z = { location, progress },
	},
})
