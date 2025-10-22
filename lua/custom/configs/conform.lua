require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    -- python = {
    --   "ruff_fix",
    --   "ruff_format",
    --   "ruff_organize_imports",
    -- },
    python = (function()
      local cache = {}
      return function(bufnr)
        -- Find project root using git rev-parse from current working directory
        local function find_project_root()
          local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
          if git_root and git_root ~= "" then
            local pyproject = git_root .. "/pyproject.toml"
            if vim.fn.filereadable(pyproject) == 1 then
              return git_root
            end
          end
          return nil
        end
        local project_root = find_project_root()
        if not project_root then
          return {}
        end
        if cache[project_root] then
          return cache[project_root]
        end
        local pyproject = project_root .. "/pyproject.toml"
        local plugins = {}
        local has_ruff = vim.fn.system("grep '\\[tool.ruff' " .. pyproject) ~= ""
        local has_isort = vim.fn.system("grep '\\[tool.isort' " .. pyproject) ~= ""
        local has_usort = vim.fn.system("grep '\\[tool.usort' " .. pyproject) ~= ""
        if has_isort then
          table.insert(plugins, "isort")
        end
        if has_usort then
          table.insert(plugins, "usort")
        end
        if has_ruff then
          table.insert(plugins, "ruff_fix")
          table.insert(plugins, "ruff_format")
          -- table.insert(plugins, "ruff_organize_imports")
        end
        cache[project_root] = plugins
        return plugins
      end
    end)(),
    cpp = { "clang_format" },
    c = { "clang_format" },
    bash = { "beautysh" },
    zsh = { "beautysh" },
    sh = { "beautysh" },
  },
  formatters = {
    clang_format = {
      prepend_args = { "--style=file", "--fallback-style=LLVM" },
    },
    shfmt = {
      prepend_args = { "-i", "4" },
    },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 5000,
  },
}
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format { bufnr = args.buf, timeout_ms = 5000, async = false }
  end,
})
