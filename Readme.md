# Dotfiles

## [macOS](https://github.com/imawizard/dotfiles/tree/macos)

```sh
mkdir ~/.dotfiles.git && cd $_
git clone --no-checkout --branch macos https://github.com/imawizard/dotfiles .
mv .git/* ./ && rm -rf .git
git config core.worktree .. && git config status.showUntrackedFiles no
git reset --mixed && git checkout ..
```

## [Windows](https://github.com/imawizard/dotfiles/tree/windows)

```sh
mkdir ~/.dotfiles.git | cd
git clone --no-checkout --branch windows https://github.com/imawizard/dotfiles .
Move-Item .git/* ./ && Remove-Item -Force .git
git config core.worktree .. && git config status.showUntrackedFiles no
git reset --mixed && git checkout ..
```

## Resources
### Dotfiles
- [archseer / Blaž Hrastnik](https://github.com/archseer/dotfiles)
- [disrupted / Salomon Popp](https://github.com/disrupted/dotfiles)
- [endocrimes / Danielle](https://github.com/endocrimes/dotfiles)
- [fasterthanlime / Amos Wenger](https://github.com/fasterthanlime/dotfiles)
- [FelixKratz](https://github.com/FelixKratz/dotfiles)
- [jonhoo / Jon Gjengset](https://github.com/jonhoo/configs)
- [kalkayan / Manish Sahani](https://github.com/kalkayan/dotfiles)
- [koekeishiya / Åsmund Vikane](https://github.com/koekeishiya/dotfiles)
- [L3MON4D3](https://github.com/L3MON4D3/Dotfiles)
- [Lukas Reineke](https://github.com/lukas-reineke/dotfiles)
- [Prabir Shrestha](https://github.com/prabirshrestha/dotfiles)
- [simnalamburt / Hyeon Kim](https://github.com/simnalamburt/.dotfiles)
- [thoughtbot, inc.](https://github.com/thoughtbot/dotfiles)
- [Tim Untersberger](https://github.com/TimUntersberger/dotfiles)
- [VonHeikemen / Heiker](https://github.com/VonHeikemen/dotfiles)
- [Wil Thomason](https://github.com/wbthomason/dotfiles)
### Neovim config
- [fannheyward / Heyward Fann](https://github.com/fannheyward/init.vim)
- [FooSoft / Alexei Yatskov](https://github.com/FooSoft/dotvim)
- [glepnir / Raphael](https://github.com/glepnir/nvim)
- [Joel Palmer](https://gist.github.com/joelpalmer/9db3f1cdfd463daa6d7c614ae1618fa6)
- [kyazdani42 / Kiyan](https://github.com/kyazdani42/nvim-config)
- [lervag / Karl Yngve Lervåg](https://github.com/lervag/dotvim)
- [numToStr](https://github.com/numToStr/dotfiles/tree/master/neovim/.config/nvim)
- [Tim Untersberger](https://github.com/TimUntersberger/neovim.config)
### Neovim fennel
- [aniseed](https://github.com/Olical/aniseed)
- [hibiscus.nvim](https://github.com/udayvir-singh/hibiscus.nvim)
- [hotpot.nvim](https://github.com/rktjmp/hotpot.nvim)
- [tangerine.nvim](https://github.com/udayvir-singh/tangerine.nvim)
### Emacs config
- [Will Crichton](https://github.com/willcrichton/dotfiles)
### Editor packs
- [Doom Emacs](https://github.com/doomemacs/doomemacs)
- [LunarVim](https://github.com/LunarVim/LunarVim)
- [neodev.nvim](https://github.com/folke/neodev.nvim)
- [NvChad](https://github.com/NvChad/NvChad)
### Tools
- [chezmoi](https://github.com/twpayne/chezmoi)
- [dotter](https://github.com/SuperCuber/dotter)
- [homeshick](https://github.com/andsens/homeshick)
### Using git
- [Best Way to Store in a Bare Git Repository](https://www.atlassian.com/git/tutorials/dotfiles)
- [Tracking dotfiles directly with Git](https://wiki.archlinux.org/title/Dotfiles)
### Using stow
- [Managing Dotfiles with GNU Stow (2016) - Hacker News](https://news.ycombinator.com/item?id=27137172)
- [Using GNU Stow to manage your dotfiles (2012) - Hacker News](https://news.ycombinator.com/item?id=25549462)
- [Managing dotfiles with GNU Stow - Hacker News](https://news.ycombinator.com/item?id=11515222)

<!-- vim: set tw=0 wrap ts=4 sw=4 et: -->
