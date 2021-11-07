/**
* Archivo oficial, creado el 15 de agosto del 2020.
* Actualizado con el tiempo, y mejorado.
* Optimizado de una nueva forma y sin errores.
*
* El archivo uno.mrc es importante! 
* Ahí se manejara todos los comandos para los juegos.
*/

alias -l BotNick {
  .set %file $+(scripts\Juego\,$network,\)
  .set %ajoin $+(%file,ajoin.txt)
  .set %pass Nosoynadie
  .set %prefix !

  if ($1 == BotNick) { 
    .load -rs scripts\ $+ $nopath($script)
  } 

  elseif ($1 == info) {
    if ($exists(%ajoin) == $true) { .msg $2 Archivo de $nopath(%ajoin) $+ ! | .play $2 %ajoin 1500 }
    else { .msg $2 Archivo de $nopath(%ajoin) no encontrado! } 
  }

  elseif ($1 == ajoin) {
    .inc -u300 %ajoin_lineas 1
    while (%ajoin_lineas <= $lines(%ajoin)) {
      if (%ajoin_segundos == $null) { .set -u60 %ajoin_segundos 5 }
      if ($me !ison $read(%ajoin,%ajoin_lineas)) { 
        .timer 1 %ajoin_segundos .join -n $read(%ajoin,%ajoin_lineas) 
        .set -u60 %ajoin_segundos $calc((%ajoin_segundos) + 5) 
      }
      .inc %ajoin_lineas
    }
    .unset %ajoin_*
  }
}
On *:start: {
  .echo -s [******] 13Bo07tNi10ck [******] [15|08|2020]
  if (%Aviso_BotNick != $null) { 
    .msg %Aviso_BotNick *10Archivo* $remove($nopath($script),.mrc) cargado correctamente!
    .unset %Aviso_BotNick
  }
}
On 1:connect: { 
  if (irc isin $network) { /nick BotNick } 
  else { .nick BotNick }
  $BotNick(ajoin) 
}
On 1:disconnect: { 
  if ($nick == $me) { 
    .mnick BotNick
    .Identd on BotNick 
    .Partall 
    .Fullname BotNick12© 1420201-142021
    if (%Server != $null) {
      .set %Server_irc $replace($server,Terra,irc,Apolo,irc,saturno,irc,jupiter,irc,neptuno,irc,deep,irc)
      .server -z %Server_irc 
      .unset %Server*
    }
  } 
}
On *:invite:#: { 
  .BotNick 
  if ($level($nick) >= 300) { 
    .join -n $chan 
    .msg $chan Holis $nick :* 
    ;10Root
  }

  elseif ($readini(%Saldo,$nick,OP) == +) { 
    .join -n $chan
    .msg $chan Holis $nick :D 
    ;12OP
  } 

  else { .halt }
}
On 1:join:#: {
  if ($readini(%Saldo,+,$chan) != on) { .halt }
  else {  
    if (%nick_ [ $+ [ $nick ] ] == $null) {
      if ($level($nick) >= 200) || ($readini(%Saldo,$nick,OP) == +) { 
        if (o isincs $usermode) || ($me isop $chan) { .mode $chan +v $nick | .set -z %nick_ $+ $nick 3 } 
      }
    }
  }
}
On *:kick:#: { 
  if ($knick == $me) { 
    if (o isincs $usermode) || ($me isop $chan) { .invite $me $chan } 
    .hop -cn $chan 
  }
}
On *:ban:#: { 
  if ($bnick == $me) || ($banmask iswm $address($me,5)) { 
    if (o isincs $usermode) || ($me isop $chan) { .mode $chan +v-bo $me $banmask $nick } 
  }
}
on *:text:*:*: {
  if (%nick_ [ $+ [ $nick ] ] != $null) { .halt }
  if ($1 == %prefix $+ BotNick) {
    if ($level($nick) >= 200) || ($readini(%Saldo,$nick,OP) == +) { 
      if ($2 == $null) {
        if ($nick ison $chan) { .set -u30 %Aviso_BotNick $chan }
        else { .set -u30 %Aviso_BotNick $nick }
        /reseterror 
        $BotNick(BotNick) 
      }
      elseif ($2 == F) { .set %Server ON | /Quit Nos vemos. Quit: $nick }
    } 
  }

  elseif ($1 == %prefix $+ log) { 
    if ($2 == in) {
      if ($3 === %pass) { 
        if ($level($nick) == 1) { .auser 300 $nick | .msg $nick Eres un Lider. } 
        else { .msg $nick Error: Tiene un nivel de $level($nick) $+ . }
      }
      else { .msg $nick Error: No tienes permiso. }
    }
    elseif ($2 == out) {
      if ($level($nick) == 1) { .msg $nick Error: No tienes nivel. }
      else { .ruser $nick | .msg $nick Has sido borrado. } 
    }
  } 

  elseif ($1 == %prefix $+ Chan) { 
    if ($level($nick) >= 200) || ($readini(%Saldo,$nick,OP) == +) {

      if ($2 == $null) {
        .set -u10 %Chans $chan(1) $chan(2) $chan(3) $chan(4) $chan(5) $chan(6) $chan(7) $chan(8) $chan(9) $chan(10) $chan(11) $chan(12) $chan(13) $chan(14) $chan(15) $chan(16) $chan(17) $chan(18) $chan(19) $chan(20)
        if (%Chans != $null) { .msg $nick $nick Estoy en12 %Chans $+ . }
        else { .msg $nick $nick No me encuentro en ninguna sala ;). }
      }

      elseif ($2 == lista) { $BotNick(info, $nick) }
      elseif ($2 == ajoin) { $BotNick(ajoin) }
      elseif ($2 == sal) { 
        if ($nick ison $chan) { .part $chan } 
        else { .partall }
      }
      elseif ($2 == f) { .partall | .timer 1 10 $BotNick(ajoin) }
      elseif ($2 == hop) { 
        if ($nick ison $chan) { .hop -cn $chan 12Saltito } 
        else {
          if ($2 != $null) { .hop -cn #$2 12Saltito }
          else { .msg $nick Especifica una sala para hacer hop.. }
        }
      }

      elseif ($2 == +) {
        if ($3 == $null) { .msg $nick Dame una sala para entrar. cmd:12 %prefix $+ Chan + #Sala. } 
        else {
          if ($read(%ajoin,w,#$3) == $null) { 
            .write %ajoin #$3-4 | .writeini %Saldo + #$3 on
            .msg $nick Listo, la sala 12 $+ #$3 $+  añadida en mi archivo.
            if ($me !ison $3) { .join -n #$3-4 }
          }
          else { .msg $nick Sala12 #$3 Si esta en mi archivo. }
        }
      }

      elseif ($2 == -) {
        if ($3 == $null) { .msg $nick Dame un sala para salir. cmd:12 %prefix $+ Chan - #Sala. } 
        else {
          if ($read(%ajoin,w,$3) != $null) { 
            .write -ds $+ $read(%ajoin,w,#$3) %ajoin | .remini %Saldo + $3
            .msg $nick Listo, la sala 12 $+ #$3 $+  eliminada de mi archivo. 
            if ($me ison $3) { .part #$3 Chao, eliminada de mi archivo. Eco:12 $nick }
          }
          else { .msg $nick Sala12 $3 No esta en mi archivo. }
        }
      }

      else { .msg $nick Puedes usar 12Lista|12ajoin|12Sal|12F|12Hop|12+|12-. Cmd: 12 $+ %prefix $+ Chan. }
    }
  }

}
