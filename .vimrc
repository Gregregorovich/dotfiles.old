" Number Each Line
set nu
"set relativenumber
autocmd VimEnter * execute ":RltvNmbr"

" Enable Syntax Highlighting
syntax on

" Remapping Ctrl+C to not go back a character
inoremap <C-c> <C-c>`^
inoremap <F2> <C-c>`^

" Allow saving of files as sudo when vim is started without sudo
cmap w!! w !sudo tee > /dev/null %

" Set Tabbed Indents to 2 spaces
set expandtab
set shiftwidth=2
set softtabstop=2
"set shiftwidth=2
"set softtabstop=2

" Set Tab and Shift+Tab to work with indents
nnoremap <Tab> >>
inoremap <Tab> <C-T>
vnoremap <Tab> >v
nnoremap <S-Tab> <<
inoremap <S-Tab> <C-D>
vnoremap <S-Tab> <v

" Better word navigation for Dvorak
nnoremap T B
nnoremap t b
nnoremap S W
nnoremap s w

" Page Up/Down Dvorak keys -> Top/Bottom of screen
nnoremap h H
nnoremap - L

" Vim Theme Identification Function
colorscheme desert
"function! ShowColourSchemeName()
function! Theme()
    try
        echo g:colors_name
    catch
        colo
    catch /^Vim:E121/
        echo "default
    endtry
endfunction

" Dvorak -> Qwerty remapping (Disabled)
"set langmap='q,\\,w,.e,pr,yt,fy,gu,ci,ro,lp,/[,=],aa,os,ed,uf,ig,dh,hj,tk,nl,s\\;,-',\\;z,qx,jc,kv,xb,bn,mm,w\\,,v.,z/,[-,]=,\"Q,<W,>E,PR,$
T,FY,GU,CI,RO,LP,?{,+},AA,OS,ED,UF,IG,DH,HJ,TK,NL,S:,_\",:Z,QX,JC,KV,XB,BN,MM,W<,V>,Z?
