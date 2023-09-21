# Notes

## 🧠 Resources

- [TJ De Vries](https://www.youtube.com/watch?v=n4Lp4cV8YR0)
- [nvim-lua-guide](https://github.com/nanotee/nvim-lua-guide/tree/master)
- [Lua UI (basics)](https://dev.to/2nit/how-to-write-neovim-plugins-in-lua-5cca)
- [Lua UI](https://www.2n.pl/blog/how-to-make-ui-for-neovim-plugins-in-lua)

## ⚠️ Help commands

Help commands to refer while building a plugin

```vim
:Telescope help_tags
:Telescope highlights
:help 'runtimepath'
:help help-writing
:help helptags
:help modeline
:help right
:lua vim.print(vim.api)
:help nvim_open_win()
:help nvim_create_buf()
:help nvim_buf_set_option()
:help nvim_get_option()
:help prompt_setcallback()
```

## Special files and folders

- 📁 `lua/`

Runs only when you `require` the file

```vim
:lua require"file"
```

You can use dot(.) operator to access nested folders

```vim
:lua require"file.nestedFile"
```

- 📁 `plugin/`

Runs when neovim is loaded

- 📁 `init.lua`

Runs when the folder that this file is placed in is `require`ed

- 📄 `filetype.lua`

All .lua files will run when `required`ed only once when neovim is started.
If you want to run something every time you `require`ed the file, do this:

```lua
return 5
```

Essentially what it does is every time it runs, the value of `return` is
saved as **cache**

It is counter intuitive, because it actually does not run multiple time,
it runs one time and save the value in cache for later use.
