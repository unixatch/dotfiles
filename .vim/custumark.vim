scriptencoding utf-8

let g:airline#themes#custumark#palette = {}

" -- Normal --
let s:airline_a_normal = ['#00005f', '#36aa00', 17 , 190]
let s:airline_b_normal = ['#ffffff', '#444444', 255, 238]
let s:airline_c_normal = ['#9cffd3', '#141422', 85 , 234]
let g:airline#themes#custumark#palette.normal = 
\  airline#themes#generate_color_map(
\    s:airline_a_normal, s:airline_b_normal, s:airline_c_normal
\  )

" Normal modified
let g:airline#themes#custumark#palette.normal_modified = {
\ 'airline_c': ['#ffffff', '#272227', 255, 53, ''],
\}

" -- Insert --
let s:airline_a_insert = ['#00005f', '#00aaff', 17 , 45]
let s:airline_b_insert = ['#ffffff', '#005fdd', 255, 27]
let s:airline_c_insert = ['#ffffff', '#000050', 15 , 17]
let g:airline#themes#custumark#palette.insert = 
\  airline#themes#generate_color_map(
\    s:airline_a_insert, s:airline_b_insert, s:airline_c_insert
\  )
" Insert modified
let g:airline#themes#custumark#palette.insert_modified = {
\ 'airline_c': ['#ffffff', '#210045', 255, 53, '']
\}
" Insert paste
let g:airline#themes#custumark#palette.insert_paste = {
\ 'airline_a': [
\    s:airline_a_insert[0], '#d78700', s:airline_a_insert[2], 172, ''
\  ],
\}

" -- Terminal --
let g:airline#themes#custumark#palette.terminal = 
\  airline#themes#generate_color_map(
\    s:airline_a_insert, s:airline_b_insert, s:airline_c_insert
\  )

" -- Replace --
let g:airline#themes#custumark#palette.replace = copy(
\  g:airline#themes#custumark#palette.insert
\)
let g:airline#themes#custumark#palette.replace.airline_a = [
\  s:airline_b_insert[0], '#af0000', s:airline_b_insert[2], 124, ''
\]
let g:airline#themes#custumark#palette.replace_modified = 
\  g:airline#themes#custumark#palette.insert_modified

" -- Visual --
let s:airline_a_visual = ['#000000', '#ee9e00', 232, 214]
let s:airline_b_visual = ['#000000', '#ee5e00', 232, 202]
let s:airline_c_visual = ['#ffffff', '#400000', 15,  52 ]
let g:airline#themes#custumark#palette.visual = 
\  airline#themes#generate_color_map(
\    s:airline_a_visual, s:airline_b_visual, s:airline_c_visual
\  )
" Visual modified
let g:airline#themes#custumark#palette.visual_modified = {
\ 'airline_c': [ '#ffffff', '#440031', 255, 53, ''],
\}

" -- Inactive --
let s:airline_a_inactive = ['#4e4e4e', '#1c1c1c', 239, 234, '']
let s:airline_b_inactive = ['#4e4e4e', '#262626', 239, 235, '']
let s:airline_c_inactive = ['#4e4e4e', '#303030', 239, 236, '']
let g:airline#themes#custumark#palette.inactive = 
\  airline#themes#generate_color_map(
\    s:airline_a_inactive, s:airline_b_inactive, s:airline_c_inactive
\  )
" Inactive modified
let g:airline#themes#custumark#palette.inactive_modified = {
\ 'airline_c': [ '#875faf', '', 97, '', ''],
\}

" -- Commandline --
let s:airline_a_commandline = ['#00005f', '#00d700', 17 , 40 ]
let s:airline_b_commandline = ['#ffffff', '#444444', 255, 238]
let s:airline_c_commandline = ['#9cffd3', '#202020', 85 , 234]
let g:airline#themes#custumark#palette.commandline = 
\  airline#themes#generate_color_map(
\    s:airline_a_commandline, s:airline_b_commandline, s:airline_c_commandline
\)

" -- Accents --
let g:airline#themes#custumark#palette.accents = {
\ 'red': ['#ff0000', '', 160, '']
\}

if get(g:, 'loaded_ctrlp', 0)
  let g:airline#themes#custumark#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
  \  ['#d7d7ff', '#5f00af', 189, 55 , ''    ],
  \  ['#ffffff', '#875fd7', 231, 98 , ''    ],
  \  ['#5f00af', '#ffffff', 55 , 231, 'bold']
  \)
endif
