" SimpleWorkspace vim plugin
" Copyright 2019 Bartosz Jarzyna <brtastic.dev@gmail.com>
"
" Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

function! s:init()
    if !exists("g:simplews_loaded")
        if !exists("g:simplews_root")
            let g:simplews_root = "~/.vim/workspaces/"
        endif

        if filewritable(expand(g:simplews_root)) != 2
            call mkdir(expand(g:simplews_root), "p")
        endif

        if exists("g:simplews_autosave") && g:simplews_autosave
            autocmd! VimLeavePre * :call simplews#write_silent()
        else
            let g:simplews_autosave = 0
        endif

        if exists("g:simplews_autoload") && strlen(g:simplews_autoload) > 0
            call simplews#read_silent(g:simplews_autoload, 0)
        endif

        command! -nargs=? SWWrite :call simplews#write(<q-args>)
        command! -nargs=1 -bang SWRead :call simplews#read(<q-args>, <bang>0)
        command! -bang SWDelete :call simplews#delete(<bang>0)
        command! -bang SWClose :call simplews#close(<bang>0)
        command! -bang SWShow :call simplews#show_current(<bang>0)
        command! SWList :call simplews#show_all()

        if exists("g:simplews_short_commands") && g:simplews_short_commands
            command! -nargs=? W :call simplews#write(<q-args>)
            command! -nargs=1 -bang E :call simplews#read(<q-args>, <bang>0)
            command! -bang F :call simplews#show_current(<bang>0)
        endif
        let g:simplews_loaded = 1
    endif
endfunction

call s:init()

