return {
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "folke/which-key.nvim" },
    ft = "java",
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    --ft = "go",
    opts = function()
      return require "configs.null-ls"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      -- LSP Management
      -- https://github.com/williamboman/mason.nvim
      { "williamboman/mason.nvim" },
      -- https://github.com/williamboman/mason-lspconfig.nvim
      { "williamboman/mason-lspconfig.nvim" },

      -- Auto-Install LSPs, linters, formatters, debuggers
      -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },

      -- Useful status updates for LSP
      -- https://github.com/j-hui/fidget.nvim
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      require "configs.lspconfig"
      require("mason").setup()
      require("mason-lspconfig").setup {
        -- Install these LSPs automatically
        ensure_installed = {
          "gradle_ls",
          "jdtls",
        },
      }

      require("mason-tool-installer").setup {
        -- Install these linters, formatters, debuggers automatically
        ensure_installed = {
          "java-debug-adapter",
          "java-test",
        },
      }
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        enable = true,
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      --require("lazy").load { plugins = "dap_go" }
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      --require("lazy").load { plugins = "dap_python" }
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "configs.mason"
    end,
  },
  {
    --Debugger configuration for c++ using clldb
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      --"typescript",
      "typescriptreact",
      "html",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      opts = require "configs.treesitter"
      require("nvim-treesitter.install").compilers = { "clang" }
      opts.ensure_installed = {
        "html",
        "lua",
        "typescript",
        "go",
        "javascript",
        "java",
      }
    end,
  },
  --[[{
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = false,
          auto_trigger = false,
        },
        filetypes = {
          gitcommit = true,
          markdown = true,
        },
      }
    end,
  },--]]
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      -- your config goes here
      -- or just leave it empty :)
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = true,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      --require("lazy").load { plugins = "gopher" }
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  { "nvim-neotest/nvim-nio" },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
}
