/**
  Archivo Alicia.mrc
  Puedes copiarlo y ponerlo en la parte de mIRC donde dice "Remote"
  Recuerda que debes poner en tu bot "/auser 10 tunick" para que tengas el acceso de root.

  Siempre veras todo lo que está pasando en el archivo "Registro.txt"
  Cada comando que se utilice, sabrás quién lo hizo y el día y la hora.
  Puede ser un metodo genial si pasa algo y quieres tener prueba de quién causo lo que esta pasando.
  */

alias -l Alicia {
  /set %Alicia_File $+(scripts\Datos\) 

  /set %Chan $+(%Alicia_File,Chan.txt) 
  /set %Admin $+(%Alicia_File,Admin.txt) 
  /set %Reg $+(%Alicia_File,Registro.txt) 
  /set %ajoin $+(%Alicia_File,AutoJoin.txt) 

  /**
    Esta parte es para la IP y nick.
    */
  /set %Bloqueos $+(%Alicia_File,Bloqueos.txt)

  /**
    Para las salas donde se chequeara la IP y los Nick. 
    */
  /set %Chan_1 #world_lesbians 
  /set %Chan_2 #jovenes_lesbianas 
  /set %Chan_3 #las_locas_del_coño

  /** 
    Para el flood. 
    */
  /set %No_Flood OFF

  /**
    Ajusta el motivo a cómo te guste.
    */
  /set %Motivo 4«1-12Normas1-4» 5No Permitida la entrada de menores.12 Derechos reservados en la sala $chan 

  /**
    El bot creara la carpeta "Datos". Luego automaticamente irá añadiendo "Chan.txt", "Registro.txt" y las demás.
    */
  if ($exists(%Alicia_File) != $true) { /mkdir %Alicia_File }

  /**
    Esto es para el reinicio del archivo, se cargará solo al mandar un mensaje. 
    Solo lo puedes usar si es que has cambiado algo del archivo desde un editor.
    */
  elseif ($1 == Script) { /load -rs scripts\ $+ $nopath($script) }

  /** 
    Aqui se registrara todo lo que se haga con los comandos.
    Solo comandos del bot, nada de chats, charlas o etc. 
    Solo quieres pruebas de quién hizo el llamado a los comandos y nada más.
    */
  elseif ($1 == Reg) { /writeini %Reg $asctime(dd/mm/yyyy) $+([,$asctime(hh:nn:sstt zzz),]) •·• $2- }
  
  elseif ($1 == AutoJoin) {
    /inc -u300 %ajoin_lineas 1
    while (%ajoin_lineas <= $lines(%ajoin)) {
      if (%ajoin_segundos == $null) { /set -u60 %ajoin_segundos 5 }
      if ($me !ison $read(%ajoin,%ajoin_lineas)) { 
        /timer 1 %ajoin_segundos /join -n $read(%ajoin,%ajoin_lineas) 
        /set -u60 %ajoin_segundos $calc((%ajoin_segundos) + 5) 
      }
      /inc %ajoin_lineas
    }
    .unset %ajoin_*
  }

  elseif ($1 == Lista) {
    if ($exists(%ajoin) == $true) { /privmsg $2 AutoJoin: | .play $2 %ajoin 1500 }
    else { /privmsg $2 Lista de AutoJoin No existe... }
  }
}

ctcp ^*:*:*:{ 
  if (%ctcpflood == $null) { /inc -u10 %ctcpflood 1 } 
  elseif (%ctcpflood != $null) { 
    /ignore -u10 $nick 
    /notice $me Ignorando a $nick por 10seg. Motivo: Muchos ctcpflood.
    $Alicia( Reg, [Ignore] Ignoré a $nick por 10seg. Motivo: Muchos ctcpflood.)
  } 
}

On 1:join:#: { 
  if ($me isop $chan) {
    if (ov isin $readini(%Chan, $chan, $nick)) { /mode $chan +ov $nick $nick }
    elseif (v isin $readini(%Chan, $chan, $nick)) { /mode $chan +v $nick }
    elseif ($chan == %Chan_1) || ($chan == %Chan_2) || ($chan == %Chan_3) {
      if ($readini(%Bloqueos, IPs, $address($nick, 2)) != $null) {
        /ban -ku3600 $chan $nick 2 Advertencias [IP Prohibida:1.::.12 $address($nick, 2) 1.::.]  
      }
      elseif ($readini(%Bloqueos, Nick, $nick) != $null) {
        /ban -ku3600 $chan $nick 2 Advertencias [Nick Prohibido:1.::.12 $nick 1.::.] 
      }
      else { /halt }
    }
  }
}

