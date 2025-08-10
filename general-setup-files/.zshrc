# AUTOCOMPLETION

# initialize autocompletion
autoload -U compinit && compinit

# History file for zsh
HISTFILE=~/.zsh_history

# How many commands to store in history
HISTSIZE=50000
SAVEHIST=10000

# Share history in every terminal session
setopt SHARE_HISTORY

# Duplicates are gone first
setopt HIST_EXPIRE_DUPS_FIRST

# autocompletion using arrow keys (based on history)
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# Always build LLVM kernel
export LLVM=1

# Always have colour in ls
alias ls="ls --color=always"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# Check if GUI (full colour) or framebuffer
# Generally, GUI uses xterm-based ones, and the -color is needed since FreeBSD's framebuffer terminals use xterm
# Even then, it's probably still better to use the basic prompt for basic xterm (as the fancy prompt looks weird on just xterm vs xterm-256color).
if [[ "$TERM" == xterm*color ]]; then
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
else
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k-basic.zsh	]] || source ~/.p10k-basic.zsh
fi
