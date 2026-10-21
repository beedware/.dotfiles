set cin aw ai is nu rnu noeb ru cul ic scs sb spr udf nowrap
set hls cb= ts=4 sw=4 tm=50 bg=dark mouse=a shm+=sI
set undodir=~/.vim/undo//
sy on
ca Hash w !cpp -dD -P -fpreprocessed \| tr -d '[:space:]' \| md5sum \| cut -c-6
