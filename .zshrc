# XDG base directories. These four are the spec defaults, set explicitly on
# purpose: when only XDG_CONFIG_HOME was set, some tools derived their cache and
# data dirs *relative to it* and built duplicate ~/.config/cache (32G) and
# ~/.config/local/share trees alongside the real ~/.cache and ~/.local/share.
# Keep all four together so that cannot happen again.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# completion fpath additions must come BEFORE zsh-autocomplete is sourced.
# Nothing needs one right now; keep this comment so the next addition lands here
# rather than after the plugin, where it would be ignored.

# autocomplete
# NOTE: this plugin runs compinit itself. Do not add `compinit` anywhere below.
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# alias
alias ,p='cd ~'
alias ls='lsd'
alias ll='lsd -l'

# alias code='cursor'
# alias python='/opt/homebrew/bin/python3.13'
# brew
export PATH="/opt/homebrew/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/adamzh0u/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# quarto. Guarded: exporting a path that does not exist makes quarto fail with a
# confusing error instead of falling back to the python on PATH. The old value
# pointed at ~/300_Main, which no longer exists.
_quarto_py="$HOME/github.com/AdamZh0u/01_Main/.venv/bin/python"
[ -x "$_quarto_py" ] && export QUARTO_PYTHON="$_quarto_py"
unset _quarto_py

export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# starship
eval "$(starship init zsh)"

# add new line at line start
precmd() { print "" }

echo "Courage counts !"
# China proxy (for GitHub access)
# export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897
unset http_proxy https_proxy all_proxy

# uv tools, claude, codex, nlm, duckdb all install here. The line arrived with
# the SkillHub CLI, which is gone; the directory is load-bearing on its own.
export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=/Users/adamzh0u/.opencode/bin:$PATH

# Mole shell completion
if output="$(mole completion zsh 2>/dev/null)"; then eval "$output"; fi

#projj
# 这里会定义一个 p() 目录跳转函数。别在上面给 p 设别名：zsh 不允许用已是别名的
# 名字定义函数，会报错并让【整个 eval 作废】，projj 的补全会全部丢失。
command -v projj >/dev/null && eval "$(projj shell-setup zsh)"
