/**
  Archivo Alicia.mrc
  Puedes copiarlo y ponerlo en la parte de mIRC donde dice "Remote"

  Siempre veras todo lo que está pasando en el archivo "Registro.txt"
  Cada comando que se utilice, sabrás quién lo hizo y el día y la hora.
  Puede ser un metodo genial si pasa algo y quieres tener prueba de quién causo lo que esta pasando.
*/

alias -l Alicia {
  ;Puedes cambiar la ruta si quieres. Pero está sera la predestinada de momento.
  /set %Alicia_File $+(scripts\Datos\) 

  ;Es donde se escribira algunas cosas que ayudara al bot a saber quién es quién.
  /set %Chan $+(%Alicia_File,Chan.txt) 
  /set %Admin $+(%Alicia_File,Admin.txt) 
  /set %Reg $+(%Alicia_File,Registro.txt) 
  /set %ajoin $+(%Alicia_File,AutoJoin.txt) 

  ;Ajusta el motivo a cómo te guste.
  /set %Motivo 4«1-12Normas1-4» 5No Permitida la entrada de menores.12 Derechos reservados en la sala $chan 

  ;El bot creara la carpeta "Datos". Luego automaticamente irá añadiendo "Chan.txt", "Registro.txt" y las demás.
  if ($exists(%Alicia_File) != $true) { /mkdir %Alicia_File }

  ;Esto es para el reinicio del archivo, se cargará solo al mandar un mensaje. 
  ;Solo lo puedes usar si es que has cambiado algo del archivo desde un editor.
  elseif ($1 == Script) { /load -rs scripts\ $+ $nopath($script) }

  ;Aqui se registrara todo lo que se haga con los comandos.
  ;Solo comandos del bot, nada de chats, charlas o etc. 
  ;Solo quieres pruebas de quién hizo el llamado a los comandos y nada más.
  elseif ($1 == Reg) { /writeini %Reg $asctime(dd/mm/yyyy) $+([,$asctime(hh:nn:sstt zzz),]) •·• $2- }
  
  ;Este es el autojoin, es un mecanismo para hacer que el bot entré solo a sus canales.
  ;Te recomiendo no jugar con está parte, es algo delicada.
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

  ;Es para la lista del autojoin, te dirá todas las salas que tengas ahí, o si no tienes alguna.
  elseif ($1 == Lista) {
    if ($exists(%ajoin) == $true) { /privmsg $2 AutoJoin: | .play $2 %ajoin 1500 }
    else { /privmsg $2 Lista de AutoJoin No existe... }
  }
}

;Esta parte es para limitar los ctcp, es por seguridad y además para prevenir el lag.
ctcp ^*:*:*:{ 
  if (%ctcpflood == $null) { /inc -u10 %ctcpflood 1 } 
  elseif (%ctcpflood != $null) { 
    /ignore -u10 $nick 
    /notice $me Ignorando a $nick por 10seg. Motivo: Muchos ctcpflood.
    $Alicia( Reg, Ignoré a $nick por 10seg. Motivo: Muchos ctcpflood.)
    /halt 
  } 
}

;El bot mirara a ver quién entro, luego le dará su @ si es que está registrado.
On 1:join:#: { 
  if ($me isop $chan) {
    if (ov isin $readini( %Chan, $chan, $nick)) { /mode $chan +ov $nick $nick }
    elseif (v isin $readini( %Chan, $chan, $nick)) { /mode $chan +v $nick }
  }
}

On 1:connect: { 
  $Alicia(AutoJoin) 
}

