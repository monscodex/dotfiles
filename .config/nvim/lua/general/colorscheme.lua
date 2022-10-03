-- Supported:
-- tokyonight,,
-- OceanicNext,
-- material,
-- aurora
-- nord,
-- gruvbox,
-- onedark,
-- onedarker,
-- darkplus,
-- tomorrow,
-- spacedark
local colorscheme = "tokyonight"

if colorscheme == "tokyonight" then
	vim.g.tokyonight_style = "night"
	vim.g.tokyonight_italic_functions = true
	vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
elseif colorscheme == "OceanicNext" then
	vim.g.oceanic_next_terminal_bold = true
vim.g.oceanic_next_terminal_italic = true
elseif colorscheme == "material" then
	-- darker, lighter, oceanic, palenight, deep ocean
	vim.g.material_terminal_italics = 1
	vim.g.material_style = "deep ocean"
elseif colorscheme == "onedark" then
    vim.g.onedark_termcolors = 256
    vim.g.onedarker_italic_keywords = true
    vim.g.onedarker_italic_functions = false
    vim.g.onedarker_italic_comments = true
    vim.g.onedarker_italic_loops = true
    vim.g.onedarker_italic_conditionals = true
elseif colorscheme == "gruvbox" then
	vim.g.gruvbox_contrast_dark = "hard"
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

-- Comments MATTTER!! make them red!!
vim.cmd [[ hi Comment guifg=#ff5e7e]]


