local M = {}

M.diffview = {
  plugin = true,
  n = {
    ["<leader>gd"] = { "<cmd> DiffviewOpen <CR>", "Diff View Open" },
    ["<leader>gx"] = { "<cmd> DiffviewClose <CR>", "Diff View Close" },
  },
}
return M