On 1:connect: { 
  $Alicia(AutoJoin) 
}

/**
  Esta es para el privado y los channels
  en dado caso de que algo falle, tienes mucha forma de arreglarlo.  
  */

on 1:text:!Ayuda *:*: {
  if ($1 == !Ayuda) {
    if (%Ay1 [ $+ [ $nick ] ] != $null) { /halt } 
    else { 
      /inc -z %Ay1 $+ $nick 30
      /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 2Estos comandos solo funcionan en la sala! No en el privado
      /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 12!Invi nick (1Para invitar a la sala). 12!Nivel (1Para saber tu nivel). 12!Op (1Para dar(te) @). 12!Deop (1Para quitar(te) @). 12!Kick nick motivo (1Para expulsar, el motivo es opcional). 
      /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 12!Ban nick (1Banear a un user que ande haciendo cosas que no debe). 12!UnBan (1Para quitar(te) un ban). 12!kb nick motivo (1Es lo mismo que !Ban y !Kick, solo que juntos. El motivo es opcional). 
      /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 12!Hop (Para hacer un salir y volver a entrar a la sala). 12!Flood ON/OFF (Para proteger la sala de ataques de clones, o simplemente mantener el balance)
      if ($level($nick) >= 5) {
        /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 10Root Estos comandos funcionan dentro de la sala y en el privado.
        /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 12!Join #sala clave (1Para entrar a otra sala, la clave es solo en caso de que la sala sea privada). 12!Part #sala (1Para salir de la sala).
        /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 12!Nick (1Para bloquear a un nick de la sala. Ej: !Nick $nick / !Nick Del $nick $+ ). 12!IP (1Para bloquear una ip. Ej: !IP $address($nick, 2) / !IP Del $address($nick, 2) $+ ).
        /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick Solo se puede usar en la sala -> 12!Access o 12!Acceso (1Es para dar poder en tu sala, puedes poner "10!Access Mod $nick $+ " y el bot te hará caso en los comandos, siempre que entres podrás subir o bajar haciendo !Op y !Deop sin necesidad de CHaN).
      }
    }
    /unset %Ay2 | /halt
  }
}

on 5:text:!Nick *:*: {
  if ($1 == !Nick) {
    if ($2 !== $null) {
      if ($readini(%Bloqueos, Nick, $2) != $null) { /privmsg $iif($nick ison $chan, $chan, $nick) Lo siento, pero el nick " $+ $2 $+ " está en la lista. }
      else {
        /writeini %Bloqueos Nick $2 $2
        /privmsg $iif($nick ison $chan, $chan, $nick) $2 fue añadido a la lista de nick bloqueados.
      }
    }
    elseif ($2 == Del) {
      if ($readini(%Bloqueos, Nick, $3) == $null) { /privmsg $iif($nick ison $chan, $chan, $nick) Lo siento, pero " $+ $3 $+ " no está en la lista. }
      else {
        /remini %Bloqueos Nick $3
        /privmsg $iif($nick ison $chan, $chan, $nick) $3 fue eliminado de la lista de nick bloqueados.
      }
    }
    else { /privmsg $iif($nick ison $chan, $chan, $nick) Debes poner !Nick $nick para añadir o !Nick Del $nick para borrar. }
    /halt
  }
}

