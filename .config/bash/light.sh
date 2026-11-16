export FZF_DEFAULT_OPTS=" \
--color=bg:#ffffff,bg+:#ffffff,spinner:#884900,hl:#a60000 \
--color=fg:#000000,header:#0031a9,info:#005e8b,pointer:#721045 \
--color=marker:#006800,fg+:#000000,prompt:#0031a9,hl+:#972500 \
--color=selected-bg:#ffffff \
--color=border:#a6a6a6,label:#595959"

tmux set-environment -g FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS" 2>/dev/null
