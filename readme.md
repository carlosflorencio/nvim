# Neovim Config

Always a work in progress.

## First setup

- `:checkhealth`

## Notes to self

- Alacritty has much better performance than iTerm2
  - Enable macOS thin strokes: https://github.com/alacritty/alacritty/commit/2a676dfad837d1784ed0911d314bc263804ef4ef
  - `defaults write org.alacritty AppleFontSmoothing -int 0`
  - https://github.com/alacritty/alacritty/issues/5346#issuecomment-1055695103
- Install cspell dicts https://github.com/streetsidesoftware/cspell-dicts
- https://github.com/hrsh7th/vscode-langservers-extracted/releases release v4.6.0 breaks eslint-lsp
- `prettierd` requires node v16, workaround if the default node version is set to v14 globally:
  - update the bin at `~/.local/share/nvim/mason/packages/prettierd/node_modules/@fsouza/prettierd/bin`
  - `#!/usr/bin/env /Users/cfl12/scripts/node16`
  - `ln -s '~/Library/Application Support/fnm/node-versions/v16.20.1/installation/bin/node' node16`
  

## Global dependencies
- Codi
  - `npm install -g tsun`
- SnipRun
  - `npm install -g ts-node typescript`

## Print

![Printscreen](img/print.png)