on 5:text:!IP *:*: {
  if ($1 == !IP) {
    if ($2 !== $null) {
      if (*!*@ isin $2) {
        if ($2 != $null) { /privmsg $iif($nick ison $chan, $chan, $nick) Lo siento, pero la IP $2 está en la lista. }
        else {
          /writeini %Bloqueos IP $2 $asctime(dd/mmm/yyyy hh:nntt zzz)
          /privmsg $iif($nick ison $chan, $chan, $nick) $2 fue añadido a la lista de IP bloqueadas.
        }
      }
      else { 
        if ($address($3, 2) == $true) {
          if ($readini(%Bloqueos, IP, $address($2, 2)) != $null) { /privmsg $iif($nick ison $chan, $chan, $nick) Lo siento, pero la IP $2 está en la lista. }
          else {
            /writeini %Bloqueos IP $address($2, 2) $asctime(dd/mmm/yyyy hh:nntt zzz)
            /privmsg $iif($nick ison $chan, $chan, $nick) $address($2, 2) fue añadido a la lista de IP bloqueadas.
          }
        }
        else { /privmsg $iif($nick ison $chan, $chan, $nick) Te recuerdo que tienes que poner una IP y solo se puede usar el host. Ej: *!*@host }
      }
    }
    elseif ($2 == Del) {
      if ($3 == $null) { /privmsg $iif($nick ison $chan, $chan, $nick) Lo siento, pero $3 no está en la lista. }
      else {
        /remini %Bloqueos Nick $3
        /privmsg $iif($nick ison $chan, $chan, $nick) $3 fue eliminado de la lista de IP bloqueadas.
      }
    }
    else { /privmsg $iif($nick ison $chan, $chan, $nick) Debes poner !IP *!*@host para añadir o !IP Del *!*@host para borrar. }
    /halt
  }
}

on 5:text:!Ajoin *:*: {
  if ($1 == !Ajoin) { 
    if ($2 == lista) { $Alicia(Lista, $nick) }
    elseif ($2 == ajoin) { $Alicia(AutoJoin) }
    elseif ($2 == add) {
      if ($3 == $null) { /privmsg $iif($nick ison $chan, $chan, $nick) Dame una sala para entrar. } 
      else {
        if ($read(%ajoin,w,#$3) == $null) { 
          /write %ajoin #$3-4 
          /privmsg $iif($nick ison $chan, $chan, $nick) Listo, la sala 12 $+ #$3 $+  añadida en mi archivo.
          if ($me !ison $3) { /join -n #$3-4 }
        }
        else { /privmsg $iif($nick ison $chan, $chan, $nick) Sala12 #$3 Si esta en mi archivo. }
      }
    }
    elseif ($2 == Del) {
      if ($3 == $null) { /privmsg $iif($nick ison $chan, $chan, $nick) Dame una sala para entrar. } 
      else {
        if ($read(%ajoin,w,#$3) != $null) { 
          .write -ds $+ $read(%ajoin,w,#$3) %ajoin
          /privmsg $iif($nick ison $chan, $chan, $nick) Listo, la sala12 #$3 eliminada de mi archivo. 
          if ($me ison $3) { /part #$3 Chao, eliminada de mi archivo. }
        }
        else { /privmsg $iif($nick ison $chan, $chan, $nick) Sala12 #$3 No esta en mi archivo. }
      }
    }
    else { /privmsg $iif($nick ison $chan, $chan, $nick) Puedes usar 12Lista/12ajoin/12Add/12Del. }
    /halt
  }
}

on 5:text:!Join *:*: {
  if ($1 == !J) { 
    if ($2 == $null) { /privmsg $iif($nick ison $chan, $chan, $nick) !J Sala } 
    else { 
      /join -n #$2
      $Alicia( Auto, [JOIN] $nick Hizo $1 #$2 $3) 
    }
    /halt
  }
}

on 5:text:!Part *:*: {
  if ($1 == !P) { 
    if ($2 == $null) { 
      if ($nick !ison $chan) { /privmsg $iif($nick ison $chan, $chan, $nick) Lo siento, comando mal ejecutado. 12!P #Sala }
      else { 
        /part $chan uy me fuiiii =)
        $Alicia( Auto, [Part] $nick Hizo $1 $chan)
      }
    } 
    else { 
      /part #$2 Adiós =) $3-
      $Alicia( Auto, [Part] $nick Hizo $1 #$2 $3-)
    } 
    /halt
  }
}

/**
  Para la Channels.
  En dado caso que algo falle, se debe revisar cada espacio y cada comando.
  Comunicate con ViCoM enviandole un MeMo, puedes usar 
  "/msg MeMo send ViCoM Necesito ayuda, he encontrado un fallo."
  */
on 1:text:!Invi *:#: {
  if ($1 == !Invi) {
    if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) || ($nick isop $chan) {
      if ($2 == $null) { /privmsg $chan $1 NiCK. } 
      else { 
        if ($me isop $chan) { /invite $2 $chan } 
        /notice $2 $nick Te ha invitado a $chan / $nick Has invited you to $chan 
      }
    }
    /halt
  }
}

on 1:text:!Nivel *:#: {
  if ($1 == !Nivel) {
    if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) || ($nick isop $chan) {
      if ($level($nick) >= 5) { /privmsg $chan Eres 10Root }
      elseif (ov isin $readini(%Chan, $chan, $nick)) { /privmsg $chan Eres 12Mod } 
      elseif (o isincs $readini(%Chan, $chan, $nick)) { /privmsg $chan Eres 12Voice } 
      else { /privmsg $chan Eres un @ =) }
    }
    /halt
  }
}

on 1:text:!Op *:#: {
  if ($1 == !Op) {
    if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) || ($nick isop $chan) {
      if ($me isop $chan) {
        if ($2 == $null) { /mode $chan +ov $nick $nick } 
        else { /mode $chan +ooovvv $2-4 $2-4 | /mode $chan +ooovvv $5-7 $5-7 } 
      }
    }
    /halt
  }
}

on 1:text:!Deop *:#: {
  if ($1 == !Deop) {
    if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) || ($nick isop $chan) {
      if ($me isop $chan) {
        if ($2 == $null) { /mode $chan -o+v $nick $nick } 
        elseif ($me isin $2-7) { /halt }
        else { /mode $chan -ooovvv $2-4 $2-4 | /mode $chan -ooovvv $5-7 $5-7 } 
      }
    }
    /halt
  }
}

