## Standard neovim mappings:

:qa - quit all open buffers
:set filetype? - check file type of open buffer
:f - display file path relative to root project directory
<C-e> - close autocomplete

q{register}{macro}q - record macro (any key for register, `a` is fine)
@{register} - replay macro

## Default nvchad mappings:

<leader>rn - toggle relative line numbers
<leader>ra - rename symbol

### Telescope

<leader>ff - find source files (excluding node_modules etc)
<leader>fa - find all files
<leader>fw - find in files
<leader>fb - find in buffers

<Tab> - Toggle selection and move to next selection
<S-Tab> - Toggle selection and move to prev selection
<M-q> - Send selected items to quickfix list

### Tabufline

gt - go to tab
gT - to go previous tab
1gt - go to first tab, etc
<C-w-T> - Open current buffer in new tab (tabs close when no open buffers)

## Override mappings:

:Pencil - enter prose writing mode
<leader>xx - toggle diagnostics panel

### nvim-dap

<leader>c - start debug session

## Appendix

Key Guide:

CR - enter
C - control
S - shift
M - alt
