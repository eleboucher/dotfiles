fish_add_path $HOME/dev/bin
fish_add_path /usr/local/go/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.opencode/bin
fish_add_path $HOME/.lmstudio/bin
fish_add_path $HOME/.bun/bin
fish_add_path /opt/cuda/bin
fish_add_path /usr/local/cuda/bin

if set -q KREW_ROOT
    fish_add_path $KREW_ROOT/bin
else
    fish_add_path $HOME/.krew/bin
end

# Environment variables
if set -q SSH_CONNECTION
    set -gx EDITOR vim
    set -gx VISUAL vim
else
    set -gx EDITOR nvim
    set -gx VISUAL nvim
end

set -gx K9S_CONFIG_DIR $HOME/.config/k9s
set -gx SOPS_AGE_KEY_FILE $HOME/.config/sops/age/keys.txt
set -gx BUN_INSTALL $HOME/.bun

if test -d /usr/local/cuda/lib64
    set -gx LD_LIBRARY_PATH /usr/local/cuda/lib64 $LD_LIBRARY_PATH
end


if status is-interactive
    __cache_init starship "starship init fish"
    __cache_init mise     "mise activate fish"

    if type -q fzf
        set -gx FZF_DEFAULT_COMMAND "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
        set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
        __cache_init fzf "fzf --fish"
    end

    __cache_init atuin  "atuin init fish --disable-up-arrow"
    __cache_init direnv "direnv hook fish"
    __cache_init zoxide "zoxide init fish"
end

# pnpm
set -gx PNPM_HOME "/home/erwanleboucher/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