on 1:text:!Kick *:#: {
  if ($1 == !Kick) {
    if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) || ($nick isop $chan) {
      if ($me isop $chan) {
        if ($2 == $null) { /privmsg $chan Lo siento $nick $+ , debes darme un nick para expulsar. }
        elseif ($2 isop $chan) || (o isin $readini(%Chan, $chan, $2)) { /privmsg $chan Lo siento $nick $+ , $2 tiene @ en está sala. }
        else {
          /kick $chan $2 %Motivo
          $Alicia( Auto, [Kick] $nick -> en $chan hizo $1 a $2 $3-)
        }
      }
      else { /privmsg $chan Lo siento $nick $+ , no tengo @. }
    }
    /halt
  }
}

on 1:text:!Ban *:#: {
  if ($1 == !Ban) {
    if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) || ($nick isop $chan) {
      if ($me isop $chan) {
        if ($2 == $null) { /privmsg $chan Lo siento $nick $+ , debes darme un nick para banear. }
        elseif ($2 isop $chan) || (o isin $readini(%Chan, $chan, $2)) { /privmsg $chan Lo siento $nick $+ , $2 tiene @ en está sala. }
        else { 
          /ban -u300 $chan $2 2
          $Alicia( Auto, [Ban] $nick -> en $chan hizo $1 a $2)
        }
      }
      else { /privmsg $chan Lo siento $nick $+ , no tengo @. }
    }
    /halt
  }
}

on 1:text:!UnBan *:#: {
  if ($1 == !UnBan) {
    if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) || ($nick isop $chan) {
      if ($me isop $chan) {
        if ($2 == $null) { /set -u10 %Ban_User $nick } 
        else { /set -u10 %Ban_User $2 }
        /set -u10 %Ban_1 %Ban_User $address(%Ban_User,2) 
        /mode $chan -bb %Ban_1 
      }
      else { /privmsg $chan Lo siento $nick $+ , no tengo @. }
    }
    /halt
  }
}

on 1:text:!kb *:#: {
  if ($1 == !kb) {
    if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) || ($nick isop $chan) {
      if ($me isop $chan) {
        if ($2 == $null) { /privmsg $chan Lo siento $nick $+ , debes darme un nick para expulsar y banear. }
        elseif ($2 isop $chan) || (o isin $readini(%Chan, $chan, $2)) { /privmsg $chan Lo siento $nick $+ , $2 tiene @ en está sala. }
        else { 
          .ban -ku300 $chan $2 2 %Motivo
          $Alicia( Auto, [Kick_Ban] $nick -> en $chan hizo $1 a $2 $3-) 
        } 
      }
      else { /privmsg $chan Lo siento $nick $+ , no tengo @. }
    }
    /halt
  }
}

