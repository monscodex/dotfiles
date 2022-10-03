local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "center", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    v = { ":vsplit<space>", "vsplit", silent=false },
    s = { ":split<space>", "split", silent=false },
    w = { "<cmd>w<cr>", "Write" },
    q = { "<cmd>conf q<cr>", "Quit" },
    Q = { "<cmd>Bdelete!<CR>", "Close Buffer" },
    u = { "<cmd>UndotreeToggle<cr>", "Undotree"},

	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},

      g = {
        name = "Git",
        g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
        j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
        k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
        l = { "<cmd>GitBlameToggle<cr>", "Blame" },
        p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
        r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
        R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
        s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
        u = {
          "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
          "Undo Stage Hunk",
        },
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        d = {
          "<cmd>Gitsigns diffthis HEAD<cr>",
          "Diff",
        },
        G = {
          name = "Gist",
          a = { "<cmd>Gist -b -a<cr>", "Create Anon" },
          d = { "<cmd>Gist -d<cr>", "Delete" },
          f = { "<cmd>Gist -f<cr>", "Fork" },
          g = { "<cmd>Gist -b<cr>", "Create" },
          l = { "<cmd>Gist -l<cr>", "List" },
          p = { "<cmd>Gist -b -p<cr>", "Create Private" },
        },
      },

    --[[ b = {
        name = "Bookmarks",
        t = { "<cmd>BookmarkToggle<cr>", "Toggle" },
        a = { "<cmd>BookmarkAnnotate<cr>", "Annotate" },
        j = { "<cmd>BookmarkNext<cr>", "Next" },
        k = { "<cmd>BookmarkPrev<cr>", "Previous" },
        s = { "<cmd>BookmarkShowAll<cr>", "Show" },
        f = {
            name = "Find",
            c = {"<cmd>Telescope vim_boookmarks current_file<cr>", "Current Buffer"},
            a = {"<cmd>Telescope vim_boookmarks all<cr>", "All"},
        },
        d = {
            name = "Delete",
            c = { "<cmd>BookmarkClear<cr>", "Current Buffer" },
            a = { "<cmd>BookmarkClearAll<cr>", "ALL" },
        },
    }, ]]

	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        c = { "<cmd>lua require('plugins-config.lsp').server_capabilities()<cr>", "Get Capabilities" },
		d = {
			"<cmd>Telescope diagnostics bufnr=0<cr>",
			"Document Diagnostics",
		},
		D = {
			"<cmd>lua vim.lsp.buf.definition()<cr>",
			"Definition",
		},
        f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
        F = { "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
		i = { "<cmd>LspInfo<cr>", "LSP Info" },
		-- I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
        h = { "<cmd>IlluminationToggle<cr>", "Toggle Doc HL" },
		j = {
			"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
			"Next Diagnostic",
		},
		k = {
			"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
			"Prev Diagnostic",
		},
        v = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Virtual Text" },
        m = { "<cmd>SymbolsOutline<cr>", "Map" },
		q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Workspace Symbols",
		},
        t = { '<cmd>lua require("general.functions").toggle_diagnostics()<cr>', "Toggle Diagnostics" },
	},

	f = {
		name = "Find",
		f = { "<cmd>Telescope find_files<cr>", "FILES" },
		s = { "<cmd>Telescope session-lens search_session<cr>", "Sessions" },
		g = { "<cmd>Telescope live_grep<cr>", "GREP" },
		p = { "<cmd>Telescope projects<cr>", "PROJECTS" },
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
		B = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        -- H = { "<cmd>Telescope highlights<cr>", "Highlights" },
        H = {
            name = "History",
            c = { "<cmd>Telescope command_history<cr>", "Commands" },
            s = { "<cmd>Telescope search_history<cr>", "Search" },
            n = { "<cmd>Telescope notify<cr>", "Notifications" },
        },
		m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		M = { "<cmd>Telescope media_files<cr>", "Media Files" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        c = { "<cmd>Telescope commands<cr>", "List" },
		C = { "<cmd>Telescope colorscheme<cr>", "Colorschemes" },
		t = { "<cmd>Telescope builtin<cr>", "Telescope Commands" },
        i = {
            name = "Icons",
            E = { "<cmd>PickEverything<cr>", "Everything" },
            e = { "<cmd>PickEmoji<cr>", "Emoji" },
            i = { "<cmd>PickIcons<cr>", "Icons" },
            n = { "<cmd>PickNerd<cr>", "Nerd" },
            s = { "<cmd>PickSymbols<cr>", "Symbols" },
            a = { "<cmd>PickAltFont<cr>", "Alt characters" },
        },
        l = {
            name = "LSP",
            d = { "<cmd>Telescope lsp_definitions<cr>", "Definitions" },
            D = { "<cmd>Telescope lsp_declarations<cr>", "Declarations" },
            i = { "<cmd>Telescope lsp_implementations<cr>", "Implamentations" },
            r = { "<cmd>Telescope lssp_references<cr>", "References" },
        }
	},

    o = {
        name = "Options",
        w = { '<cmd>lua require("general.functions").toggle_option("wrap")<cr>', "Wrap" },
        r = { '<cmd>lua require("general.functions").toggle_option("relativenumber")<cr>', "Relative" },
        l = { '<cmd>lua require("general.functions").toggle_option("cursorline")<cr>', "Cursorline" },
        s = { '<cmd>lua require("general.functions").toggle_option("spell")<cr>', "Spell" },
        t = { '<cmd>lua require("general.functions").toggle_tabline()<cr>', "Tabline" },
    },

    S = {
        name = "Session",
        s = { "<cmd>SaveSession<cr>", "Save" },
        r = { "<cmd>RestoreSession<cr>", "Restore" },
        x = { "<cmd>DeleteSession<cr>", "Delete" },
        f = { "<cmd>Autosession search<cr>", "Find" },
        d = { "<cmd>Autosession delete<cr>", "Find Delete" },
        -- a = { ":SaveSession<cr>", "test" },
        -- a = { ":RestoreSession<cr>", "test" },
        -- a = { ":RestoreSessionFromFile<cr>", "test" },
        -- a = { ":DeleteSession<cr>", "test" },
    },

    --[[ d = {
        name = "Debug",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
        o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
        O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
        r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
        l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
        u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
        x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
    }, ]]

	c = {
		name = "Comment",
		i = { '<cmd>lua require("Comment.api").toggle_current_linewise()<cr>', "Individual" },
		c = { '<cmd>lua require("Comment.api").toggle_current_blockwise()<cr>', "Block" },
	},

    C = { "<cmd>PickColor<cr>", "Color-Picker"},

	h = {
		name = "Hop",

        -- Optional : do not overcharge your indexes !!
		u = { "<cmd>HopLineBC<cr>", "Line Up" },
		j = { "<cmd>HopLineAC<cr>", "Line Up" },

		k = { "<cmd>HopLineBC<cr>", "Line Down" },
		d = { "<cmd>HopLineAC<cr>", "Line Down" },

		p = { "<cmd>HopPattern<cr>", "Pattern" },
        w = { "<cmd>HopWord<cr>", "Word" },

        f = { "<cmd>HopChar2<cr>", "Find" },
	},

    t = {
        name = "Terminal",
        v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical" },
        s = { "<cmd>ToggleTerm direction=horizontal size=15<cr>", "Horizontal" },
    },

    T = {
        name = "Treesitter",
        h = { "<cmd>TSHighlightCapturesUnderCursor<cr>", "Highlight" },
        p = { "<cmd>TSPlaygroundToggle<cr>", "Playground" },
        r = { "<cmd>TSToggle rainbow<cr>", "Rainbow" },
    },
}

local vopts = {
  mode = "v", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local vmappings = {
    c = {
      name = "Comment",
      i = { '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Inline" },
      c = { '<ESC><CMD>lua require("Comment.api").toggle_blockwise_op(vim.fn.visualmode())<CR>', "Block" }
    }
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
