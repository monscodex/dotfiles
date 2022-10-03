local nvim_lsp_installer_status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not nvim_lsp_installer_status_ok then
	return
end


-- Capabilities
local client_capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_lsp_status_ok then
  return
end

local capabilities = cmp_nvim_lsp.update_capabilities(client_capabilities)

local function setup()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = true,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  lsp_installer.setup({
    ensure_installed = {"pyright", "arduino_language_server", "bashls", "clangd", "cmake", "cssls", "diagnostics", "gopls", "html", "jsonls", "ltex", "rust_analyzer", "sqlls", "sumneko_lua", "tsserver", "vimls", "yamlls", "remark_ls"},
    automatic_installation = true,
    autostart_servers = true
  })
end

setup()

local utils = require "utils"

local M = {}

function M.setup(servers, options)
  for _, server_name in ipairs(servers) do
    local server_available, server = lsp_installer.servers.get_server(server_name)

    if server_available then
      server:on_ready(function()
        local opts = vim.tbl_deep_extend("force", options, servers[server.name] or {})
        server:setup(opts)
      end)

      if not server:is_installed() then
        utils.info("Installing " .. server.name)
        server:install()
      end
    else
      utils.error(server)
    end
  end
end

return M