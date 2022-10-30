local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- [[ C/C++ ]]

local clangd_cmd = {
  "clangd",
  "--header-insertion=never",
  "--background-index",
  "--clang-tidy",
  "-j=4",
  "--inlay-hints"
}

if Work then
  clangd_cmd = {
    "clangd",
    "--header-insertion=never",
    "--background-index",
    "--clang-tidy",
    "-j=16",
    "--compile-commands-dir=~/workspace",
    "--background-index-priority=normal",
  }
end

require("clangd_extensions").setup {
  server = {
    cmd = clangd_cmd,
    filetypes = { "c", "cpp" },
    capabilities = capabilities,
    root_dir = require("lspconfig").util.root_pattern(".root")
  },
  inlay_hints = {
    right_align = true
  }
}

-- [[ rust ]]

require("rust-tools").setup {
  server = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        },
      }
    },
    capabilities = capabilities,
  },
  tools = {
    autoSetHints = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
}

-- [[ lua ]]

require("lspconfig").sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- [[ python ]]

require("lspconfig").pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { 'W391' },
          maxLineLength = 100
        }
      }
    }
  }
}
