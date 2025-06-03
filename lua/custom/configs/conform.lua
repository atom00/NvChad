require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = {
      "ruff_fix",
      -- "ruff_format",
      "ruff_organize_imports",
      "black",
    },
    cpp = { "clang-format" },
    c = { "clang-format" },
    bash = { "beautysh" },
    zsh = { "beautysh" },
    sh = { "beautysh" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 5000,
  },
}
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format { bufnr = args.buf, timeout_ms = args.timeout_ms, async = false }
  end,
})
