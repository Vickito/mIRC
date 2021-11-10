; ====== Alias
alias -l ytkey return token--de--google--api
alias testYT { var %a testyt. $+ $ticks | sockopen -e %a www.googleapis.com 443 | sockmark %a $+($1,$chr(9),$2,$chr(9),$3) }
;--- 1=SOCK 2=posicion 3=valor
alias -l marca { sockmark $1 $addtok($sock($1).mark,$3-,9) }
;======= EVENTOS
;-------- On text
On *:TEXT:!YT*:#: {
  If ($level($nick) >= 2) {
    If ($2 == ON) { .Enable #YT | .msg $chan $nick 1 You 0,4 Tube 1,0 Enable }
    Elseif ($2 == OFF) { .Disable #YT | .msg $chan $nick 1 You 0,4 Tube 1,0 Disable }
    Elseif ($2 == -n) { .msg $chan $nick 1 You 0,4 Tube 1,0 Cargado nuevamente. | /load -rs Base/YT.mrc }
  }
}
#YT on
on ^1:TEXT:*youtu*.*/*:#: {
  if ($wildtok($1,*https://www.youtube.com/watch?v=*,1,32)) { testYT $gettok($v1,2,61) $chan $nick }
  elseif ($wildtok($1-,*https://youtu.be/*,1,32)) { testYT $gettok($v1,3,47) $chan $nick }
}
; ------ apertura del socket
on *:sockopen:testYT.*:{
  if ($sockerr) { return }
  var %a sockwrite -nt $sockname, %id $+(/youtube/v3/videos?id=,$gettok($sock($sockname).mark,1,9),&key=,$ytkey)
  var %id2 &part=snippet,statistics,contentDetails&fields=items(snippet(title,channelTitle,publishedAt),statistics(viewCount,likeCount,dislikeCount),contentDetails(duration))
  %a GET $+(%id,%id2) HTTP/1.1 | %a User-Agent: Quetzalcoatl - (Mozilla  Compatible) | %a Host: www.googleapis.com | %a Connection: close | %a $crlf
}
; ---- lectura del socket
on *:sockread:testYT.*:{
  if ($sockerr > 0) { echo 13 -a socketerror $sockerr | return }
  var %a | sockread %a
  if (": " isin %a) {
    tokenize 32 $remove( $gettok(%a,1,58),$chr(34)) $gettok(%a,2-,58)
    if (title = $1) { $marca($sockname,4,$mid($2-,2,-2)) }
    if (channelTitle = $1) { $marca($sockname,5,$mid($2-,2,-1)) }
    if (duration = $1) { $marca($sockname,6,$lower($mid($2,4,-1))) }
    if (viewCount = $1) { $marca($sockname,7,$mid($2-,2,-2)) }
    if (likeCount = $1) { $marca($sockname,8,$mid($2-,2,-2)) }
    if (dislikeCount = $1) { $marca($sockname,9,$mid($2-,2,-1)) }
  }
}
;---->  $1=IDvideo $2=CHAN $3=NICK $4=titulo $5=canal $6=duracion $7=vistas $8=like $9=dislike
on *:sockclose:testYT.*:{ tokenize 9 $sock($sockname).mark | .msg $2 1 You 0,4 Tube 1,0 Titulo:12 $4 1Duración:12 $6 1Enviado por:12 $3 $+ . Información adicional: Subido por12 $5 1con un total de12 $bytes($7,b) 1Vistas,12 $bytes($8,b) 1Likes y12 $bytes($9,b) 1DisLikes. }
#YT end
