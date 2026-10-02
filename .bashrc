[[ $- != *i* ]] && return

export EDITOR=nvim
export MANPAGER='nvim +Man!'

export BUN_INSTALL="$HOME/.bun"
export DOTNET_ROOT="$HOME/.dotnet"
export DOTNET_ROOT_X64="$HOME/.dotnet"
export SDKMAN_DIR="$HOME/.sdkman"

export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/.volta/bin:$PATH"
export PATH="$HOME/.go/bin:$PATH"
export PATH="$HOME/.cache/scalacli/local-repo/bin/scala-cli:$PATH"
export PATH="$HOME/.local/share/coursier/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.dotnet:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"

export DOTNET_CLI_TELEMETRY_OPTOUT=1

[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
[ -f "$HOME/.deno/env" ] && source "$HOME/.deno/env"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

export GOPATH="$HOME/.go"
[ -d "$SDKMAN_DIR/candidates/java/current" ] \
  && export JAVA_HOME="$SDKMAN_DIR/candidates/java/current" \
  || export JAVA_HOME="/usr/lib/jvm/default"

[ -d "$SDKMAN_DIR/candidates/maven/current" ] \
  && export MAVEN_HOME="$SDKMAN_DIR/candidates/maven/current" \
  || export MAVEN_HOME="/usr/share/maven"

set -o emacs

shopt -s histappend
export HISTSIZE=500000
export HISTFILESIZE=500000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
export HISTTIMEFORMAT='%F %T '

alias peaclock='peaclock --config-dir ~/.config/peaclock'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza'
  alias tree='eza --tree'
else
  alias ls='ls --color=auto'
  alias tree='tree -C'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --theme=Dark -p'
fi

alias mkdir='mkdir -v'
alias rm='rm -v'
alias mv='mv -v'
alias cp='cp -v'

alias grep='grep --color=auto'
alias python='python3'

fonts() {
  fc-list | command grep -ioE ": [^:]*${1:-}[^:]+:" | sed -E "s/(^: |:)//g" | tr , "\n" | sort | uniq
}

distrotime() {
  local created_ts now_ts days

  created_ts=$(stat -c %W /) || return
  ((created_ts > 0)) || return
  now_ts=$(date +%s) || return
  days=$(((now_ts - created_ts) / 86400))

  if ((days == 1)); then
    echo "distro 1 day"
  else
    echo "distro $days days"
  fi
}

source $HOME/.config/fzf/themes/dark.sh
export FZF_DEFAULT_OPTS="--layout=reverse --height=~14 ${FZF_DEFAULT_OPTS:-}"
tmux set-environment -g FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS" 2>/dev/null
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"

command -v flutter >/dev/null 2>&1 && source <(flutter bash-completion 2>/dev/null)

export VIRTUAL_ENV_DISABLE_PROMPT=1
PROMPT_COMMAND='history -a; history -c; history -r'
PS1='\[\e[92m\]\u@\h\[\e[0m\]:\[\e[96m\]\w\[\e[0m\]\n\[\e[93m\]${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV")) }\[\e[0m\]> '
[[ $PS1 &&
  ! ${BASH_COMPLETION_VERSINFO:-} &&
  -f /usr/share/bash-completion/bash_completion ]] &&
    . /usr/share/bash-completion/bash_completion
