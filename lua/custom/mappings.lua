local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<F9>"] = {
      "<cmd> DapContinue <CR>",
      "Start or continue the debugger",
    },
    ["<F5>"] = {
      "<cmd> DapStepInto <CR>",
      "Step into",
    },
    ["<F6>"] = {
      "<cmd> DapStepOver <CR>",
      "Step over",
    },
    ["<F7>"] = {
      "<cmd> DapStepOut <CR>",
      "Step out",
    },
  }
}

return M
