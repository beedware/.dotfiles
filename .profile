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

path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_prepend "$HOME/.local/share/nvim/mason/bin"
path_prepend "$HOME/.local/share/cabal/bin"
path_prepend "$HOME/.ghcup/bin"
path_prepend "$HOME/.volta/bin"
path_prepend "$GOPATH/bin"
path_prepend "$HOME/.cache/scalacli/local-repo/bin/scala-cli"
path_prepend "$HOME/.local/share/coursier/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.local/share/flatpak/exports/bin"
path_prepend "/var/lib/flatpak/exports/bin"
path_prepend "/usr/games"
path_prepend "/usr/local/go/bin"
path_prepend "$DOTNET_ROOT"
path_prepend "$DOTNET_ROOT/tools"
path_prepend "$BUN_INSTALL/bin"

export PATH

unset -f path_prepend
