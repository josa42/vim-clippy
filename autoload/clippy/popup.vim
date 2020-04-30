function! clippy#popup#create(frame)
  let winid = -1

  if exists('*popup_create')
    let winid = popup_create('', s:get_vim_option(a:frame))
    if winid == 0 | let winid = -1 | endif

  elseif exists('*nvim_open_win')
    let bufnr = nvim_create_buf(0, 1)
    let winid = nvim_open_win(bufnr, 0, s:get_nvim_option(a:frame))
    if winid == 0
      execute ':bdelete! ' . bufnr
      let winid = -1
    else
      call setwinvar(winid, '&wrap', 0)
    endif
  endif

  return winid
endfunction

function! clippy#popup#close(winid)
  if a:winid <= 0 | return | endif

  if exists('*popup_create')
    call popup_close(a:winid)
  
  elseif exists('*nvim_open_win')
    execute ':bdelete! ' . winbufnr(a:winid)
  endif
endfunction

function! clippy#popup#set_content(winid, content)
  if a:winid <= 0 | return | endif

  if exists('*popup_create')
    call popup_settext(a:winid, a:content)

  elseif exists('*nvim_open_win')
    call nvim_buf_set_lines(winbufnr(a:winid), 0, -1, 1, a:content)
  endif
endfunction

function! clippy#popup#set_frame(winid, frame)
  if a:winid <= 0 | return | endif

  if exists('*popup_create')
    call popup_setoptions(a:winid, s:get_vim_option(a:frame))

  elseif exists('*nvim_open_win')
    call nvim_win_set_config(a:winid, s:get_nvim_option(a:frame))
  endif
endfunction

function! s:get_vim_option(frame)
  let option = {
    \   'col' : a:frame['x'],
    \   'line' : a:frame['y'],
    \   'maxwidth' : a:frame['width'],
    \   'minwidth' : a:frame['width'],
    \   'maxheight' : a:frame['height'],
    \   'minheight' : a:frame['height'],
    \   'pos' : 'topleft',
    \   'posinvert' : 0,
    \   'fixed' : 1,
    \   'tabpage' : -1,
    \   'wrap' : 0,
    \   'drag' : 0,
    \   'resize' : 0,
    \   'close' : 'none',
    \   'scrollbar' : 0,
    \ }
  return option
endfunction

function! s:get_nvim_option(frame)
  let option = {
    \   'col' : a:frame['x'] - 1,
    \   'row' : a:frame['y'] - 1,
    \   'width' : a:frame['width'],
    \   'height' : a:frame['height'],
    \   'relative' : 'editor',
    \   'anchor' : 'NW',
    \   'focusable' : 0,
    \   'style' : 'minimal',
    \ }
  return option
endfunction

