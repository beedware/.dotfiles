set cin aw ai is nu rnu noeb ru cul ic scs sb spr udf nowrap et
set hls cb= ts=4 sw=4 tm=50 mouse=a shm+=sI
let s:mode_file = expand('~/.config/themer/mode')
let s:mode = filereadable(s:mode_file) ? trim(join(readfile(s:mode_file), "\n")) : 'dark'
let &background = s:mode ==# 'light' ? 'light' : 'dark'
set undodir=~/.vim/undo//
sy on
ca Hash w !cpp -dD -P -fpreprocessed <Bar> tr -d '[:space:]' <Bar> md5sum <Bar> cut -c-6
