# Notes

## ⚠️ Help commands

Help commands to refer while building a plugin

```vim
:help 'runtimepath'
:help help-writing
:help modeline
:help right
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
