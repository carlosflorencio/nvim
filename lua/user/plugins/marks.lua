return {
  {
    -- improved marks, marks in signcolumn, cycle through marks
    -- dm<space>       Delete all marks in the current buffer
    -- m]              Move to next mark
    -- m[              Move to previous mark
    -- m:              Preview mark. This will prompt you for a specific mark to preview; press <cr> to preview the next mark.
    'chentoast/marks.nvim',
    enabled = true,
    opts = {},
    lazy = false,
  },
}
