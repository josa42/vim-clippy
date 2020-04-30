let s:state = {}

function! clippy#show(content)
  let max = s:max(a:content)
  let sep = repeat('─', max)

  let content = [
    \   '',
    \   ' ╭──╮   ',
    \   ' │  │   ',
    \   ' @  @  ╭',
    \   ' ││ ││ │',
    \   ' ││ ││ ╯',
    \   ' │╰─╯│',
    \   ' ╰───╯'
    \ ]

  call s:add(content, 1, '╭─' . sep . '─╮')
  call s:add(content, 2, '│ ' . s:fill(get(a:content, 0, ''), max) . ' │')
  call s:add(content, 3, '│ ' . s:fill(get(a:content, 1, ''), max) . ' │')
  call s:add(content, 4, '│ ' . s:fill(get(a:content, 2, ''), max) . ' │')
  call s:add(content, 5, '╰─' . sep . '─╯')

  let width = s:max(content) + 1

  let config = { 'width': width, 'height': 9 }
  let frame = s:calculate_frame(config)

  if !exists('t:clippy_winid')
    let t:clippy_winid = clippy#popup#create(frame)
  else
    call clippy#popup#set_frame(t:clippy_winid, frame)
  endif

  let s:state[t:clippy_winid] = config

  call clippy#popup#set_content(t:clippy_winid, content)
endfunction

function! clippy#close()
  if exists('t:clippy_winid')
    call clippy#popup#close(t:clippy_winid)
    unlet t:clippy_winid
  endif
endfunction

function! clippy#update_all()
  for popupid in keys(s:state)
    call clippy#popup#set_frame(str2nr(popupid), s:calculate_frame(s:state[popupid]))
  endfor
endfunction

function! s:calculate_frame(config)
  let x = &columns + 1 - a:config['width']
  let y = &lines + 1 - a:config['height'] - 2

  return {
    \   'y': y, 'x': x,
    \   'width':  a:config['width'], 'height': a:config['height']
    \ }
endfunction

function! s:max(list)
  let m = 0
  for s in a:list
    let sl = strchars(s)
    if sl > m | let m = sl | endif
  endfor

  return m
endfunction

function! s:add(frame, line, str)
  let a:frame[a:line] = get(a:frame, a:line, '') . a:str
endfunction

function! s:fill(str, len)
  return a:str . repeat(' ', a:len - strlen(a:str))
endfunction

