## Standard neovim mappings:
```
<C-e> - close autocomplete
. - repeat last command
* - add word under cursor to search registry
```

### Commands
```
:qa - quit all open buffers
:set filetype? - check file type of current buffer
:f - display file path relative to root project directory
:%s/find/replace/g - find and replace all instances in current buffer
:grep - search with grep and send results to quickfix list
```

### Editing
```
s - delete char and insert
S - delete line and insert
C - delete until end of line and insert
u - undo changes
<C-r> - redo changes
```

### Text Objects
```
p - paragraph
w - word
s - sentence
[, (, {, < - block delimiter
', ", ` - quote delimiter
t - tag
```

### Paging
```
<C-b> - scroll up one full page
<C-f> - scroll down one full page
<C-u> - scroll up half a page
<C-d> - scroll down half a page
gg - scroll to first line
G - scroll to last line
zz - scroll current line to center
zt - scroll current line to top of page
zb - scroll current line to bottom of page
```

### Motions
```
H - first line in view
M - middle line line view
L - last line of view
e - end of word
ge - end of previous word
0 - start of line
^ - start of line (after whitespace)
$ - end of line
f{c} - forward to character on line {c}
F{c} - backward to character on line {u}
t{c} - forward to before character
T{c} forward to after character
% - nearest bracket
[m - previous method start
[M - previous method end
```

### Navigation
```
gf - go to file under cursor
gd - go to method definition
<C-O> - go back through jump history
<C-I> - go forward through jump history
```

### Folds
```
za - toggle fold
zm - increase fold depth by 1
zr - decrease fold depth by 1
zM - close all (increase fold depth to max)
zR - open all (decrease fold depth to max)
za - create fold
```

### Macros
```
q{register}{macro}q - record macro (any key for register, `a` is fine)
@{register} - replay macro
```

### Quickfix list
```
:cw - open quickfix window
:set modifiable - allow vim motions and operations on list
```

## Default nvchad mappings:
```
<leader>rn - toggle relative line numbers
<leader>ra - rename symbol
```

### Nvim-Tree
```
r - rename file
d - delete file
y - copy file name
c - copy file
p - paste file
<C-k> - see file path, size and timestamps
```

### Telescope
```
<leader>ff - find source files (excluding node_modules etc)
<leader>fa - find all files
<leader>fw - find in files
<leader>fb - find in buffers

<Tab> - Toggle selection and move to next selection
<S-Tab> - Toggle selection and move to prev selection
<M-q> - Send selected items to quickfix list
```

### Tabufline
```
gt - go to tab
gT - to go previous tab
1gt - go to first tab, etc
th - move buffer to the left in buffer list
tl - move buffer to the right in buffer list
<C-w-T> - Open current buffer in new tab (tabs close when no open buffers)
```

## Override mappings:
```
:Pencil - enter prose writing mode
<leader>xx - toggle diagnostics panel
```

### nvim-dap
```
<leader>d - add breakpoint
<leader>c - start debug session
```

### mini-map
```
<leader>mt - toggle map
<leader>ms - toggle map side (left vs right)
<leader>mr - refresh map
<leader>mf - toggle map focus
```

### git-signs
```
<leader>hd - git diff current file
<leader>tw - toggle word diff
<leader>tb  toggle current line blame
<leader>hb - blame current line (full)
`<leader>[c` - go to previous hunk
`<leader>]c` - go to next hunk
<leader>hp - preview hunk
<leader>hi - preview hunk (inline)
<leader>hs - stage hunk
<leader>hr - unstage/reset hunk
<leader>hS - stage buffer (`git add {filename}`)
<leader>hR - unstage/reset buffer (`git restore --staged {filename}`)
ih - "in hunk" text object
<C-w>q - exit diff window
:wincmd p | q - exit diff window
:Gitsign setqflist - send hunks to quickfix list
```

## Appendix
```
Key Guide:

CR - enter
C - control
S - shift
M - alt
```
