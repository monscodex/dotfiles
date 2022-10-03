local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
---@diagnostic disable-next-line: missing-parameter
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  -- snapshot = "july-24",
  snapshot_path = fn.stdpath "config" .. "/snapshots",
  max_jobs = 50,
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
    prompt_border = "rounded", -- Border style of prompt popups.
  },
}

return packer.startup(function(use)
    -- Compulsory
    use("wbthomason/packer.nvim") -- Have packer manage itself

    -- Lua Development
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
    use "nvim-lua/popup.nvim"
    use "christianchiarulli/lua-dev.nvim"

    -- LSP
    use "neovim/nvim-lspconfig" -- enable LSP
    -- use "williamboman/nvim-lsp-installer" -- simple to use language server installer
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
    use "ray-x/lsp_signature.nvim"
    --[[ use {
        "SmiteshP/nvim-navic",
        config = function ()
            require("plugins-config.navic")
        end
    } ]]
    use {
        "simrat39/symbols-outline.nvim",
        config = function ()
            require("plugins-config.symbols-outline")
        end,

        -- Lazy loading
        opt = true,
        cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    }
    use "b0o/SchemaStore.nvim"
    use "RRethy/vim-illuminate"
    use {
        "j-hui/fidget.nvim",
        config = function ()
            require("fidget").setup()
        end
    }
    use { "lvimuser/lsp-inlayhints.nvim", branch = "readme" }
    use "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
    use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight


    -- Colorschemes
    use("lunarvim/colorschemes")
    use("marko-cerovac/material.nvim")
    use("folke/tokyonight.nvim")
    use("morhetz/gruvbox")
    use("joshdick/onedark.vim")
    use("mhartington/oceanic-next")

	-- Completion
	use{
		"christianchiarulli/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-cmdline", -- cmdline completions
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			-- "lukas-reineke/cmp-rg", -- regex completion (nice)
			"hrsh7th/cmp-nvim-lsp", -- For lsp
			"hrsh7th/cmp-emoji", -- emoji
			"hrsh7th/cmp-nvim-lua",
			"ray-x/cmp-treesitter",
            -- "petertriho/cmp-git",
            {
                "KadoBOT/cmp-plugins",
                config = function ()
                    require("cmp-plugins").setup({
                          -- files = { ".*\\.lua" }  -- default
                          files = { "plugins.lua" } -- Recommended: use static filenames or partial paths
                    })
                end
            }
		}
	}

    -- snippets
    use{
        "L3MON4D3/LuaSnip",
        requires = {
            "rafamadriz/friendly-snippets"
        }
    }

    -- Marks
    -- use "christianchiarulli/harpoon"
    --[[ use {
        "MattesGroeger/vim-bookmarks",
        config = function ()
            local home = os.getenv "HOME"
            local icons = require "general.icons"

            vim.g.bookmark_sign = icons.ui.BookMark
            vim.g.bookmark_annotation_sign = icons.ui.Comment
            vim.g.bookmark_no_default_key_mappings = 0
            vim.g.bookmark_auto_save = 1
            vim.g.bookmark_auto_close = 0
            vim.g.bookmark_manage_per_buffer = 0
            vim.g.bookmark_save_per_working_dir = 0
            vim.g.bookmark_highlight_lines = 1
            vim.g.bookmark_show_warning = 1
            vim.g.bookmark_center = 0
            vim.g.bookmark_location_list = 0
            vim.g.bookmark_disable_ctrlp = 1
            vim.g.bookmark_display_annotation = 1
            vim.g.bookmark_auto_save_file = home .. "/.config/nvim/bookmarks"
        end
    } ]]

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        config = function ()
            require("plugins-config.telescope")
        end,

        -- Lazy loading
        opt = true,
        cmd = { "Telescope" },
    }
    use "nvim-telescope/telescope-media-files.nvim"
    -- use "hoangpq/telescope-vim-bookmarks.nvim"

    -- Syntax/Treesitter
    use {
    "nvim-treesitter/nvim-treesitter",
    config = function ()
        require("plugins-config.treesitter")
    end
}
    use {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function ()
            require'nvim-treesitter.configs'.setup {
              context_commentstring = {
                enable = true
              }
            }
        end
    }
    use "p00f/nvim-ts-rainbow"
    use {
        "nvim-treesitter/playground",

        -- Lazy loading
        opt = true,
        cmd = { "TSPlaygroundToggle" },
    }
    use "windwp/nvim-ts-autotag"
    use "nvim-treesitter/nvim-treesitter-textobjects"
    -- use "wellle/targets.vim"
    -- use "RRethy/nvim-treesitter-textsubjects"
    use {
        "kylechui/nvim-surround",
        config = function ()
            require("plugins-config.surround")
        end
    }
    --[[ use {
        "abecodes/tabout.nvim",
        config = function ()
            require("plugins-config.tabout")
        end
        wants = { "nvim-treesitter" }, -- or require if not used so far
    } ]]


    -- Utility
    use {
        "rcarriga/nvim-notify",
        config = function ()
            require("plugins-config.notify")
        end
    }
    use {
        "stevearc/dressing.nvim",
        config = function ()
            require("plugins-config.dressing")
        end
    }
    use "ghillb/cybu.nvim"
    use {
        "moll/vim-bbye",

        -- Lazy loading
        opt = true,
        cmd = { "Bdelete", "Bwipeout" },
    }
    use {
        "lewis6991/impatient.nvim",
        config = function ()
            require("impatient").enable_profile()
        end
    }

    -- Color
    use {
        "NvChad/nvim-colorizer.lua",
        config = function ()
            local colorizer = require("colorizer")
            colorizer.setup({ "*" }, {
              RGB = true, -- #RGB hex codes
              RRGGBB = true, -- #RRGGBB hex codes
              names = true, -- "Name" codes like Blue or blue #999fa2
              RRGGBBAA = true, -- #RRGGBBAA hex codes
              rgb_fn = true, -- CSS rgb() and rgba() functions
              hsl_fn = true, -- CSS hsl() and hsla() functions
              css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
              css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
              -- Available modes: foreground, background, virtualtext
              mode = "background", -- Set the display mode.)
            })
        end
    }
    use {
        "ziontee113/color-picker.nvim",
        config = function ()
            require("color-picker")
        end,

        -- Lazy loading
        opt = true,
        cmd = { "PickColor", "PickColorInsert" },
    }

    -- Icon
    use {
        "kyazdani42/nvim-web-devicons",
        config = function ()
            require("plugins-config.nvim-webdev-icons")
        end
    }

    use {
        "ziontee113/icon-picker.nvim",
        commit = "cbd05c1e25e0ba501aac7e6ffb20435dbc1cea41",
        config = function()
            require("icon-picker")
        end,

        -- Lazy loading
        opt = true,
        cmd = { "PickEverything", "PickEmoji", "PickIcons", "PickNerd", "PickSymbold", "PickAltFont" },
    }


    -- Statusline
    use {
        "christianchiarulli/lualine.nvim",
        config = function ()
            require("plugins-config.lualine")
        end
    }

    -- Startup
    --[[ use {
        "goolord/alpha-nvim",
        config = function ()
            require("plugins-config.alpha")
        end
    } ]]

    -- Indent
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function ()
            require("plugins-config.indentline")
        end
    }

    -- File Explorer
    use {
        "kyazdani42/nvim-tree.lua",
        config = function ()
            require("plugins-config.nvim-tree")
        end,

        -- Lazy loading
        opt = true,
        cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFocus" },
    }


    -- Terminal
    use {
        "akinsho/toggleterm.nvim",
        config = function ()
            require("plugins-config.toggleterm")
        end,

        -- Lazy loading
        opt = true,
        cmd = { "ToggleTerm" },
    }

    -- Project
    use {
        "ahmedkhalf/project.nvim",
        config = function ()
            require("plugins-config.project")
        end
    }
    --[[ use {
        "windwp/nvim-spectre",
        config = function ()
            require("plugins-config.spectre")
        end
    } ]]

    -- Session
    use {
        "rmagatti/auto-session",
        config = function ()
            require("plugins-config.auto-session")
        end
    }
    use {
        "rmagatti/session-lens",

        -- Lazy loading
        opt = true,
        module = "session-lens"
    }

    -- Quickfix
    use "kevinhwang91/nvim-bqf"

    -- Undotree
    use {
        "mbbill/undotree",

        -- Lazy loading
        opt = true,
        cmd = { "UndotreeToggle", "UndotreeShow", "UndotreeHide", "UndotreeFocus" }
    }

    -- Code Runner
    -- use "is0n/jaq-nvim"

    -- Git
    use {
    "lewis6991/gitsigns.nvim",
    config = function ()
        require("plugins-config.gitsigns")
    end
}
    use {
        "f-person/git-blame.nvim",
        config = function ()
            vim.g.gitblame_date_format = "%d/%m/%y-%H"
            vim.g.gitblame_message_template = '   "<summary>"__<date>__"<author>"'
            vim.g.gitblame_highlight_group = "Operator"
        end
    }
    -- use "ruifm/gitlinker.nvim"
    use {
        "mattn/vim-gist",
        config = function ()
            vim.g.gist_open_browser_after_post = 1
        end,

        -- Lazy loading
        opt = true,
        cmd = { "Gist" }
    }

    -- Github
    use {
      'pwntester/octo.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function ()
        require"octo".setup()
      end,

        -- Lazy loading
        opt = true,
        cmd = { "Octo" }
    }


    -- Editing Support
    use {
        "windwp/nvim-autopairs",
        config = function ()
            require("plugins-config.autopairs")
        end
    }
    -- use "monaqa/dial.nvim"
    use {
        "nacro90/numb.nvim",
        config = function ()
            require("numb").setup({
                show_numbers = true, -- Enable 'number' for the window while peeking
                show_cursorline = true, -- Enable 'cursorline' for the window while peeking
            })
        end
    }
    use {
        "andymass/vim-matchup",
        config = function ()
        -- vim.g.matchup_enabled = 0
        vim.g.matchup_matchparen_offscreen = { method = nil }
        vim.g.matchup_matchpref = { html = { nolists = 1 } }
        end
    }
    -- use "folke/zen-mode.nvim"
    --[[ use {
        "karb94/neoscroll.nvim",
        config = function ()
            require("neoscroll").setup {
              -- All these keys will be mapped to their corresponding default scrolling animation
              mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
              hide_cursor = false,
              stop_eof = true, -- Stop at <EOF> when scrolling downwards
              use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
              respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
              cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
              easing_function = nil, -- Default easing function
              pre_hook = nil, -- Function to run before the scrolling animation starts
              post_hook = nil, -- Function to run after the scrolling animation ends
            }
        end
    } ]]

    -- Motion
    use {
        "christianchiarulli/hop.nvim",
        config = function ()
            require("hop").setup()

            local opts = { noremap = true, silent = true }
            local keymap = vim.api.nvim_set_keymap

            keymap('', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", opts)
            keymap('', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", opts)
            keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", opts)
            keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", opts)
        end,
    }
    -- use "jinh0/eyeliner.nvim"

    -- Keybinding
    use {
        "folke/which-key.nvim",
        config = function ()
            require("plugins-config.whichkey")
        end
    }


    -- Commenting
    use({
        "numToStr/Comment.nvim",
        config = function ()
            require("plugins-config.comments")
        end,

        -- Lazy loading
        opt = true,
        module = "Comment",
    })
    use "folke/todo-comments.nvim"

    -- Bufferline
    use({
        "akinsho/bufferline.nvim",
        config = function ()
            require("plugins-config.bufferline")
        end
    })

	-- Markdown preview
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
            vim.g.mkdp_browser = "brave-browser"
            vim.g.mkdp_auto_start = 1
		end,

        -- Lazy loading
        opt = true,
		ft = { "markdown" },
	})

	-- Highlighted yank
	use("machakann/vim-highlightedyank")

    -- Rust
    -- use { "christianchiarulli/rust-tools.nvim", branch = "modularize_and_inlay_rewrite" }
    use {
        "Saecki/crates.nvim",
        config = function ()
            require("plugins-config.crates")
        end
    }


	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
