/**
  Archivo oficial, creado el 15 de agosto del 2020.
  Actualizado con el tiempo, y mejorado.
  Optimizado de una nueva forma y sin errores.

  En el "alias -l Main" puede cambiar:
    • La Ruta; donde se almanecera los datos. 
    • La Pass; es importante que la cambies
        porque con esta clave es que te identificaras como RooT.
    • El Prefix
  */

alias -l Main {
  /set %file $+(scripts\Juego\,$network,\)
  /set %ajoin $+(%file,ajoin.txt)
  /set %pass Pass

  if ($1 == Main) { 
    /load -rs scripts\Koy.mrc
  } 

  elseif ($1 == info) {
    if ($exists(%ajoin) == $true) { /msg $2 Archivo de $nopath(%ajoin) $+ ! | .play $2 %ajoin 1500 }
    else { /msg $2 Archivo de $nopath(%ajoin) no encontrado! } 
  }

  elseif ($1 == ajoin) {
    /inc -u300 %ajoin_lineas 1
    while (%ajoin_lineas <= $lines(%ajoin)) {
      if (%ajoin_segundos == $null) { /set -u60 %ajoin_segundos 5 }
      if ($me !ison $read(%ajoin,%ajoin_lineas)) { 
        .timer 1 %ajoin_segundos /join -n $read(%ajoin,%ajoin_lineas) 
        /set -u60 %ajoin_segundos $calc((%ajoin_segundos) + 5) 
      }
      /inc %ajoin_lineas
    }
    /unset %ajoin_*
  }
}
On *:start: {
  .echo -s  [Archivo] 10Koy Version12 2. Cargado correctamente
  if (%Aviso_load != $null) { 
    /msg %Aviso_load 10Archivo $nopath($script) cargado correctamente!
    /unset %Aviso_*
  }
}
On 1:connect: { 
  if (Chateamos isin $network) { 
    /ghost ProTeo:OtorrinoKoy 
    /nick ProTeo:OtorrinoKoy 
    /timer 1 5 .mode Proteo +Rn 
  } 
  elseif (VicioChat isin $network) {
    /msg nick recover unu NoRobesLaClave
    /nick unu 
    /msg nick identify NoRobesLaClave
    /mode unu +BI
  }
  else { /nick Koy }
  $Main(ajoin) 
}
On 1:disconnect: { 
  /Main
  if ($nick == $me) {
    .unsetall 
    .mnick ProTeo!OtorrinoKoy 
    .identd on Vic 
    .partall 
    .fullname 10Vic12 ©Derechos reservados 1020201-102025
    if (Chateamos isin $server) {
      /nick ProTeo!OtorrinoKoy 
    }
    if (%Server != $null) {
      .set %Server_irc $replace($server, Terra,irc, Apolo,irc, saturno,irc, jupiter,irc, neptuno,irc, deep,irc, orion,irc)
      .server -z %Server_irc 
      .unset %Server*
    }
  } 
}
On *:invite:#: { 
  /Main 
  if ($level($nick) >= 10) || ($readini(%Saldo,$nick,OP) == +) { 
    /join -n $chan 
    /msg $chan Holis $nick :* 
  }
  else { /halt }
}
On 1:join:#: {
  /Main
  if ($readini(%Saldo,+,$chan) != on) { /halt } 
  else {  
    if (%nick_ [ $+ [ $nick ] ] == $null) {
      if ($level($nick) >= 10) || ($readini(%Saldo,$nick,OP) == +) { 
        if (o isincs $usermode) || ($me isop $chan) { 
          .mode $chan +v $nick 
          /set -z %nick_ $+ $nick 3 
        } 
      }
    }
  }
}
On *:kick:#: { 
  if ($knick == $me) { 
    if (o isincs $usermode) || ($me isop $chan) { .invite $me $chan } 
    /hop -cn $chan 
  }
}
On *:ban:#: { 
  if ($bnick == $me) || ($banmask iswm $address($me,5)) { 
    if (o isincs $usermode) || ($me isop $chan) { /mode $chan +v-bo $me $banmask $nick } 
  }
}
on *:text:!Main*:*: {
  /Main
  if ($1 == !Main) {
    if ($level($nick) >= 10) || ($readini(%Saldo,$nick,OP) == +) { 
      if ($2 == $null) {
        /set -u30 %Aviso_load $iif($nick ison $chan, $chan, $nick)
        /reseterror 
        $Main(Main) 
      }
      elseif ($2 == F) { /set %Server ON | /Quit Nos vemos. Quit:12 $nick $+  }
    } 
    /halt
  }
}
on *:text:!Log*:*: {
  /Main
  if ($1 == !log) { 
    if ($2 == in) {
      if ($3 === %pass) { 
        if ($level($nick) == 1) { .auser 300 $nick | /msg $nick Eres un RooT. } 
        else { /msg $nick Error: Tiene un nivel de 12 $+ $level($nick) $+ . }
      }
      else { /msg $nick Error: No tienes permiso. }
    }
    elseif ($2 == out) {
      if ($level($nick) == 1) { /msg $nick Error: No tienes nivel. }
      else { /ruser $nick | /msg $iif($nick ison $chan, $chan, $nick) 12 $+ $nick $+  -> Has sido borrado. } 
    }
  } 
}
on *:text:!Chan*:*: {
  /Main
  if ($1 == !Chan) { 
    if ($level($nick) >= 10) || ($readini(%Saldo,$nick,OP) == +) {
      if ($2 == $null) {
        /set -u10 %Chans $chan(1) $chan(2) $chan(3) $chan(4) $chan(5) $chan(6) $chan(7) $chan(8) $chan(9) $chan(10) $chan(11) $chan(12) $chan(13) $chan(14) $chan(15) $chan(16) $chan(17) $chan(18) $chan(19) $chan(20)
        if (%Chans != $null) { /msg $iif($nick ison $chan, $chan, $nick) Estoy en12 %Chans $+ . }
        else { /msg $iif($nick ison $chan, $chan, $nick) No me encuentro en ninguna sala ;). }
      }
      elseif ($2 == lista) { $Main(info, $nick) }
      elseif ($2 == ajoin) { $Main(ajoin) }
      elseif ($2 == sal) { 
        if ($nick ison $chan) { /part $chan } 
        else { /partall }
      }
      elseif ($2 == f) { /partall | /timer 1 10 /Main ajoin }
      elseif ($2 == hop) { 
        if ($nick ison $chan) { /hop -cn $chan 12Saltito } 
        else {
          if ($2 != $null) { /hop -cn #$2 12Saltito }
          else { /msg $iif($nick ison $chan, $chan, $nick) Especifica una sala para hacer hop... }
        }
      }

      elseif ($2 == +) {
        if ($3 == $null) { /msg $iif($nick ison $chan, $chan, $nick) Dame una sala para entrar. } 
        else {
          if ($read(%ajoin,w,#$3) == $null) { 
            /write %ajoin #$3-4 
            /writeini %Saldo + #$3 on
            /msg $iif($nick ison $chan, $chan, $nick) Listo, la sala 12 $+ #$3 $+  añadida en mi archivo.
            if ($me !ison $3) { /join -n #$3-4 }
          }
          else { /msg $nick Sala 12 $+ #$3 $+  Si esta en mi archivo. }
        }
      }

      elseif ($2 == -) {
        if ($3 == $null) { /msg $iif($nick ison $chan, $chan, $nick) Dame un sala para salir. } 
        else {
          if ($read(%ajoin,w,$3) != $null) { 
            /write -ds $+ $read(%ajoin,w,#$3) %ajoin 
            /remini %Saldo + $3
            /msg $iif($nick ison $chan, $chan, $nick) Listo, la sala 12 $+ #$3 $+  eliminada de mi archivo. 
            if ($me ison $3) { /part #$3 Chao, eliminada de mi archivo. Echo: 12 $+ $nick $+  }
          }
          else { /msg $iif($nick ison $chan, $chan, $nick) Sala 12 $+ $3 $+  No esta en mi archivo. }
        }
      }

      else { /msg $iif($nick ison $chan, $chan, $nick) Puedes usar 12Lista|12ajoin|12Sal|12F|12Hop|12+|12-. }
    }
  }
}

/**
  Archivo oficial, parte del archivo Koy.mrc
  Puedes cambiar:
    • %CanalOficial; Pon tu sala.
    • %prefix; Puedes poner cualquier prefijo ! @ . ^ & etc.
    • 
  */
alias -l Ruta {
  .set %Main $+(scripts\Juego\,$network,\)
  .set %Saldo $+(%Main,Cuenta.txt) 
  .set %Ayudante $+(%Main,Ayudante.txt)

  /set %CanalOficial #TuSala
  .set %prefix !

  if ($exists(%Main) != $true) { 
    /mkdir %Main 
    .writeini %Saldo Date Fecha $asctime(dd/mmm/yyyy hh:nntt zzz)
    .writeini %Saldo Bote Moneda 25000 
    .writeini %Saldo Bote Moneda2 25 
  }

  .set %Mone:1 Mone
  .set %Mone:2 Diamo
  .set %Moneda 03 $+ %Mone:1 $+  
  .set %Moneda2 10 $+ %Mone:2 $+   
  .set -i %Contar 5 
  .set -i %Bote_Costo 15 
  .set -i %Moneda2_Costo 1000 

  if ($1 == Reg) { 
    .writeini %Saldo $2 Hora Ultima vez usado -> $asctime(dd/mmm/yyyy hh:nntt zzz)
    .writeini %Saldo $2 Reg $3-
    .writeini %Saldo $2 Estado Activo 
    .writeini %Saldo $2 Moneda 1000 
    .writeini %Saldo $2 Moneda2 10 
    .writeini %Saldo $2 BancoMoneda 0 
    .writeini %Saldo $2 BancoMoneda2 0
    /msg $2 10Saldo 12 $+ $2 $+  puedes usar12 %prefix $+ Ayuda en la sala para más información. 
  } 

  if ($1 == Ban) { /msg $3 [10Ban] 12 $+ $2 $+  no podes jugar. Si crees que es un error ponte en contacto con un moderador. Usa "12!Ayudante". }

  if ($1 == Hora) { .writeini %Saldo $2 Hora Ultima vez conectado -> $asctime(dd/mmm/yyyy hh:nnttzzz) }

  if ($1 == User) { 
    if ($3 == Moneda) { return $bytes($readini(%Saldo, $2, Moneda), b) }
    if ($3 == Moneda2) { return $bytes($readini(%Saldo, $2, Moneda2), b) }
    if ($3 == BancoMoneda) { return $bytes($readini(%Saldo, $2, BancoMoneda), b) }
    if ($3 == BancoMoneda2) { return $bytes($readini(%Saldo, $2, BancoMoneda2), b) }
    if ($3 == Botes) { return $readini(%Saldo, $2, Botes) }
    if ($3 == Estado) { return $readini(%Saldo, $2, Estado) }
    if ($3 == Seguro) { return $readini(%Saldo, $2, Seguro) }
  } 

  Elseif ($1 == Aviso) { 
    /msg $2 10Saldo 12 $+ $2 $+  No tiene efectivo, si quieres registrarse usa 12!Reg en la sala. $&
      Le recuerdo que su nick debe de tener el modo 12+r para evitar robos o perdida de saldo. 
  }
  Elseif ($1 == Avisa) { /msg $3 10Saldo 12 $+ $2 $+  No tiene efectivo. }
  Elseif ($1 == Poco) { /msg $4 10Saldo 12 $+ $2 $+  Solo dispones de12 $bytes($readini(%Saldo, $2, $3), b) %Moneda $+ . $5- }
  
  Elseif ($1 == Saldo) {
    if ($3 == Gana) { .writeini %Saldo Bote Gana $2 } 
    elseif ($2 != $null) && ($3 != $null) && ($4 != $null) && ($5 != $null) { 
      .writeini %Saldo $2 $3 $int($calc($readini(%Saldo,$2,$3) $4 $5)) 
    } 
  }
} 


On *:text:*!Ayudante*:*: { 
  /Ruta
  if ($1 == !Ayudante) {
    if ($2 == +) || ($2 == -) {
      if ($level($nick) >= 200) {
        if ($2 == +) {
          if ($readini(%Saldo, $3, OP) == +) { /msg $iif($nick ison $chan, $chan, $nick) 10Ayudante 12 $+ $3 $+  Es un Ayudante. }
          else {
            .writeini %Saldo $3 OP +
            .write %Ayudante Ayudante: $3
            /msg $iif($nick ison $chan, $chan, $nick) 10Ayudante 12 $+ $3 $+  Es un Ayudante (Añadido).
            /msg $3 Hola usuario :D eres un Ayudante.
          }
        }
        elseif ($2 == -) {
          if ($readini(%Saldo, $3, OP) != +) { /msg $iif($nick ison $chan, $chan, $nick) 10Ayudante 12 $+ $3 $+  No es un Ayudante. }
          else {
            .remove %Saldo $3 OP
            .write -ds $+ Ayudante: $3 %Ayudante
            /msg $iif($nick ison $chan, $chan, $nick) 10Ayudante 12 $+ $3 $+  No es un Ayudante (Borrado).
          }
        }
      }
    }
    elseif ($2 == $null) {
      if ($exists(%Ayudante) != $true) { /msg $iif($nick ison $chan, $chan, $nick) 10Ayudante Lo siento, pero no tengo ningun Ayudante. }
      else { 
        /msg $iif($nick ison $chan, $chan, $nick) 10Ayudante Tip: Si quieres saber mas sobre un Ayudante, puedes usar "12!Ayudante Nick".
        .play $nick %Ayudante 1500 
      }
    }
    else {
      if ($readini(%Saldo, $2, OP) == +) { /msg $iif($nick ison $chan, $chan, $nick) 10Ayudante 12 $+ $2 $+  es un Ayudante. Puedes hacer "12/query $2 $+ " y escribirle.12 $readini(%Saldo, $2, Hora) }
      else { /msg $iif($nick ison $chan, $chan, $nick) 10Ayudante 12 $+ $2 $+  No es un Ayudante. Puedes poner "12!Ayudante". Luego asegurarte de colocar bien el nick cuando quieras saber algo. }
    }
    /halt
  }
}

On *:text:*!Ayuda*:*: { 
  /Ruta 
  if ($1 == !Ayuda) {
    if (%Ay1 [ $+ [ $nick ] ] != $null) { /halt } 
    else { 
      /inc -z %Ay1 $+ $nick 130
      /inc %Ay2 | /timer 1 %Ay2 /msg $nick 10Ayuda 12 $+ $nick
      /inc %Ay2 | /timer 1 %Ay2 /msg $nick 12!Reg Para Saldo e Banco
      /inc %Ay2 | /timer 1 %Ay2 /msg $nick 12!Bote, 10!Saldo, 12!Transferir, 10!Vender, 12!Comprar, 12!Ingresar/!Retirar, 10!Estado. 
      /inc %Ay2 | /timer 1 %Ay2 /msg $nick 12!Suerte, 10!Lapiz, 12!Regalo, 12!Elijo, y para ganar el Bote, puedes usar 12!Suerte.
      /inc %Ay2 | /timer 1 %Ay2 /msg $nick Si te quieres darte de baja, solo pon "12!Baja", le recuerdo, no me hago cargo si pierde todo por usar este comando!
      if ($level($nick) >= 200) || ($readini(%Saldo, $nick, OP) == +) {
        /inc %Ay2 | /timer 1 %Ay2 /msg $nick 10Ayudante
        /inc %Ay2 | /timer 1 %Ay2 /msg $nick 12!Reg nick Puedes registrar a otros users. 12!Estado nick 03Unban/04Ban Puedes permitir o prohibir a alguien jugar (solo se debe usar en casos extremos).
        /inc %Ay2 | /timer 1 %Ay2 /msg $nick 12!Juego Enbale/Disable Para (des)activar los juegos en la salas.
      }
      if ($level($nick) >= 200) {
        /inc %Ay2 | /timer 1 %Ay2 /msg $nick 10RooT
        /inc %Ay2 | /timer 1 %Ay2 /msg $nick 12!Log (in/out). 12!Main (F) $&
          "Puedes usar solo el !Main y reiniciara el archivo, si pones F apagar a $me $+ ". 12!Chan (12Lista|12ajoin|12Sal|12F|12Hop|12+|12-).
      }
    }
    /unset %Ay2 | /halt
  }
}

On *:text:!Juego*:#: { 
  /Ruta 
  if ($1 == !Juego) || ($1 == !Juegos) { 
    if ($level($nick) >= 200) || ($readini(%Saldo, $nick, OP) == +) { 
      if ($2 == Enable) { 
        if ($readini(%Saldo, +, $chan) == ON) { /msg $chan 10Juegos estan 03Enable. } 
        else { .writeini %Saldo + $chan ON | /msg $chan 10Juegos 03Activados... } 
      }
      elseif ($2 == Disable) { 
        if ($readini(%Saldo, +, $chan) == OFF) { /msg $chan 10Juegos estan 04Disable. } 
        else { .writeini %Saldo + $chan OFF | /msg $chan 10Juegos 04Desactivados... } 
      }
      else { 
        if ($readini(%Saldo,+,$chan) == ON) { /msg $chan 10Juegos 03Enable Para Desactivarlo usa 04Disable. } 
        else { /msg $chan 10Juegos 04Disable Para Activarlo usa 03Enable. } 
      }
    }
    /halt
  }
}
on *:text:!Baja:*: {
  /Ruta
  if ($1 == !Baja) {
    if (%Tiempo [ $+ [ $nick ] ] == $null) { 
      if ($readini(%Saldo, $nick, Reg) != $null) {
        if ($nick !ison %CanalOficial) {
          /inc -z %Tiempo [ $+ [ $nick ] ] 4
          /msg $nick 10Baja 12 $+ $nick $+  Debes ir a %CanalOficial para poder darte de baja =D.
        }
        else {
          /inc -z %Tiempo [ $+ [ $nick ] ] 4
          if (%Baja [ $+ [ $nick ] ] == $null) {
            /set -u30 %Baja [ $+ [ $nick ] ] Borrado preparado.
            /msg $chan 10Saldo 12 $+ $nick $+  Seguro que quieres darte de baja? Si es así, vuelve a escribir "12!Baja" por ultima vez! Tienes 30 segundos antes de deshacer todo el comando.
          }
          else {
            /remini %Saldo $nick
            /unset %Baja [ $+ [ $nick ] ]
            /msg $chan 10Baja 12 $+ $nick $+  Te has dado de baja! Esperamos volverte a ver por aquí =D cuídate!.
          }
        }
      }
      else { /halt }
    }
  }
}

On *:text:*:#: { 
  /Ruta 
  if ($readini(%Saldo, +, $chan) == ON) {
    if (%Tiempo [ $+ [ $nick ] ] == $null) { 
      if ($1 == %prefix $+ Alta) { 
        /inc -z %Tiempo [ $+ [ $nick ] ] 4
        if ($2 == $null) { 
          if ($readini(%Saldo, $nick, Reg) != $null) { /msg $chan 10Saldo 12 $+ $nick $+  esta Registrado. } 
          else { $Ruta(Reg, $nick, Reg por $nick $+ : $asctime(dd/mmm/yyyy hh:nnttzzz)) } 
        }
        else { 
          if ($level($nick) >= 200) || ($readini(%Saldo, $nick, OP) == +) { 
            if ($readini(%Saldo, $2, Reg) != $null) { $Ruta(Avisa, $2, $chan) } 
            else { $Ruta(Reg, $2, Reg por $nick $+ : $asctime(dd/mmm/yyyy hh:nnttzzz)) } 
          } 
        } 
        /halt
      } 

      elseif ($1 == %prefix $+ Saldo) {
        /inc -z %Tiempo [ $+ [ $nick ] ] 4
        if ($readini(%Saldo, $nick, Reg) == $null) { $Ruta(Aviso, $nick) }
        else { 
          $Ruta(Hora, $nick, Saldo)
          if ($2 == $null) || ($2 == $nick) { 
            /msg $chan 10Saldo 12 $+ $nick $+  Tienes en efectivo 12 $+ $Ruta(User, $nick, Moneda) $+  %Moneda y 12 $+ $Ruta(User, $nick, Moneda2) $+  %Moneda2 $+ . $&
              En el Banco 12 $+ $Ruta(User, $nick, BancoMoneda) $+  %Moneda y 12 $+ $Ruta(User, $nick, BancoMoneda2) $+  %Moneda2 $+ . $&
              Estado $iif($Ruta(User, $nick, Estado) == Activo, 3Activo, 4Ban) $+ . $&
              $iif($readini(%Saldo, $nick, Botes) != $null, Con un total de 12 $+ $readini(%Saldo, $nick, Botes) $+  Botes., Ningún Bote ganado)
          }
          else { 
            if ($readini(%Saldo, $2, Reg) == $null) { $Ruta(Avisa, $2, $chan) } 
            else {
              /msg $chan 10Saldo 12 $+ $2 $+  Tienes en efectivo 12 $+ $Ruta(User, $2, Moneda) $+  %Moneda y 12 $+ $Ruta(User, $2, Moneda2) $+  %Moneda2 $+ . $&
                En el Banco 12 $+ $Ruta(User, $2, BancoMoneda) $+  %Moneda y 12 $+ $Ruta(User, $2, BancoMoneda2) $+  %Moneda2 $+ . $&
                Estado $iif($Ruta(User, $2, Estado) == Activo, 3Activo, 4Ban) $+ . $&
                $iif($readini(%Saldo, $2, Botes) != $null, Con un total de 12 $+ $readini(%Saldo, $2, Botes) $+  Botes., Ningún Bote ganado)
            }
          }
        }
        /halt
      }

      elseif ($1 == %prefix $+ Depositar) || ($1 == %prefix $+ Ingresar) {
        if ($2 == %Mone:1) { 
          if ($3 !isnum) || ($3 == 0) || ($3 == $null) { /msg $chan 10Saldo 12 $+ $nick $+  $1 %Moneda Cantidad(121 a12 $Ruta(User, $nick, Moneda) $+ ) } 
          else { 
            if ($readini(%Saldo, $nick, Moneda) >= $3) { 
              $Ruta(Saldo, $nick, BancoMoneda, +, $3) 
              $Ruta(Saldo, $nick, Moneda, -, $3)
              /msg $chan 10Saldo 12 $+ $nick $+  has ingresado 12 $+ $bytes($3, b) $+  %Moneda a tu cuenta.
            } 
            else { $Ruta(Poco, $nick, Moneda, $chan) } 
          } 
        }
        elseif ($2 == %Mone:2) { 
          if ($3 !isnum) || ($3 == 0) || ($3 == $null) { /msg $chan 10Saldo 12 $+ $nick $+  $1 %Moneda Cantidad(121 a12 $Ruta(User, $nick, Moneda) $+ ) } 
          else { 
            if ($readini(%Saldo, $nick, Moneda2) >= $3) { 
              $Ruta(Saldo, $nick, BancoMoneda2, +, $3) 
              $Ruta(Saldo, $nick, Moneda2, -, $3)
              /msg $chan 10Saldo 12 $+ $nick $+  has ingresado 12 $+ $bytes($3, b) $+  %Moneda2 a tu cuenta.
            } 
            else { $Ruta(Poco, $nick, Moneda2, $chan) } 
          } 
        } 
        else { /msg $chan 10Saldo 12 $+ $nick $+  $1 %Moneda $+ / $+ %Moneda2 Cantidad }
        /halt
      }

      elseif ($1 == %prefix $+ Sacar) || ($1 == %prefix $+ Retirar) {
        if ($2 == %Mone:1) { 
          if ($3 !isnum) || ($3 == 0) || ($3 == $null) { /msg $chan 10Saldo 12 $+ $nick $+  $1 %Moneda Cantidad(121 a12 $Ruta(User, $nick, Moneda) $+ ) } 
          else { 
            if ($readini(%Saldo, $nick, BancoMoneda) >= $3) { 
              $Ruta(Saldo, $nick, BancoMoneda, -, $3)
              $Ruta(Saldo, $nick, Moneda, +, $3)
              /msg $chan 10Saldo 12 $+ $nick $+  has retirado 12 $+ $bytes($3, b) $+  %Moneda de tu cuenta.
            } 
            else { $Ruta(Poco, $nick, BancoMoneda, $chan) } 
          } 
        }
        elseif ($2 == %Mone:2) { 
          if ($3 !isnum) || ($3 == 0) || ($3 == $null) { /msg $chan 10Saldo 12 $+ $nick $+  $1 %Moneda2 Cantidad(121 a12 $Ruta(User, $nick, Moneda2) $+ ) } 
          else { 
            if ($readini(%Saldo, $nick, BancoMoneda2) >= $3) { 
              $Ruta(Saldo, $nick, BancoMoneda2, -, $3)
              $Ruta(Saldo, $nick, Moneda2, +, $3)
              /msg $chan 10Saldo 12 $+ $nick $+  has retirado 12 $+ $bytes($3, b) $+  %Moneda2 de tu cuenta.
            } 
            else { $Ruta(Poco, $nick, BancoMoneda2, $chan) } 
          } 
        } 
        else { /msg $chan 10Saldo 12 $+ $nick $+  $1 %Moneda $+ / $+ %Moneda2 Cantidad. }
        /halt
      }

      elseif ($1 == %prefix $+ Bote) {
        /inc -z %Tiempo [ $+ [ $nick ] ] 4
        if ($readini(%Saldo, $nick, Reg) == $null) { $Ruta(Aviso, $nick) }
        else { 
          $Ruta(Hora, $nick, Saldo)
          if ($2 == $null) { 
            /msg $chan 10Bote 12 $+ $nick $+  El Bote es de 12 $+ $bytes($readini(%Saldo, Bote, Moneda), b) $+  %Moneda y 12 $+ $bytes($readini(%Saldo, Bote, Moneda2), b) $+  %Moneda2 $+ . $&
              $iif($readini(%Saldo, Bote, Gana) != $null, 12 $+ $readini(%Saldo, Bote, Gana) $+  ultimo ganador., No hay ganador del Bote.)
          } 
        }
        /halt
      }

      elseif ($1 == %prefix $+ Estado) { 
        /inc -z %Tiempo [ $+ [ $nick ] ] 4
        if ($readini(%Saldo, $nick, Reg) == $null) { $Ruta(Aviso, $nick) }
        else { 
          $Ruta(Hora, $nick, Saldo)
          if ($2 == $null) { 
            if ($readini(%Saldo, $nick, Estado) == Activo) { .set -u10 %Estado es 03Activo. } 
            else { set -u10 %Estado es 04Ban. } 
            /msg $chan 10Estado 12 $+ $nick $+  %Estado
          } 
          else { 
            if ($3 == $null) { 
              if ($readini(%Saldo, $2, Estado) == Activo) { set -u10 %Estado es 03Activo. } 
              else { set -u10 %Estado es 04Ban. } 
              /msg $chan 10Estado 12 $+ $2 $+  %Estado
              /unset %Estado
            } 
            else {
              if ($level($nick) >= 200) || ($readini(%Saldo, $nick, OP) == +) { 
                if ($3 == Unban) { .writeini %Saldo $2 Estado Activo | /msg $chan 10Estado 12 $+ $nick $+  03Activado para 12 $+ $2 $+ . } 
                elseif ($3 == Ban) { .writeini %Saldo $2 Estado Ban | /msg $chan 10Estado 12 $+ $nick $+  04Baneado para 12 $+ $2 $+ . } 
                else { /msg $chan 10Estado 12 $+ $nick $+  $1-2 03Unban/04Ban } 
              } 
            } 
          }
        } 
        /halt
      } 

      elseif ($1 == %prefix $+ Transferir) {
        /inc -z %Tiempo [ $+ [ $nick ] ] 4
        if ($readini(%Saldo, $nick, Reg) == $null) { $Ruta(Aviso, $nick) }
        else { 
          $Ruta(Hora, $nick, Saldo)
          if ($2 == $null) || ($2 == $nick) { /msg $chan 10Transferir 12 $+ $nick $+  $1 Nick %Moneda $+ / $+ %Moneda2 Cantidad }
          else {
            if ($readini(%Saldo, $2, Reg) == $null) { $Ruta(Avisa, $2, $chan) }
            else {
              if ($3 == %Mone:1) { 
                if ($4 !isnum) || ($4 == 0) || ($4 == $null) { /msg $chan 10Transferir 12 $+ $nick $+  $1 Nick %Moneda Cantidad(121 a12 $Ruta(User, $nick, Moneda) $+ ) } 
                else { 
                  if ($readini(%Saldo, $nick, Moneda) >= $4) { 
                    $Ruta(Saldo, $2, BancoMoneda, +, $4) 
                    $Ruta(Saldo, $nick, Moneda, -, $4)
                    /msg $chan 10Transferir 12 $+ $nick $+  has dado a 12 $+ $2 $+  un total de 12 $+ $bytes($4, b) $+  %Moneda $+ .
                  } 
                  else { $Ruta(Poco, $nick, Moneda, $chan) } 
                } 
              }
              elseif ($3 == %Mone:2) { 
                if ($4 !isnum) || ($4 == 0) || ($4 == $null) { /msg $chan 10Transferir 12 $+ $nick $+  $1 Nick %Moneda2 Cantidad(121 a12 $Ruta(User, $nick, Moneda2) $+ ) } 
                else { 
                  if ($readini(%Saldo, $nick, Moneda2) >= $4) { 
                    $Ruta(Saldo, $2, BancoMoneda2, +, $4) 
                    $Ruta(Saldo, $nick, Moneda2, -, $4)
                    /msg $chan 10Transferir 12 $+ $nick $+  has dado a 12 $+ $2 $+  un total de 12 $+ $bytes($4, b) $+  %Moneda2 $+ .
                  } 
                  else { $Ruta(Poco, $nick, Moneda2, $chan) } 
                } 
              }
              else { /msg $chan 10Transferir 12 $+ $nick $+  $1 nick %Moneda $+ / $+ %Moneda2 Cantidad }
            }
          }
        }
        /halt
      }

      elseif ($1 == %prefix $+ Vender) {
        /inc -z %Tiempo [ $+ [ $nick ] ] 4
        if ($readini(%Saldo, $nick, Reg) == $null) { $Ruta(Aviso, $nick) }
        else { 
          $Ruta(Hora, $nick, Saldo)
          if ($2 == %Mone:2) { 
            if ($3 !isnum) || ($3 == 0) || ($3 == $null) { /msg $chan 10Vender 12 $+ $nick $+  $1 %Moneda2 Cantidad(121 a12 $Ruta(User, $nick, Moneda2) $+ ) } 
            else { 
              if ($Ruta(User, $nick, Moneda2) >= $3) { 
                $Ruta(Saldo, $nick, Moneda, +, $calc(%Moneda2_Costo * $3))
                $Ruta(Saldo, $nick, Moneda2, Saldo, -, $3)
                $Ruta(Saldo, Bote, Moneda2, +, $3)
                /msg $chan 10Vender 12 $+ $nick $+  has vendido un total de 12 $+ $bytes($3, b) $+  %Moneda2 por la cantidad de 12 $+ $bytes($int($calc(%Moneda2_Costo * $3)), b) $+  %Moneda $+ .
              } 
              else { $Ruta(Poco, $nick, Moneda, $chan) } 
            } 
          }
          else { /msg $chan 10Vender 12 $+ $nick $+  $1 %Moneda2 Cantidad. }
        }
        /halt
      }

      elseif ($1 == %prefix $+ Comprar) {
        /inc -z %Tiempo [ $+ [ $nick ] ] 4
        if ($readini(%Saldo, $nick, Reg) == $null) { $Ruta(Aviso, $nick) }
        else { 
          $Ruta(Hora, $nick, Saldo)
          if ($2 == %Mone:2) { 
            if ($3 !isnum) || ($3 == 0) || ($3 == $null) { /msg $chan 10Comprar 12 $+ $nick $+  $1-2 Cantidad(1 a 10000) } 
            else { 
              .set %Comprar_Costo $calc($3 * %Moneda2_Costo)
              if ($Ruta(User, $nick, Moneda) >= %Comprar_Costo) { 
                $Ruta(Saldo, $nick, Moneda2, +, $3)
                $Ruta(Saldo, $nick, Moneda, -, %Comprar_Costo)
                $Ruta(Saldo, Bote, Moneda, +, $3)
                /msg $chan 10Comprar 12 $+ $nick $+  has obtenido 12 $+ $bytes($3, b) %Moneda2 $+  por 12 $+ $bytes($int(%Comprar_Costo), b) $+  %Moneda $+ .
              }
              else { $Ruta(Poco, $nick, Moneda, $chan, Saldo, Aun te falta 12 $+ $bytes($calc(%Comprar_Costo - $Ruta(User, $nick, Moneda)), b) $+ ) } 
            } 
          }
          else { /msg $chan 10Comprar 12 $+ $nick $+  $1 %Moneda2 Cantidad. }
        }
        /unset %Comprar_Costo | /halt
      }


      /*
        Juegos
        */
      if ($1 == !Suerte) || ($1 == .Suerte) || ($1 == @Suerte) { 
        /inc -z %Tiempo [ $+ [ $nick ] ] 4
        if ($readini(%Saldo, $nick, Reg) == $null) { $Ruta(Aviso, $nick) }
        else { 
          if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
          else { 
            if ($readini(%Saldo, $nick, Moneda) < 500) { /msg $chan 10Suerte 12 $+ $nick $+  necesitas  12 $+ 500 $+  %Moneda $+ . }
            else { 
              .set %Suerte [ $+ [ $nick ] ] $rand(1, 12) 
              if (%Suerte [ $+ [ $nick ] ] == 1) { 
                /msg $chan 10Suerte 12 $+ $nick $+  debe de ser tu dia de suerte, te llevas 12 $+ $bytes($readini(%Saldo, Bote, Moneda), b) $+  %Moneda y 12 $+ $bytes($readini(%Saldo, Bote, Moneda2),b) $+  %Moneda2 $+ .
                $Ruta(Saldo, $nick, Botes, +, 1)
                $Ruta(Saldo, $nick, Gana) 
                $Ruta(Saldo, $nick, Moneda, +, $readini(%Saldo, Bote, Moneda)) 
                $Ruta(Saldo, $nick, Moneda2, +, $readini(%Saldo, Bote, Moneda2))
                $Ruta(Saldo, Bote, Moneda, +, $calc(1000 - $readini(%Saldo, Bote, Moneda))) 
                $Ruta(Saldo, Bote, Moneda2, +, $calc(10 - $readini(%Saldo, Bote, Moneda2))) 
              } 
              elseif (%Suerte [ $+ [ $nick ] ] == 2) || (%Suerte [ $+ [ $nick ] ] == 3) || (%Suerte [ $+ [ $nick ] ] == 4) || (%Suerte [ $+ [ $nick ] ] == 5) || (%Suerte [ $+ [ $nick ] ] == 6) { 
                .set %SuerteGana [ $+ [ $nick ] ] $rand(200, 800) 
                $Ruta(Saldo, $nick, Moneda, +, %SuerteGana [ $+ [ $nick ] ])
                $Ruta(Saldo, Bote, Moneda, +, $calc(%SuerteGana [ $+ [ $nick ] ] / 2))
                /msg $chan 10Suerte 12 $+ $nick $+  tuviste suerte, ganas 12 $+ $bytes(%SuerteGana [ $+ [ $nick ] ], b) $+  %Moneda $+ .
              }
              else { 
                .set %SuerteGana [ $+ [ $nick ] ] $rand(100, 500) 
                $Ruta(Saldo, $nick, Moneda, -, %SuerteGana [ $+ [ $nick ] ])
                $Ruta(Saldo, Bote, Moneda, +, %SuerteGana [ $+ [ $nick ] ])
                /msg $chan 10Suerte 12 $+ $nick $+  mala suerte, pierdes 12 $+ $bytes(%SuerteGana [ $+ [ $nick ] ], b) $+  %Moneda $+ .
              } 
            }
          }
        }
        /unset %Suerte [ $+ [ $nick ] ] %SuerteGana [ $+ [ $nick ] ]
        /halt
      }

      elseif ($1 == !Regalo) || ($1 == .Regalo) || ($1 == @Regalo) { 
        /inc -z %Tiempo [ $+ [ $nick ] ] 4
        if ($readini(%Saldo, $nick, Reg) == $null) { $Ruta(Aviso, $nick) }
        else { 
          if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
          else { 
            .set %Regalo [ $+ [ $nick ] ] $rand(50,500)
            /msg $chan 10Regalo 12 $+ $nick $+  tu regalo es 12 $+ $bytes(%Regalo [ $+ [ $nick ] ], b) $+  %Moneda $+ .
            $Ruta(Saldo, $nick, Moneda, +, %Regalo [ $+ [ $nick ] ]) 
          }
        }
        /unset %Regalo [ $+ [ $nick ] ] 
        /halt
      }

      elseif ($1 == !Elijo) || ($1 == .Elijo) || ($1 == @Elijo) { 
        /inc -z %Tiempo [ $+ [ $nick ] ] 4
        if ($readini(%Saldo, $nick, Reg) == $null) { $Ruta(Aviso, $nick) }
        else { 
          if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
          else { 
            if ($readini(%Saldo, $nick, Moneda) < 50) { /msg $chan 10Elijo 12 $+ $nick $+  necesitas 12 $+ 50 $+  %Moneda $+ . }
            else { 
              if ($2 != $null) { 
                .set -u10 %Elijo [ $+ [ $nick ] ] $rand(1,3) 
                if ($2 == Piedra) { 
                  if (%Elijo [ $+ [ $nick ] ] == 1) { 
                    /msg $chan 10Piedra 12 $+ $nick $+  sacas 04Piedra y yo 04Piedra, Aupa un empate, y ganas 12 $+ 25 $+  %Moneda $+ .
                    $Ruta(Saldo, $nick, Moneda, +, 25)
                  } 
                  elseif (%Elijo [ $+ [ $nick ] ] == 2) { 
                    /msg $chan 10Piedra 12 $+ $nick $+  sacas 04Piedra y yo 07Tijeras, ganas 12 $+ 100 $+  %Moneda $+ .
                    $Ruta(Saldo, $nick, Moneda, +, 100)
                  } 
                  elseif (%Elijo [ $+ [ $nick ] ] == 3) { 
                    /msg $chan 10Piedra 12 $+ $nick $+  Sacas 04Piedra y yo 12Papel, pierdes 12 $+ 50 $+  %Moneda $+ .
                    $Ruta(Saldo, $nick, Moneda, -, 50)
                    $Ruta(Saldo, Bote, Moneda, +, 50)
                  } 
                } 
                elseif ($2 == Papel) { 
                  if (%Elijo [ $+ [ $nick ] ] == 1) { 
                    /msg $chan 10Papel 12 $+ $nick $+  sacas 12Papel y yo 12Papel, aupa empate, te doy 12 $+ 30 $+  %Moneda $+ .
                    $Ruta(Saldo, $nick, Moneda, +, 30)
                  } 
                  elseif (%Elijo [ $+ [ $nick ] ] == 2) { 
                    /msg $chan 10Papel 12 $+ $nick $+  sacas 12Papel y yo 04Piedra, ganas 12 $+ 105 $+  %Moneda $+ .
                    $Ruta(Saldo, $nick, Moneda, +, 105)
                  } 
                  elseif (%Elijo [ $+ [ $nick ] ] == 3) { 
                    /msg $chan 10Papel 12 $+ $nick $+  Sacas 12Papel y yo 07Tijeras, pierdes 12 $+ 55 $+  %Moneda $+ .
                    $Ruta(Saldo, $nick, Moneda, -, 55)
                    $Ruta(Saldo, Bote, Moneda, +, 55)
                  } 
                } 
                elseif ($2 == Tijeras) { 
                  if (%Elijo [ $+ [ $nick ] ] == 1) { 
                    /msg $chan 10Tijeras 12 $+ $nick $+  sacas 07Tijeras y yo 07Tijeras, mmm empate, toma 12 $+ 40 $+  %Moneda $+ .
                    $Ruta(Saldo, $nick, Moneda, +, 40)
                  } 
                  elseif (%Elijo [ $+ [ $nick ] ] == 2) { 
                    /msg $chan 10Tijeras 12 $+ $nick $+  sacas 07Tijeras y yo 12Papel, ganas 12 $+ 110 $+  %Moneda $+ .
                    $Ruta(Saldo, $nick, Moneda, +, 110)
                  } 
                  elseif (%Elijo [ $+ [ $nick ] ] == 3) { 
                    /msg $chan 10Tijeras 12 $+ $nick $+  sacas 07Tijeras y yo 04Piedra, pierdes 12 $+ 60 $+  %Moneda $+ .
                    $Ruta(Saldo, $nick, Moneda, -, 60)
                    $Ruta(Saldo, Bote, Moneda, +, 60)
                  } 
                } 
                else { /msg $chan 10Elijo 12 $+ $nick $+  $1 12Papel, 07Tijeras o 04Piedra } 
              }
              else { /msg $chan 10Elijo 12 $+ $nick $+  Lo Siento pero es 12Papel, 07Tijeras o 04Piedra. } 
            } 
          } 
        }
        /unset %Elijo [ $+ [ $nick ] ]
        /halt
      } 
    }
  }

}
