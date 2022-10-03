local servers = {
    "pyright",
    "arduino_language_server",
    "bashls",
    "clangd",
    "cmake",
    "cssls",
    "diagnostics",
    "gopls",
    "html",
    "jsonls",
    "ltex",
    "rust_analyzer",
    "sqlls",
    "sumneko_lua",
    "tsserver",
    "vimls",
    "yamlls",
    "remark_ls"
}

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

local function on_attach(client, bufnr)
  -- Enable completion triggered by <C-X><C-O>
  -- See `:help omnifunc` and `:help ins-completion` for more information.
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

  -- Configure key mappings
  require("plugins-config.lsp.keymaps").setup(client, bufnr)

  -- Configure document highlight
  if client.name == "tsserver" then
    client.resolved_capabilities.document_formatting = false
  end
  lsp_highlight_document(client)
end

local opts = {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
}

require("plugins-config.lsp.lsp-installer").setup(servers, opts)

require"plugins-config.lsp.null-ls"