export FZF_DEFAULT_OPTS=" \
--color=bg:#000000,bg+:#000000,spinner:#fec43f,hl:#ff5f59 \
--color=fg:#ffffff,header:#2fafff,info:#00d3d0,pointer:#feacd0 \
--color=marker:#44bc44,fg+:#ffffff,prompt:#2fafff,hl+:#ff6b55 \
--color=selected-bg:#000000 \
--color=border:#a6a6a6,label:#595959"

tmux set-environment -g FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS" 2>/dev/null
