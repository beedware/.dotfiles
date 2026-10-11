export BUN_INSTALL="$HOME/.bun"
export DOTNET_ROOT="$HOME/.dotnet"
export DOTNET_ROOT_X64="$HOME/.dotnet"
export SDKMAN_DIR="$HOME/.sdkman"

export EDITOR=nvim
export GOPATH="$HOME/.go"
export MPD_HOST=/tmp/mpd_socket
export DOTNET_CLI_TELEMETRY_OPTOUT=1

if [ -d "$SDKMAN_DIR/candidates/java/current" ]; then
  export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
else
  export JAVA_HOME="/usr/lib/jvm/default-jdk"
fi

if [ -d "$SDKMAN_DIR/candidates/maven/current" ]; then
  export MAVEN_HOME="$SDKMAN_DIR/candidates/maven/current"
else
  export MAVEN_HOME="/usr/share/maven"
fi

prepend_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

prepend_path "$HOME/.local/share/nvim/mason/bin"
prepend_path "$HOME/.local/share/cabal/bin"
prepend_path "$HOME/.ghcup/bin"
prepend_path "$HOME/.volta/bin"
prepend_path "$GOPATH/bin"
prepend_path "$HOME/.cache/scalacli/local-repo/bin/scala-cli"
prepend_path "$HOME/.local/share/coursier/bin"
prepend_path "$HOME/.local/bin"
prepend_path "$HOME/.local/share/flatpak/exports/bin"
prepend_path "/var/lib/flatpak/exports/bin"
prepend_path "/usr/games"
prepend_path "/usr/local/go/bin"
prepend_path "$DOTNET_ROOT"
prepend_path "$DOTNET_ROOT/tools"
prepend_path "$BUN_INSTALL/bin"

export PATH

unset -f prepend_path
