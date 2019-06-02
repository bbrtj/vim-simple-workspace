function! s:swmsg(content)
    if exists("g:simplews_loaded") && (!exists("s:simplews_silent") || !s:simplews_silent)
        redraw
        echom a:content
    endif
endfunction

function! s:swmsghl(content)
    echohl WarningMsg
    call s:swmsg(a:content)
    echohl None
endfunction

function! s:autosave()
    if g:simplews_autosave
        call simplews#write_silent()
    endif
endfunction

function! s:set_current_workspace(...)
    let s:simplews_last_workspace = exists("s:simplews_current") ? s:simplews_current : ""
    if a:0 > 0 && strlen(a:1) > 0
        let s:simplews_current = a:1
        let s:simplews_current_path = expand(g:simplews_root . s:simplews_current . ".vim")
    endif
endfunction

function! s:restore_workspace()
    call s:set_current_workspace(s:simplews_last_workspace)
endfunction

function! s:check_exists()
    if filewritable(s:simplews_current_path)
        return 1
    endif
    call s:swmsghl("Workspace couldn't be found: " . s:simplews_current)
endfunction

function! s:check_set()
    if exists("s:simplews_current") && strlen(s:simplews_current) > 0
        return 1
    endif
    call s:swmsghl("Workspace name is required")
endfunction

function! s:unload_workspace(force)
    let unsaved = len(getbufinfo({'buflisted': 1, 'bufmodified': 1}))
    if unsaved == 0 || a:force
        execute "bufdo bw!"
        return 1
    endif
    call s:swmsghl("Some of the current buffers are modified, force with !")
endfunction

function! s:unset()
    unlet s:simplews_current
    unlet s:simplews_current_path
endfunction

function! simplews#write_silent(...)
    let s:simplews_silent = 1
    let retval = call("simplews#write", a:000)
    let s:simplews_silent = 0
    return retval
endfunction

function! simplews#write(...)
    call call("s:set_current_workspace", a:000)
    if s:check_set()
        execute "silent mksession! " . s:simplews_current_path
        call s:swmsg("Workspace saved: " . s:simplews_current)
        return 1
    endif
endfunction

function! simplews#read_silent(workspace, force)
    let s:simplews_silent = 1
    let retval = simplews#read(a:workspace, a:force)
    let s:simplews_silent = 0
    return retval
endfunction

function! simplews#read(workspace, force)
    call s:autosave()
    call s:set_current_workspace(a:workspace)
    if s:check_exists() && s:unload_workspace(a:force)
        execute "silent source " . s:simplews_current_path
        call s:swmsg("Workspace loaded: " . s:simplews_current)
        return 1
    else
        call s:restore_workspace()
    endif
endfunction

function! simplews#close(force)
    call s:autosave()
    if s:check_set() && s:check_exists() && s:unload_workspace(a:force)
        call s:swmsg("Workspace closed: " . s:simplews_current)
        call s:unset()
        return 1
    endif
endfunction

function! simplews#delete(force)
    if s:check_set() && s:check_exists() && s:unload_workspace(a:force)
        if delete(s:simplews_current_path) == 0
            call s:swmsg("Workspace deleted: " . s:simplews_current)
        else
            call s:swmsghl("Workspace couldn't be deleted: " . s:simplews_current)
        endif
        call s:unset()
    endif
endfunction

function! simplews#show_current(full)
    let s:simplews_silent = 1
    let isset = s:check_set()
    let s:simplews_silent = 0
    if isset
        if !a:full
            call s:swmsg("Current workspace: " . s:simplews_current)
        else
            call s:swmsg("Current workspace: " . s:simplews_current_path)
        endif
    else
        call s:swmsg("No workspace is open")
    endif
endfunction

function! simplews#show_all()
    let workspaces = split(globpath(g:simplews_root, "*.vim"), "\n")
    if len(workspaces) > 0
        let workspaces_string = substitute(join(workspaces, ', '), expand(g:simplews_root), "", "g")
        let workspaces_string = substitute(workspaces_string, ".vim", "", "g")
        call s:swmsg("Workspaces: " . workspaces_string)
    else
        call s:swmsg("No available workspaces")
    endif
endfunction
