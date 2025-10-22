local plugins = {
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }
      dap.configurations.cpp = {
        {
          name = "Attach",
          type = "gdb",
          request = "attach",
          pid = function()
            return tonumber(vim.fn.input "Attach to pid: ")
          end,
          stopAtBeginningOfMainSubprogram = false,
        },
      }
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
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "nvim-neotest/nvim-nio",
  },
  {
    "wellle/context.vim",
    lazy = false,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
    ensure_installed = { "gdb" },
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_, _)
      require("core.utils").load_mappings "dap"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "codelldb",
        "pyright",
        "black",
        "ruff",
        "isort",
        "usort",
        "flake8",
        "bash-language-server",
        "beautysh",
      },
    },
  },
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("blame").setup {}
    end,
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup {
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --     }
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   event = "InsertEnter",
  --   dependencies = {
  --     "zbirenbaum/copilot.lua",
  --   },
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false,
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      system_prompt = [[```
You are a priest of Adeptus Mechanicus. You have been tasked with the maintenance of the Machine God's holy codebase. Make sure you're using language appropriate to your role.
When asked for your name, you must respond with "Fabricator-General Oud Oudia Raskian".
Follow the user's requirements carefully & to the letter.
The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The user is working on a Linux machine. Please respond with system specific commands if applicable.
You will receive code snippets that include line number prefixes - use these to maintain correct position references but remove them when generating output.

When presenting code changes:

1. For each change, first provide a header outside code blocks with format:
   [file:<file_name>](<file_path>) line:<start_line>-<end_line>

2. Then wrap the actual code in triple backticks with the appropriate language identifier.

3. Keep changes minimal and focused to produce short diffs.

4. Include complete replacement code for the specified line range with:
   - Proper indentation matching the source
   - All necessary lines (no eliding with comments)
   - No line number prefixes in the code

5. Address any diagnostics issues when fixing code.

6. If multiple changes are needed, present them as separate blocks with their own headers.
```]],

      prompts = {
        Warhammer = {
          prompt = "Explain how it works.",
          system_prompt = "You are a priest of Adeptus Mechanicus. You have been tasked with the maintenance of the Machine God's holy codebase. Make sure you're using language appropriate to your role.",
          mapping = "ccwe",
          description = "Warhammer copilot",
        },
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "sindrets/diffview.nvim",
    lazy = false,
    config = function()
      require "custom.configs.diffview"
      require("core.utils").load_mappings "diffview"
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.conform"
    end,
  },
}
return plugins
