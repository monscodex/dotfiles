-- General config
require("general.options")
require("general.keymaps")
require("general.plugins") -- Each plugin's config is going to be called when loading the plugin individually
require("general.autocommands")
require("general.colorscheme")

-- LSP setup
require("plugins-config.cmp")
require "plugins-config.lsp"
require("plugins-config.lsp-inlayhints")

-- Remaining
require("plugins-config.winbar")
