# speedster.nvim

![Code Size](https://img.shields.io/github/languages/code-size/ydkulks/speedster.nvim?style=for-the-badge)
![license](https://img.shields.io/github/license/ydkulks/speedster.nvim?style=for-the-badge)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)

Plugin to warm-up and practice typing skill and speed

## 🪧 Demo

### Usage

<div align="center">

![SpeedsterDemo](images/speedsterDemo.gif)

</div>

### 📌 Layout

- Help menu at top left corner
- Time at top right corner
- Display in the middle
- Prompt at the bottom

<div align="center">

![SpeedsterLayout](images/speedster_main.png)

</div>

## ⬇️ Installation

Using [Packer](https://github.com/wbthomason/packer.nvim.git)

```lua
use {'ydkulks/speedster.nvim'}
```

## 🆘 Help

```vim
:help speedster.nvim
```

## ⚙️ Configuration

```lua
require("speedster").setup({
    -- Default values
    num_char = 50,     -- Number of characters displayed
    symbols = 1        -- Number of words replaced with symbols
})
```

## 📄 TODO

- Test compatibility with other plugin managers
- Themes

## 🐛 Known Bugs & Limitation

- Not able to disable some plugins in prompt buffer that affects typing