;Los comandos.
on *:text:*:*: {
  /Alicia
  if ($1 == !ajoin) { 
    if ($level($nick) >= 5) {
      if ($2 == lista) { $Alicia(Lista, $nick) }
      elseif ($2 == ajoin) { $Alicia(AutoJoin) }
      elseif ($2 == add) {
        if ($3 == $null) { /privmsg $nick Dame una sala para entrar. } 
        else {
          if ($read(%ajoin,w,#$3) == $null) { 
            /write %ajoin #$3-4 
            /privmsg $nick Listo, la sala 12 $+ #$3 $+  añadida en mi archivo.
            if ($me !ison $3) { /join -n #$3-4 }
          }
          else { /privmsg $nick Sala12 #$3 Si esta en mi archivo. }
        }
      }
      elseif ($2 == Del) {
        if ($3 == $null) { /privmsg $nick Dame una sala para entrar. } 
        else {
          if ($read(%ajoin,w,#$3) != $null) { 
            .write -ds $+ $read(%ajoin,w,#$3) %ajoin
            /privmsg $nick Listo, la sala12 #$3 eliminada de mi archivo. 
            if ($me ison $3) { /part #$3 Chao, eliminada de mi archivo. }
          }
          else { /privmsg $nick Sala12 #$3 No esta en mi archivo. }
        }
      }
      else { /privmsg $nick Puedes usar 12Lista/12ajoin/12Add/12Del. }
      /halt
    }
  }
  if ($level($nick) >= 5) || (o isin $readini( %Chan, $chan, $nick)) || ($nick isop $chan) {
    if (%Nivel [ $+ [ $address($nick,2) ] ] == $null) {
      /set -u2 %Nivel $+ $address($nick,2) ^
      if ($1 == !Ayuda) {
        if (%Ay1 [ $+ [ $nick ] ] != $null) { /halt } 
        else { 
          /inc -z %Ay1 $+ $nick 30
          /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 2Estos comandos solo funcionan en la sala! No en el privado
          /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 12!Invi nick (1Para invitar a la sala). 12!Nivel (1Para saber tu nivel). 12!Op (1Para dar(te) @). 12!Deop (1Para quitar(te) @). 12!Kick nick motivo (1Para expulsar, el motivo es opcional). 
          /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 12!Ban nick (1Banear a un user que ande haciendo cosas que no debe). 12!UnBan (1Para quitar(te) un ban). 12!kb nick motivo (1Es lo mismo que !Ban y !Kick, solo que juntos. El motivo es opcional). 12!Hop (Para hacer un salir y volver a entrar a la sala). 
          if ($level($nick) >= 5) {
            /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 10Root Estos comandos funcionan dentro de la sala y en el privado.
            /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick 12!J #sala clave (1Para entrar a otra sala, la clave es solo en caso de que la sala sea privada). 12!P #sala (1Para salir de la sala).
            /inc %Ay2 | /timer 1 %Ay2 /privmsg $nick Solo se puede usar en la sala -> 12!Access o 12!Acceso (1Es para dar poder en tu sala, puedes poner "!Access Mod $nick $+ " y el bot te hará caso en los comandos, siempre que entres podrás subir o bajar haciendo !Op y !Deop sin necesidad de CHaN. Además podrás controlarlo sin necesidad de @. Es recomendado para las personas que confias. Además te dará @ al entrar a la sala.12)
          }
        }
        /unset %Ay2 | /halt
      }

      elseif ($1 == !Invi) {
        if ($nick ison $chan) {
          if ($2 == $null) { /privmsg $chan $1 NiCK. } 
          else { 
            if ($me isop $chan) { /invite $2 $chan } 
            /notice $2 $nick Te ha invitado a $chan / $nick Has invited you to $chan 
          }
          /halt
        }
      }
      elseif ($1 == !Nivel) {
        if ($nick ison $chan) {
          if ($level($nick) >= 5) { /privmsg $chan Eres 10Root }
          elseif (ov isin $readini( %Chan, $chan, $nick)) { /privmsg $chan Eres 12Mod } 
          elseif (o isincs $readini( %Chan, $chan, $nick)) { /privmsg $chan Eres 12Voice } 
          /halt
        }
      }

      elseif ($1 == !Op) {
        if ($nick ison $chan) {
          if ($me isop $chan) {
            if ($2 == $null) { /mode $chan +ov $nick $nick } 
            else { /mode $chan +ooovvv $2-4 $2-4 | /mode $chan +ooovvv $5-7 $5-7 } 
          }
          /halt
        }
      }

      elseif ($1 == !Deop) {
        if ($nick ison $chan) {
          if ($me isop $chan) {
            if ($2 == $null) { /mode $chan -o+v $nick $nick } 
            elseif ($me isin $2-7) { /halt }
            else { /mode $chan -ooovvv $2-4 $2-4 | /mode $chan -ooovvv $5-7 $5-7 } 
          }
          /halt
        }
      }

      elseif ($1 == !Kick) {
        if ($nick ison $chan) {
          ;Parte 1: Si es el bot tiene @ continuara, sino se ira a la parte 2.
          if ($me isop $chan) {
            if ($2 == $null) { /privmsg $chan Lo siento $nick $+ , debes darme un nick para expulsar. }
            elseif ($2 isop $chan) || (o isin $readini( %Chan, $chan, $2)) { /privmsg $chan Lo siento $nick $+ , $2 tiene @ en está sala. }
            else {
              /kick $chan $2 %Motivo
              $Alicia( Auto, [Kick] $nick -> en $chan hizo $1 a $2 $3-)
            }
          }
          ;Parte 2: El bot dejara en claro que no tiene @ y que no puede hacer mucho.
          else { /privmsg $chan Lo siento $nick $+ , no tengo @. }
          /halt
        }
      }

      elseif ($1 == !Ban) {
        if ($nick ison $chan) {
          ;Parte 1: Si es el bot tiene @ continuara, sino se ira a la parte 2.
          if ($me isop $chan) {
            if ($2 == $null) { /privmsg $chan Lo siento $nick $+ , debes darme un nick para banear. }
            elseif ($2 isop $chan) || (o isin $readini( %Chan, $chan, $2)) { /privmsg $chan Lo siento $nick $+ , $2 tiene @ en está sala. }
            else { 
              /ban -u300 $chan $2 2
              $Alicia( Auto, [Ban] $nick -> en $chan hizo $1 a $2)
            }
          }
          ;Parte 2: El bot dejara en claro que no tiene @ y que no puede hacer mucho.
          else { /privmsg $chan Lo siento $nick $+ , no tengo @. }
          /halt
        }
      }

      elseif ($1 == !UnBan) {
        if ($nick ison $chan) {
          ;Parte 1: Si es el bot tiene @ continuara, sino se ira a la parte 2.
          if ($me isop $chan) {
            if ($2 == $null) { /set -u10 %Ban_User $nick } 
            else { /set -u10 %Ban_User $2 }
            /set -u10 %Ban_1 %Ban_User $address(%Ban_User,2) 
            /mode $chan -bb %Ban_1 
          }
          ;Parte 2: El bot dejara en claro que no tiene @ y que no puede hacer mucho.
          else { /privmsg $chan Lo siento $nick $+ , no tengo @. }
          /halt
        }
      }

      elseif ($1 == !kb) {
        if ($nick ison $chan) {
          ;Parte 1: Si es el bot tiene @ continuara, sino se ira a la parte 2.
          if ($me isop $chan) {
            if ($2 == $null) { /privmsg $chan Lo siento $nick $+ , debes darme un nick para expulsar y banear. }
            elseif ($2 isop $chan) || (o isin $readini( %Chan, $chan, $2)) { /privmsg $chan Lo siento $nick $+ , $2 tiene @ en está sala. }
            else { 
              .ban -ku300 $chan $2 2 %Motivo
              $Alicia( Auto, [Kick_Ban] $nick -> en $chan hizo $1 a $2 $3-) 
            } 
          }
          ;Parte 2: El bot dejara en claro que no tiene @ y que no puede hacer mucho.
          else { /privmsg $chan Lo siento $nick $+ , no tengo @. }
          /halt
        }
      }

      elseif ($1 == !Hop) { 
        if ($nick ison $chan) {
          ;Parte 1: Mirara si tiene permiso para hacer este comando.
          if ($level($nick) >= 5) || (o isin $readini(%Chan, $chan, $nick)) {
            /hop -cn $chan Saltito 
            $Alicia( Auto, [HOP] $nick Hizo $1 en $chan) 
          }
          /halt
        }
      }

      elseif ($1 == !J) { 
        if ($level($nick) >= 5) {
          if ($2 == $null) { /privmsg $nick !J #Sala } 
          else { 
            /join -n #$2 $3
            $Alicia( Auto, [JOIN] $nick Hizo $1 #$2 $3) 
          } 
        }
        .halt
      }

      elseif ($1 == !P) { 
        if ($level($nick) >= 5) {
          if ($2 == $null) { 
            if ($nick !ison $chan) { /privmsg $nick Lo siento, comando mal ejecutado. 12!P #Sala }
            else { 
              /part $chan uy me fuiiii =)
              $Alicia( Auto, [Part] $nick Hizo $1 $chan)
            }
          } 
          else { 
            /part #$2 Adiós =) $3-
            $Alicia( Auto, [Part] $nick Hizo $1 #$2 $3)
          } 
        }
        .halt
      }

      elseif ($1 == !Access) || ($1 == !Acceso) {
        if ($level($nick) >= 5) || (o isincs $readini( %Chan, $chan, $nick)) {
          if ($2 == Mod) { 
            if ($level($nick) >= 5) { 
              if ($3 == $null) { /privmsg $nick $1-2 nick } 
              else {
                if ($readini( %Chan, $chan, $3) == $null) || (o !isin $readini( %Chan, $chan, $nick)) {
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
            if ($level($nick) >= 5) || (o isincs $readini( %Chan, $chan, $nick)) { 
              if ($3 == $null) { /privmsg $nick $1-2 nick } 
              else {
                if ($readini( %Chan, $chan, $3) == $null) || (v !isin $readini( %Chan, $chan, $nick)) {
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
              if ($readini( %Chan, $chan, $3) != $null) {
                  /remini %Chan $chan $3 
                  /privmsg $chan Nivel de12 $3 fue Borrado. 
                  $Alicia( Auto, [Access] $nick borrando a $3 de la sala $chan)
                }
                else { /privmsg $nick Nivel de12 $3 es Desconocido. } 
              }
            }
            /halt
          }
          else { /privmsg $chan $1 (12Mod/10Voice/04Borrar) nick }
        }
      }

    }
    /halt
  }

  ;Está será la parte para el flood.
  else {
    if ($me isop $chan) {
      /inc -u4 %Lineas_ $+ $nick 1
      if (%Lineas_ [ $+ [ $nick ] ] == 2) {
        /privmsg $chan Aviso 1: $nick porfa no escribas tanto!
        $Alicia( Reg, [Flood] Aviso 1 dado a $nick en $chan)
      }
      elseif (%Lineas_ [ $+ [ $nick ] ] == 3) {
        /privmsg $chan Aviso 2: $nick ultimo aviso...
        $Alicia( Reg, [Flood] Aviso 2 dado a $nick en $chan)
      }
      elseif (%Lineas_ [ $+ [ $nick ] ] >= 4) {
        /ban -u15 $chan $nick 2
        /privmsg $chan Aviso 3: $nick aguantate 15seg para volver a hablar =)
        $Alicia( Reg, [Flood] Aviso 3 dado a $nick en $chan y baneado por 15seg.)

      }
    }
  }
}

On 1:invite:#: { 
  if ($level($nick) >= 5) || (o isin $readini( %Chan, $chan, $nick)) { /join -n $chan } 
  else { .notice $nick Entraré después de un ratito. / I'll enter after a while. } 
  $Alicia( Reg, [Invite] me invitaron a en $chan por $nick)
}

On 1:OP:#: { 
  if ($opnick == $me) { 
    if ($banmask iswm $address($me,5)) { /mode $chan -b $banmask } 
  } 
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


