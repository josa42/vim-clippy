" ╭──╮   ╭──╮
" │  │   │  │
" @  @  ╭│  │
" ││ ││ ││  │
" ││ ││ ╯╰──╯
" │╰─╯│
" ╰───╯:

augroup clippy_popup_resize
    autocmd!
    autocmd VimResized * call clippy#update_all()
"
    " autocmd User CocDiagnosticChange call ClippyShowErrors()
augroup END

" function! ClippyShowErrors()
"   let count = get(get(b:, 'coc_diagnostic_info', {}), 'error', 0)
"   if count > 0
"     call clippy#show(['Looks like you', 'fucked up ' . count . ' times!', 'Get your shit together!'])
"   else
"     call clippy#hide()
"   endif
" endfunction

