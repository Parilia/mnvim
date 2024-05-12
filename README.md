# neovim
My personal neovim config

## Requiremtns
<a href="https://neovim.io/">neovim</a> 0.9+<br>
### Soft Requirements
<a href="https://github.com/vifm/vifm">vifm</a> <br>  (Other file managers can be hot swapped in, see the vifm custom terminal in the init. My vifm configs can be found <a href="https://github.com/Parilia/Dotfiles/tree/main/vifm">here</a>. **You at the very least will need this setting inside the vifmrc:** <code>set vicmd=nvim</code><br><br>
<a href="https://github.com/jesseduffield/lazygit">LazyGit</a>  <br> (If you are going to use git then I highly recommend this.)<br>
<br>
# Back up your exsisting config
```bash
mv ~/.config/nvim ~/.config/nvim_backup
```
# Clone repo
```
git clone https://github.com/Parilia/nvim.git ~/.config/nvim
```
# nvim switcher, add to your bashrc, zshrc or POSIX Shell.
To add a new config simply rename the nvim folder in the .config, if you are cloning a new one change the name of the nvim folder in the command to what you want it to or use the above command to back up your config as getting a new one will overrite your existing one or may not even download.

```bash
# nvim switcher, you can invoke your config using the alias or by typing "nvims" into your shell
# Set an alias for your config [not needed for default nvim]
alias nvchad="NVIM_APPNAME=nvchad nvim"
alias lvim="NVIM_APPNAME=lvim nvim"

# Add config to the items
nvims() {
  items=("default" "nvchad" "lvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}
```

