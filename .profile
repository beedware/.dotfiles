export BUN_INSTALL="$HOME/.bun"
export DOTNET_ROOT="$HOME/.dotnet"
export DOTNET_ROOT_X64="$HOME/.dotnet"
export SDKMAN_DIR="$HOME/.sdkman"

export EDITOR=nvim
export GOPATH="$HOME/.go"
export MPD_HOST=/tmp/mpd_socket
export DOTNET_CLI_TELEMETRY_OPTOUT=1

[ -d "$SDKMAN_DIR/candidates/java/current" ] \
  && export JAVA_HOME="$SDKMAN_DIR/candidates/java/current" \
  || export JAVA_HOME="/usr/lib/jvm/default-jdk"

[ -d "$SDKMAN_DIR/candidates/maven/current" ] \
  && export MAVEN_HOME="$SDKMAN_DIR/candidates/maven/current" \
  || export MAVEN_HOME="/usr/share/maven"

export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/.local/share/cabal/bin:$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/.volta/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.cache/scalacli/local-repo/bin/scala-cli:$PATH"
export PATH="$HOME/.local/share/coursier/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/flatpak/exports/bin:$PATH"
export PATH="/var/lib/flatpak/exports/bin:$PATH"
export PATH="/usr/games:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$DOTNET_ROOT:$PATH"
export PATH="$DOTNET_ROOT/tools:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