on 1:text:!Hop *:#: {
  if ($1 == !Hop) { 
    if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) {
      /hop -cn $chan Saltito 
      $Alicia( Auto, [HOP] $nick Hizo $1 en $chan) 
    }
    /halt
  }
}

on 1:text:!Acceso *:#: {
  if ($1 == !Access) {
    if ($level($nick) >= 5) || (o isincs $readini(%Chan, $chan, $nick)) {
      if ($2 == Mod) { 
        if ($level($nick) >= 5) { 
          if ($3 == $null) { /privmsg $iif($nick ison $chan, $chan, $nick) $1-2 nick } 
          else {
            if ($readini(%Chan, $chan, $3) == $null) || (o !isin $readini(%Chan, $chan, $nick)) {
              /writeini %Chan $chan $3 ov 
              $Alicia( Auto, [Access] $nick añadio a $3 como un Mod para la sala $chan)
              /privmsg $chan Nivel de12 $3 fue actualizado a 12Mod.
            }
            else { /privmsg $chan Nivel de12 $3 es de 12Mod. }
          }
        }
        /halt
      }
      elseif ($2 == Voice) { 
        if ($level($nick) >= 5) || (o isincs $readini(%Chan, $chan, $nick)) { 
          if ($3 == $null) { /privmsg $iif($nick ison $chan, $chan, $nick) $1-2 nick } 
          else {
            if ($readini(%Chan, $chan, $3) == $null) || (v !isin $readini(%Chan, $chan, $nick)) {
              /writeini %Chan $chan $3 v 
              $Alicia( Auto, [Access] $nick añadio a $3 como un Voice para la sala $chan)
              /privmsg $chan Nivel de12 $3 fue actualizado a 12Voice.
            }
            else { /privmsg $chan Nivel de12 $3 es de 12Voice. }
          }
        }
        /halt
      }
      elseif ($2 == Borrar) {  
        if ($level($nick) >= 5) { 
          if ($3 == $null) { /privmsg $chan $1-2 nick } 
          else {
          if ($readini(%Chan, $chan, $3) != $null) {
              /remini %Chan $chan $3 
              /privmsg $chan Nivel de12 $3 fue Borrado. 
              $Alicia( Auto, [Access] $nick borrando a $3 de la sala $chan)
            }
            else { /privmsg $iif($nick ison $chan, $chan, $nick) Nivel de12 $3 es Desconocido. } 
          }
        }
        /halt
      }
      else { /privmsg $chan $1 (12Mod/10Voice/04Borrar) nick }
    }
    /halt
  }
}

;Los comandos.
on *:text:*:*: {
  /Alicia
  if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) || ($nick isop $chan) {
    /**
      Aquí puedes poner nuevos comandos, los que ya tenias por ejemplo.
      */

  }
  else {
    if ($me isop $chan) {
      if (%No_Flood == ON) {
        if ($nick !isvoice $chan) || ($readini(%Chan, $chan, $nick) == $null) {
          /inc -u4 %Conteo_De_Flood $+ $nick 1
          if (%Conteo_De_Flood [ $+ [ $nick ] ] >= 6) {
            /ban -u15 $chan $nick 2
            /ignore -u15 $nick
            $Alicia( Reg, [Flood] Ban dado a $nick en $chan por 15seg.)
          }
        }
        else { /halt }
      }
    }
  }

}


On 1:invite:#: { 
  if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) { /join -n $chan } 
  else { 
    if (%Aviso [ $+ [ $nick ] ] == $null) {
      /set -u30 %Aviso $+ $nick Me invito
      .notice $nick Entraré después de un ratito. / I'll enter after a while. 
    } 
  } 
  $Alicia( Reg, [Invite] me invitaron a en $chan por $nick)
}

On *:deop:#:{ 
  if ($opnick == $me) && ($nick == $me) { /halt } 
  elseif ($opnick == $me) && ($nick != $me) { 
    if (o isin $usermode) { /mode $chan +ov $me $me }
    else { /msg chan OP $chan $me }
    $Alicia( Reg, [Deop] me quitaron el @ en $chan por $nick)
  } 
}

On *:ban:#: { 
  if ($bnick == $me) || ($banmask iswm $address($me,5)) { 
    if (o isincs $usermode) || ($me isop $chan) { .mode $chan +v-bo $me $banmask $nick } 
    $Alicia( Reg, [Ban] me baneron en $chan por $nick)
  }
}
