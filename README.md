# heat.nvim

#### Rough idea:

Allow all sorts of hotness-highlighting, be it related to git, general timestamp recency, ...

#### What it is right now:

- coloring timestamps in a buffer by how recent they are.
    - automatically attaching to `fugitiveblame` buffers (see [vim-fugitive](https://github.com/tpope/vim-fugitive)).
    - offer a command to do this for any buffer
- offer a hopefully-decent framework for mapping numerified inputs to color outputs
- `WIP`
