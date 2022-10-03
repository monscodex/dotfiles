local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

local compare = require "cmp.config.compare"

require("luasnip/loaders/from_vscode").lazy_load()

-- local check_backspace = function()
  -- local col = vim.fn.col "." - 1
  -- return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
-- end

local kind_icons = require("general.icons").kind

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<tab>"] = cmp.mapping.confirm { select = true },
    -- ["<CR>"] = cmp.mapping(function(fallback)
      -- if cmp.visible() then
          -- cmp.mapping.confirm()
      -- elseif luasnip.expandable() then
        -- luasnip.expand()
      -- elseif luasnip.expand_or_jumpable() then
        -- luasnip.expand_or_jump()
      -- else
        -- fallback()
      -- end
    -- end, {
      -- "i",
      -- "s",
    -- }),
    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
      -- if cmp.visible() then
        -- cmp.select_prev_item()
      -- elseif luasnip.jumpable(-1) then
        -- luasnip.jump(-1)
      -- else
        -- fallback()
      -- end
    -- end, {
      -- "i",
      -- "s",
    -- }),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        nvim_lsp = "LSP",
        nvim_lua = "NLua",
        luasnip = "Snip",
        rg = "Rg",
        npm = "npm",
        buffer = "Buf",
        path = "/",
        plugins = "Plug",
        emoji = ":)",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "crates", group_index = 1 },
    -- { name = "nvim_lsp", group_index = 2 },
    {
      name = "nvim_lsp",
      filter = function(entry, ctx)
        -- vim.pretty_print()
        local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
        -- vim.bo.filetype
        if kind == "Snippet" and ctx.prev_context.filetype == "java" then
          return true
        end
      end,
      group_index = 2,
    },
    { name = "nvim_lua", group_index = 2 },
    { name = "luasnip", group_index = 2 },
    { name = "treesitter", group_index = 2 },
    { name = "buffer", group_index = 2 },
    { name = "path", group_index = 2 },
    { name = 'rg', group_index = 2 },
    { name = 'plugins', group_index = 2 },
    { name = 'emoji', group_index = 2 },
    { name = "lab.quick_data", keyword_length = 4 },
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      -- require("copilot_cmp.comparators").prioritize,
      -- require("copilot_cmp.comparators").score,
      compare.offset,
      compare.exact,
      -- compare.scopes,
      compare.score,
      compare.recently_used,
      compare.locality,
      -- compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
      -- require("copilot_cmp.comparators").prioritize,
      -- require("copilot_cmp.comparators").score,
     }
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    completion = {
      border = "rounded",
      winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
    },
  },
  experimental = {
    ghost_text = true,
  },
}
