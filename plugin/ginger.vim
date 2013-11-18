let s:endpoint = 'http://services.gingersoftware.com/Ginger/correct/json/GingerTheText'
function! s:ginger(text)
  if get(g:, 'ginger_api_key', '') == ''
    throw 'g:ginger_api_key is not set'
  endif
  let res = webapi#json#decode(webapi#http#get(s:endpoint, {
  \ 'lang': 'US',
  \ 'clientVersion': '2.0',
  \ 'apiKey': g:ginger_api_key,
  \ 'text': a:text}).content)
  let i = 0
  let correct = ''
  echon "Mistake: "
  for rs in res['LightGingerTheTextResult']
    let [from, to] = [rs['From'], rs['To']]
    if i < from
      echon a:text[i : from-1]
      let correct .= a:text[i : from-1]
    endif
    echohl WarningMsg
    echon a:text[from : to]
	echohl None
    let correct .= rs['Suggestions'][0]['Text']
    let i = to + 1
  endfor
  if i < len(a:text)
    echon a:text[i :]
    let correct .= a:text[i :]
  endif
  echo "Correct: ".correct
endfunction
 
command! -nargs=+ Ginger call s:ginger(<q-args>)
