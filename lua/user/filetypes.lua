-- Custom filetypes
vim.filetype.add {
  filename = {
    ['.eslintrc.json'] = 'jsonc',
  },
  extension = {
    vcl = 'c',
    tftpl = 'c',
    mathjs = 'mathjs',
    plist = 'xml',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
    ['.*/%.vscode/.*%.json'] = 'jsonc',
  },
}
