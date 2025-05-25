-- Custom filetypes
vim.filetype.add {
  filename = {
    ['.eslintrc.json'] = 'jsonc',
  },
  extension = {
    vcl = 'c',
    tftpl = 'c',
    mathjs = 'mathjs',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
    ['.*/%.vscode/.*%.json'] = 'jsonc',
  },
}
