" ASPRecolor.vim:   In ASPVBS buffers, give JS, ASP, and HTML sections different guibg colors
" javascript 
" Description:
"   gives unique backgrounds to server-side ASP/VBSCRIPT and client-side
"   Javascript regions. Technique could be applicable to other kinds of files
"   that embed other syntax types.
" Last Change:      February 12, 2003
" Maintainer:       Ross Presser <rpresser@imtek.com>
" Version:          0.90
"
" Usage:
"   Either source this from your vimrc, or just drop it in a plugins/ folder.
"   When active, buffers that get filetype ASPVBS automatically get different
"   guibg colors for the HTML regions, the Javascript regions, and the
"   ASP/VBScript regions.  See compare.asp.html for a comparison.
"
"   Requires a gui, and the ASPVBS ftplugin.

" don't load twice.
if exists("loaded_recolor")
    finish
endif
let loaded_recolor = 1

" Define these two colors to suit your color scheme.  These go well with the
" "fog" colorscheme that I use.
let s:color1='LightGray' " used for javascript areas
let s:color2='#edd5bd' " used for ASP areas. Sort of orange.

" This function takes a specific hlgroup, presumably linked to another
" hlgroup, and retrieves the complete highlight definition, then redefines the
" highlight with a guibg color; obviously it isn't linked afterwards.

function! s:Recolor(hlgroup,bgcolor)
"   echo a:hlgroup . ',' . a:bgcolor
    let name2=synIDattr(synIDtrans(hlID(a:hlgroup)), "name")
    redir @z
       silent exec 'hi ' . name2
    redir END
    let newhl = 'hi ' . a:hlgroup . strpart(@z, stridx(@z, 'xxx')+3) . ' guibg=' . a:bgcolor
    silent exec newhl
endfunction

" This function recolors each of the syntax items that are defined for ASPVBS
" types.  Javascript items are colored with s:color1, and ASP/VBScript items
" with s:color2.
function! s:RecolorASPVBS()

  " javascript items
  cal s:Recolor('javaScrParenError',s:color1)
  cal s:Recolor('javaScript',s:color1)
  cal s:Recolor('javaScriptBoolean',s:color1)
  cal s:Recolor('javaScriptBraces',s:color1)
  cal s:Recolor('javaScriptBranch',s:color1)
  cal s:Recolor('javaScriptComment',s:color1)
  cal s:Recolor('javaScriptComment2String',s:color1)
  cal s:Recolor('javaScriptCommentSkip',s:color1)
  cal s:Recolor('javaScriptCommentString',s:color1)
  cal s:Recolor('javaScriptConditional',s:color1)
  cal s:Recolor('javaScriptExpression',s:color1)
  cal s:Recolor('javaScriptFunction',s:color1)
  cal s:Recolor('javaScriptInParen',s:color1)
  cal s:Recolor('javaScriptLineComment',s:color1)
  cal s:Recolor('javaScriptNumber',s:color1)
  cal s:Recolor('javaScriptOperator',s:color1)
  cal s:Recolor('javaScriptParen',s:color1)
  cal s:Recolor('javaScriptRepeat',s:color1)
  cal s:Recolor('javaScriptSpecial',s:color1)
  cal s:Recolor('javaScriptSpecialCharacter',s:color1)
  cal s:Recolor('javaScriptStatement',s:color1)
  cal s:Recolor('javaScriptStringD',s:color1)
  cal s:Recolor('javaScriptStringS',s:color1)
  cal s:Recolor('javaScriptType',s:color1)

  " AspVBS items
  cal s:Recolor('AspVBSComment',s:color2)
  cal s:Recolor('AspVBSError',s:color2)
  cal s:Recolor('AspVBSFunction',s:color2)
  cal s:Recolor('AspVBSMethods',s:color2)
  cal s:Recolor('AspVBSNumber',s:color2)
  cal s:Recolor('AspVBSStatement',s:color2)
  cal s:Recolor('AspVBSString',s:color2)
  cal s:Recolor('AspVBSTodo',s:color2)
  cal s:Recolor('AspVBScriptInsideHtmlTags',s:color2)
  cal s:Recolor('vbComment',s:color2)
  cal s:Recolor('vbEvents',s:color2)
  cal s:Recolor('vbFunction',s:color2)
  cal s:Recolor('vbLineNumber',s:color2)
  cal s:Recolor('vbMethods',s:color2)
  cal s:Recolor('vbNumber',s:color2)
  cal s:Recolor('vbStatement',s:color2)
  cal s:Recolor('vbString',s:color2)
  cal s:Recolor('vbTodo',s:color2)
  cal s:Recolor('vbTypeSpecifier',s:color2)

" I also like the enclosing <% and %> delimiters to be colored.  Unfortunately
" they are only implicitly defined by a region, and they are linked to
" Delimiter, which is used by lots of other highlights.  So we redefine them
" with our own new Delimiter.
  syn match ASPDelimiter "$^"
  syn region  AspVBScriptInsideHtmlTags keepend matchgroup=ASPDelimiter start=+<%=\=+ end=+%>+ contains=@AspVBScriptTop
  syn region  AspVBScriptInsideHtmlTags keepend matchgroup=ASPDelimiter start=+<script\s\+language="\=vbscript"\=[^>]*\s\+runatserver[^>]*>+ end=+</script>+ contains=@AspVBScriptTop

  " Ordinary delimiter is linked to Special, so we will link to it too -- and
  " then immediately recolor it.
  hi link ASPDelimiter Special
  cal s:Recolor('ASPDelimiter',s:color2)

endfunction

augroup recolor
  au FileType aspvbs call s:RecolorASPVBS()|syn sync fromstart
augroup end
