/**
* Archivo oficial, parte del archivo _unu_.mrc
*
*/

alias -l Ruta {
  .set %_init_ $+(scripts\Juego\,$network,\)
  .set %Saldo $+(%_init_,Cuenta.txt) 
  .set %Banco $+(%_init_,Banco.txt) 
  .set %Mod $+(%_init_,Mod.txt)
  .set -i %prefix !

  if ($1 == init) { 
    .load -rs scripts\ $+ $nopath($script)
    .load -rs scripts\_init_.mrc 
  } 

  if ($exists(%unu) != $true) { 
    .mkdir %unu 
    .writeini %Saldo Bote Moneda 25000 
    .writeini %Saldo Bote Moneda_2 25 
  }

  ;Simbolos y graficos. %Mo es de Coin
  .set -i %Moneda 03Coins 
  .set -i %Moneda_2 10Bits

  ;Costo.
  .set -i %Contar 5 
  .set -i %Bote.Costo 15 
  .set -i %Moneda_2.Costo 1000 
  .set -i %Seguro.Costo 5

  if ($1 == Ban) { .msg $3 *04Ban*12 $2 no podes jugar. Si crees que es un error ponte en contacto con un moderador. Usa !Mod. }

  ;$1 es para el nick
  if ($1 == Alta) { 
    ;Saldo
    .writeini %Saldo $2 Hora Ultima vez usado -> $asctime(dd/mmm/yyyy hh:nntt zzz)
    .writeini %Saldo $2 Reg $3-
    .writeini %Saldo $2 Seguro ON
    .writeini %Saldo $2 Estado Activo 
    .writeini %Saldo $2 Moneda 1000 
    .writeini %Saldo $2 Moneda_2 10 
    ;Banco
    .writeini %Banco $2 Hora Ultima vez usado -> $asctime(dd/mmm/yyyy hh:nntt zzz)
    .writeini %Banco $2 Moneda 0 
    .writeini %Banco $2 Moneda_2 0
    ;Mensaje de salida
    .msg $2 *10Saldo/Banco*12 $2 puedes usar 12 %prefix $+ Ayuda en la sala para más información. 
  } 

  if ($1 == Hora) { .writeini %Saldo $2 Hora Ultima vez conectado -> $asctime(dd/mmm/yyyy hh:nntt zzz) }
  if ($1 == Hora_1) { .writeini %Banco $2 Hora Ultima vez conectado -> $asctime(dd/mmm/yyyy hh:nntt zzz) }

  ;$2 es para el nick y el $3 es para el comando.
  if ($1 == User) { 
    if ($3 == Moneda) { return $bytes($readini(%Saldo,$2,Moneda),b) }
    if ($3 == Moneda_2) { return $bytes($readini(%Saldo,$2,Moneda_2),b) }
    if ($3 == Botes) { return $readini(%Saldo,$2,Botes) }
    if ($3 == Estado) { return $readini(%Saldo,$2,Estado) }
    if ($3 == Seguro) { return $readini(%Saldo,$2,Seguro) }
  } 
  if ($1 == Banco) { 
    if ($3 == Total) { .msg $4 *12Banco* $2 un total de 12 $+ $bytes($readini(%Banco,$2,Moneda),b) $+ $ %Moneda $+ , 12 $+ $bytes($readini(%Banco,$2,Moneda_2),b) $+  %Moneda_2 $+ . }
    if ($3 == Moneda) { return $bytes($readini(%Banco,$2,Moneda),b) }
    if ($3 == Moneda_2) { return $bytes($readini(%Banco,$2,Moneda_2),b) }
  }

  ;$2 es para el nick y el $1 es para la sala.
  Elseif ($1 == Aviso) { 
    .msg $2 Usuario12 $2 no tiene saldo, si quieres registrarse usa 12!Alta en la sala. $&
      Le recuerdo que su nick debe de tener el modo 12+r para evitar robos o perdida de saldo. 
  }
  Elseif ($1 == Avisa) { .msg $3 Usuario12 $2 no tiene saldo. }

  ;$1 es para el nick, el $2 es para el comando, $3 es para la sala, $4 es para el archivo Saldo/Banco.
  Elseif ($1 == Poco) { 
    if ($3 == Moneda) { .msg $4 *04 $+ $5 $+ *12 $2 Solo dispones de12 $bytes($readini(% [ $+ [ $5 ] ],$2,Moneda),b) $+ $ %Moneda $+ . $6- }
    Elseif ($3 == Moneda_2) { .msg $4 *04 $+ $5 $+ *12 $2 Solo dispones de12 $bytes($readini(% [ $+ [ $5 ] ],$2,Moneda_2),b) %Moneda_2 $+ . $6- }
  } 

  ;$1 es para el nick, $2 Moneda o Moneda_2, $3 Es Saldo o Banco, $4 es para quitar(-) o poner(+), $5 es la cantidad
  Elseif ($1 == Saldo) {
    if ($2 != $null) && ($3 != $null) && ($4 != $null) && ($5 != $null) { 
      .writeini % [ $+ [ $4 ] ] $2-3 $int($calc($readini(% [ $+ [ $4 ] ],$2,$3) $5-6)) 
    } 
  }

  Elseif ($1 == Bote) {
    if ($3 == Gana) { .writeini %Saldo Bote Gana $2 } 
    Else { .writeini %Saldo $2 $3 $int($calc($readini(%Saldo,$2,$3) $4-5)) } 
  } 
} 

On *:start: {
  .echo -s [******] 13u07n10u [******] [15|08|2020]
  if (%Aviso_init != $null) { 
    .msg %Aviso_init *10Archivo* $remove($nopath($script),.mrc) cargado correctamente!
    .unset %Aviso_init 
  }
}

On *:TEXT:*:#: { 
  .Ruta 
  if ($1 == %prefix $+ init) {
    if ($level($nick) >= 200) || ($readini(%Saldo,$nick,OP) == +) { 
      if ($2 == $null) {
        if ($nick ison $chan) { .set -u30 %Aviso_init $chan }
        else { .set -u30 %Aviso_init $nick }
        /reseterror 
        $Ruta(init) 
      }
      elseif ($2 == F) { .set %Server ON | /Quit Nos vemos. Quit: $nick }
    } 
  }

  if ($1 == %prefix $+ Juegos) || ($1 == %prefix $+ Juego) { 
    if ($nick !ison $chan) { .halt }
    else {
      if ($level($nick) >= 200) || ($readini(%Saldo,$nick,OP) == +) { 
        if ($2 == Enable) { 
          if ($readini(%Saldo,+,$chan) == ON) { .msg $chan Los Juegos ya estan 12Enable. } 
          else { .writeini %Saldo + $chan ON | .msg $chan [Juegos: 12Enable...] } 
        }
        elseif ($2 == Disable) { 
          if ($readini(%Saldo,+,$chan) == OFF) { .msg $chan Los Juegos ya estan 12Disable. } 
          else { .writeini %Saldo + $chan OFF | .msg $chan [Juegos: 12Disable...] } 
        }
        else { 
          if ($readini(%Saldo,+,$chan) == ON) { .msg $chan [Juegos: 12Enable] Para Desativarlo usa 12Disable. } 
          else { .msg $chan [Juegos: 12Disable] Para Activarlo usa 12Enable. } 
        }
      }
    }
    .halt
  }

  if ($1 == %prefix $+ Ayuda) {
    if (%Ay1 [ $+ [ $nick ] ] != $null) { .halt } 
    else { 
      .inc -z %Ay1 $+ $nick 180
      .inc %Ay2 | .timer 1 %Ay2 .msg $nick Ayuda $nick
      .inc %Ay2 | .timer 1 %Ay2 .msg $nick 12!Alta [Para Saldo] 12!Banco Reg [Para Banco] 
      .inc %Ay2 | .timer 1 %Ay2 .msg $nick 12!Bote, !Saldo, !Dar, !Vender, !Comprar, !Costo, !Banco, !Estado. 
      .inc %Ay2 | .timer 1 %Ay2 .msg $nick 12!Ruleta, !Dados, !Traga, !Premio, !Robar, !Elijo, !Numero/!Mayor/!Menor y para ganar el bote, puedes usar 12!Ruleta
    }
    .unset %Ay2 | .halt
  }
  if ($readini(%Saldo,+,$chan) != ON) { .halt }
  if (%Tiempo [ $+ [ $nick ] ] == $null) { 

    if ($1 == %prefix $+ Alta) { 
      .inc -z %Tiempo $+ $nick 4
      if ($2 == $null) { 
        if ($readini(%Saldo,$nick,Reg) != $null) { .msg $chan Usuario12 $nick esta Registrado en mi DB. } 
        else { $Ruta(Alta, $nick, Reg por $nick) } 
      }
      else { 
        if ($level($nick) >= 200) || ($readini(%Saldo,$nick,OP) == +) { 
          if ($readini(%Saldo,$2,Reg) != $null) { $Ruta(Avisa, $2, $chan) } 
          else { $Ruta(Alta, $2, Reg por $nick) } 
        } 
      } 
      .halt
    } 

    elseif ($1 == %prefix $+ Mod) {
      if ($2 == +) || ($2 == -) {
        if ($level($nick) >= 200) {
          if ($2 == +) {
            if ($readini(%Saldo, $3, OP) == +) { .msg $nick [Mod: $3 $+] Es un Mod. }
            else {
              .writeini %Saldo $3 OP +
              .write %Mod Mod: $3
              .msg $nick Mod: $3 -> Es ahora un Mod.
              .msg $3 Hola usuario :D eres un Mod.
            }
          }
          elseif ($2 == -) {
            if ($readini(%Saldo, $3, OP) != +) { .msg $nick [Mod: $3 $+] No es un Mod. }
            else {
              .remove %Saldo $3 OP
              .write -ds $+ Mod: $3 %Mod
              .msg $nick Mod: $3 -> No es un Mod.
            }
          }
        }
      }
      elseif ($2 == $null) {
        if ($exists(%Mod) != $true) { .msg $nick Lo siento, pero no tengo ningun Mod. }
        else { 
          .msg $nick Lista de Mod: "Tip: Si quieres saber mas sobre un Mod, puedes usar !Mod nick".
          .play $nick %Mod 1500 
        }
      }
      else {
        if ($readini(%Saldo, $2, OP) == +) { .msg $nick *10Saldo*12 $2 es un Mod. Puedes hacer "12/query $2 $+ " y escribirle.12 $readini(%Saldo, $2, Hora) }
        else { .msg $nick Info: $2 no es un Mod. Puedes poner "!Mod". Luego asegurarte de colocar bien el nick cuando quieras saber algo. }
      }
      .halt
    }

    elseif ($1 == %prefix $+ Saldo) {
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        $Ruta(Hora, $nick)
        if ($2 == $null) || ($2 == $nick) { 
          .msg $chan *10Saldo*12 $nick un total de12 $Ruta(User, $nick, Moneda) $+ $ %Moneda y12 $Ruta(User, $nick, Moneda_2)  $+ %Moneda_2 $+ . Estado $Ruta(User, $nick, Estado) y Seguro $Ruta(User, $nick, Seguro) $+ .
        }
        else { 
          if ($readini(%Saldo,$2,Reg) == $null) { $Ruta(Avisa, $2, $chan) } 
          else { .msg $chan *10Saldo*12 $2 un total de12 $Ruta(User, $2, Moneda) $+ $ %Moneda y12 $Ruta(User, $2, Moneda_2)  $+ %Moneda_2 $+ . Estado $Ruta(User, $2, Estado) y Seguro $Ruta(User, $2, Seguro) $+ . }
        }
      }
      .halt
    }

    elseif ($1 == %prefix $+ Bote) {
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        $Ruta(Hora, $nick)
        if ($2 == $null) { 
          if ($readini(%Saldo,Bote,Gana) != $null) { .set -u10 %Bote.Gana $readini(%Saldo,Bote,Gana) ultimp ganador. } 
          else { .unset %Bote.Gana }
          .msg $chan *12Bote*12 $nick es de12 $bytes($readini(%Saldo,Bote,Moneda),b) $+ $ %Moneda y12 $bytes($readini(%Saldo,Bote,Moneda_2),b)  $+ %Moneda_2 $+ . %Bote.Gana
        } 
      }
      .halt
    }

    elseif ($1 == %prefix $+ Estado) { 
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        $Ruta(Hora, $nick)
        if ($2 == $null) { 
          if ($readini(%Saldo, $nick, Estado) == Activo) { .set -u10 %Estado es 03Activo. } 
          else { set -u10 %Estado es 04Ban. } 
          .msg $chan *10Estado*12 $nick  $+ %Estado
        } 
        else { 
          if ($3 == $null) { 
            if ($readini(%Saldo, $2, Estado) == Activo) { set -u10 %Estado es 03Activo. } 
            else { set -u10 %Estado es 04Ban. } 
            .msg $chan *10Estado*12 $2  $+ %Estado
            .unset %Estado
          } 
          else {
            if ($level($nick) >= 200) || ($readini(%Saldo,$nick,OP) == +) { 
              if ($3 == Activo) { .writeini %Saldo $2 Estado Activo | .msg $chan [Estado: 03Activo] Para el usuario12 $2 } 
              elseif ($3 == Ban) { .writeini %Saldo $2 Estado Ban | .msg $chan [Estado: 04Ban] Para el usuario12 $2 } 
              else { .msg $chan $1-2 (03Activo|04Ban) } 
            } 
          } 
        }
      } 
      .halt
    } 

    elseif ($1 == %prefix $+ Dar) {
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        $Ruta(Hora, $nick)
        if ($2 == $null) || ($2 == $nick) { .msg $chan *12Dar*12 $nick -> $1 nick %Moneda $+ / $+ %Moneda_2 Cantidad }
        else {
          if ($readini(%Saldo,$2,Reg) == $null) { $Ruta(Avisa, $2, $chan) }
          else {
            if ($3 == Coin) || ($3 == Coins) { 
              if ($4 !isnum) || ($4 == 0) || ($4 == $null) { .msg $chan *10Dar*12 $nick -> $1 nick %Moneda Cantidad(1 a $Ruta(User, $nick, Moneda) $+ ) } 
              else { 
                if ($Ruta(User, $nick, Moneda) >= $4) { 
                  $Ruta(Saldo, $2, Moneda, Banco, +, $4) 
                  $Ruta(Saldo, $nick, Moneda, Saldo, -, $4)
                  .msg $chan *10Dar*12 $nick -> has dado a12 $2 un total de12 $bytes($4,b) $+ $ %Moneda $+ .
                } 
                else { $Ruta(Poco, $nick, Moneda, $chan, Saldo) } 
              } 
            }
            elseif ($3 == Bit) || ($3 == Bits) { 
              if ($4 !isnum) || ($4 == 0) || ($4 == $null) { .msg $chan *10Dar*12 $nick -> $1 nick %Moneda_2 Cantidad(1 a $Ruta(User, $nick, Moneda_2) $+ ) } 
              else { 
                if ($Ruta(User, $nick, Moneda_2) >= $4) { 
                  $Ruta(Saldo, $2, Moneda_2, Banco, +, $4) 
                  $Ruta(Saldo, $nick, Moneda_2, Saldo, -, $4)
                  .msg $chan *10Dar*12 $nick -> has dado a12 $2 un total de12 $bytes($4,b)  $+ %Moneda_2 $+ .
                } 
                else { $Ruta(Poco, $nick, Moneda_2, $chan, Saldo) } 
              } 
            }
            else { .msg $chan *12Dar*12 $nick -> $1 nick %Moneda $+ / $+ %Moneda_2 Cantidad }
          }
        }
      }
      .halt
    }

    elseif ($1 == %prefix $+ Costo) {
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        $Ruta(Hora, $nick)
        .inc %Costo.Msg 1 | .timer 1 %Costo.Msg .msg $nick Usuario12 $nick el costo de los productos:
        .inc %Costo.Msg 1 | .timer 1 %Costo.Msg .msg $nick (=)*12Dar*12 $nick  %Moneda_2 es de %Moneda_2.Costo %Moneda 
        .inc %Costo.Msg 1 | .timer 1 %Costo.Msg .msg $nick (=) Bote es de %Bote.Costo %Moneda_2
        .inc %Costo.Msg 1 | .timer 1 %Costo.Msg .msg $nick (=) Seguro es de %Seguro.Costo %Moneda_2
        .unset %Costo.*
      }
      .halt
    }

    elseif ($1 == %prefix $+ Vender) {
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        $Ruta(Hora, $nick)
        if ($2 == Bit) || ($2 == Bits) { 
          if ($3 !isnum) || ($3 == 0) || ($3 == $null) { .msg $chan *10Vender*12 $nick -> $1 %Moneda_2 Cantidad(1 a $Ruta(User, $nick, Moneda_2) $+ ) } 
          else { 
            if ($Ruta(User, $nick, Moneda_2) >= $3) { 
              $Ruta(Saldo, $nick, Moneda, Saldo, +, $calc(%Moneda_2.Costo * $3))
              $Ruta(Saldo, $nick, Moneda_2, Saldo, -, $3)
              $Ruta(Bote, Bote, Moneda, +, %Comprar.Costo)
              .msg $chan Usuario12 $nick has vendido un total de12 $bytes($3,b) %Moneda_2 por la cantidad de12 $bytes($int($calc(%Moneda_2.Costo * $3)),b) $+ $ %Moneda $+ .
            } 
            else { $Ruta(Poco, $nick, Moneda, $chan, Saldo) } 
          } 
        }
        else { .msg $chan Usuario usa $1 %Moneda_2 }
      }
      .halt
    }

    elseif ($1 == %prefix $+ Comprar) {
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        $Ruta(Hora, $nick)
        if ($2 == Bit) || ($2 == Bits) { 
          if ($3 !isnum) || ($3 == 0) || ($3 == $null) { .msg $chan *10Comprar*12 $nick -> $1-2 Cantidad(1 a 10000) } 
          else { 
            .set %Comprar.Costo $calc($3 * %Moneda_2.Costo)
            if ($Ruta(User, $nick, Moneda) >= %Comprar.Costo) { 
              $Ruta(Saldo, $nick, Moneda_2, Saldo, +, $3)
              $Ruta(Saldo, $nick, Moneda, Saldo, -, %Comprar.Costo)
              $Ruta(Bote, Bote, Moneda, +, %Comprar.Costo)
              .msg $chan *10Comprar*12 $nick has obtenido12 $bytes($3,b)  $+ %Moneda_2 por12 $bytes($int(%Comprar.Costo),b) $+ $ %Moneda $+ .
            }
            else { $Ruta(Poco, $nick, Moneda, $chan, Saldo, Aun te falta12 $bytes($calc(%Comprar.Costo - $Ruta(User, $nick, Moneda)),b) $+ $) } 
          } 
        }
        elseif ($2 == Seguro) { 
          if ($Ruta(User, $nick, Seguro) == ON) { .msg $chan Usuario12 $nick 12dispones un seguro. }
          else {
            if ($Ruta(User, $nick, Moneda_2) >= %Seguro.Costo) { 
              .writeini %Saldo $nick Seguro ON 
              $Ruta(Saldo, $nick, Moneda_2, Saldo, -, %Seguro.Costo)
              $Ruta(Bote, Bote, Moneda_2, +, %Seguro.Costo)
              .msg $chan *10Comprar*12 $nick has obtenido un Seguro, por12 %Seguro.Costo  $+ %Moneda_2 $+ .
            }
            else { $Ruta(Poco, $nick, Moneda_2, $chan, Saldo, Aun te falta12 $bytes($calc(%Seguro.Costo - $Ruta(User, $nick, Moneda_2)),b)) } 
          }
        }
      }
      .halt
    }
    elseif ($1 == %prefix $+ Banco) {
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else {  
        $Ruta(Hora_1, $nick)
        if ($2 == Saldo) || ($2 == Info) {
          if ($3 == $null) || ($3 == $nick) { $Ruta(Banco, $nick, Total, $chan) }
          else { 
            if ($level($nick) >= 300) || ($readini(%Saldo,$nick,OP) == +) { 
              if ($readini(%Saldo,$3,Reg) == $null) { $Ruta(Avisa, $nick, $chan) } 
              else { $Ruta(Banco, $3, Total, $chan) } 
            }
          }
        }
        elseif ($2 == Ingreso) || ($2 == Ingresar) {
          if ($3 == Coin) || ($3 == Coins) { 
            if ($4 !isnum) || ($4 == 0) || ($4 == $null) { .msg $chan *10Banco*12 $nick -> $1 %Moneda Cantidad(1 a $Ruta(User, $nick, Moneda) $+ ) } 
            else { 
              if ($Ruta(User, $nick, Moneda) >= $4) { 
                $Ruta($nick, Moneda, Banco, +, $4) 
                $Ruta($nick, Moneda, Saldo, -, $4)
                .msg $chan *10Banco*12 $nick has ingresado12 $bytes($4,b) $+ $ %Moneda a tu cuenta.
              } 
              else { $Ruta(Poco, $nick, Moneda, $chan, Saldo) } 
            } 
          }
          elseif ($3 == Bit) || ($3 == Bits) { 
            if ($4 !isnum) || ($4 == 0) || ($4 == $null) { .msg $chan Usuario usa $1 %Moneda_2 Cantidad(1 a $Ruta(User, $nick, Moneda_2) $+ ) } 
            else { 
              if ($Ruta(User, $nick, Moneda_2) >= $4) { 
                $Ruta($nick, Moneda_2, Banco, +, $4) 
                $Ruta($nick, Moneda_2, Saldo, -, $4)
                .msg $chan *10Banco*12 $nick has ingresado12 $bytes($4,b)  $+ %Moneda_2 a tu cuenta.
              } 
              else { $Ruta(Poco, $nick, Moneda_2, $chan, Saldo) } 
            } 
          } 
          else { .msg $chan *10Banco*12 $nick -> $1-2 %Moneda o %Moneda_2 y cantidad }
        }
        elseif ($2 == Retiro) || ($2 == Retirar) {
          if ($3 == Coin) || ($3 == Coins) { 
            if ($4 !isnum) || ($4 == 0) || ($4 == $null) { .msg $chan *10Banco*12 $nick -> $1 %Moneda Cantidad(1 a $Ruta(User, $nick, Moneda) $+ ) } 
            else { 
              if ($Ruta(Banco, $nick, Moneda) >= $4) { 
                $Ruta(Banco, $nick, Moneda, Banco, -, $4)
                $Ruta(Banco, $nick, Moneda, Saldo, +, $4)
                .msg $chan *10Banco*12 $nick has retirado12 $bytes($4,b) $+ $ %Moneda de tu cuenta.
              } 
              else { $Ruta(Poco, $nick, Moneda, $chan, Banco) } 
            } 
          }
          elseif ($3 == Bit) || ($3 == Bits) { 
            if ($4 !isnum) || ($4 == 0) || ($4 == $null) { .msg $chan *10Banco*12 $nick -> $1 %Moneda_2 Cantidad(1 a $Ruta(User, $nick, Moneda_2) $+ ) } 
            else { 
              if ($Ruta(Banco, $nick, Moneda_2) >= $4) { 
                $Ruta(Banco, $nick, Moneda_2, Banco, -, $4)
                $Ruta(Banco, $nick, Moneda_2, Saldo, +, $4)
                .msg $chan *10Banco*12 $nick has retirado12 $bytes($4,b)  $+ %Moneda_2 de tu cuenta.
              } 
              else { $Ruta(Poco, $nick, Moneda_2, $chan, Banco) } 
            } 
          } 
          else { .msg $chan *10Banco*12 $nick -> $1-2 ( $+ %Moneda $+ | $+ %Moneda_2 $+ ) }
        }
        else { .msg $chan *10Banco*12 $nick -> $1 Saldo/Ingreso/Retiro }
      }
      .halt
    }

    If ($1 == !Dados) || ($1 ==  .Dados) || ($1 == @Dados) { 
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
        else { 
          if ($Ruta(User, $nick, Moneda) < 50) { .msg $chan Usuario12 $nick necesitas12 50$ %Moneda $+ . }
          else { 
            if ($2 == $null) {
              .set -u10 %Dados $rand(2,6) 
              if (%Dados == 2) || (%Dados == 3) || (%Dados == 4) { 
                .set -u10 %Dados.Dinero $rand(500,2000) 
                .msg $chan Usuario12 $nick los dados ruedan y sale... %Dados y Ganas12 $bytes(%Dados.Coin,b) $+ $ %Moneda $+ .
                $Ruta(Saldo, $nick, Moneda, Saldo, +, %Dados.Dinero)
                $Ruta(Bote, Bote, Moneda, +, %Dados.Dinero)
              }
              else { 
                .msg $chan Usuario12 $nick los dados ruedan y sale... %Dados y no ganas nada. 
                $Ruta(Bote, Bote, Moneda, +, 500)
              }
            }
            else { 
              if ($2 isnum) && ($2 >= 2) && ($2 <= 12) {
                .set -u10 %Dados $rand(2,12) 
                if (%Dados == $2) { 
                  .msg $chan Usuario12 $nick el numero es %Dados y ganas12 $bytes($calc(500 * %Dados),b) $+ $ %Moneda $+ .
                  $Ruta(Saldo, $nick, Moneda, Saldo, +, $calc(500 * %Dados))
                }
                else { 
                  .msg $chan Usuario12 $nick el numero es %Dados y no ganas nada. 
                  $Ruta(Bote, Bote, Moneda, +, 500)
                }
              }
              else { .msg $chan Usuario12 $nick solo puedes elegir un numero de 2 a 12. }
            }
          }
        }
      }
      .unset %Dados* | .halt
    }

    elseif ($1 == !Ruleta) || ($1 ==  .Ruleta) || ($1 == @Ruleta) { 
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
        else { 
          if ($readini(%Saldo,$nick,Coin) < 500) { .msg $chan Usuario12 $nick Necesitas12 500$ %Moneda }
          else { 
            .set -u10 %Ruleta $rand(1,12) 
            if (%Ruleta == 1) { 
              if ($readini(%Saldo,$nick,Contar) >= %Contar) {
                .msg $chan Usuario12 $nick la Ruleta se detiene en... Bote, te llevas12 $bytes($readini(%Saldo, Bote, Moneda),b) $+ $ %Moneda y12 $bytes($readini(%Saldo, Bote, Moneda_2),b) %Moneda_2 $+ .
                $Ruta(Saldo, $nick, Botes, Saldo, +, 1)
                $Ruta(Bote, $nick, Gana) 
                $Ruta(Saldo, $nick, Moneda, Saldo, +, $readini(%Saldo, Bote, Moneda)) 
                $Ruta(Saldo, $nick, Moneda_2, Saldo, +, $readini(%Saldo, Bote, Moneda_2))
                $Ruta(Bote, Bote, Moneda, +, 1000) 
                $Ruta(Bote, Bote, Moneda_2, +, 10) 
              }
            } 
            elseif (%Ruleta == 2) || (%Ruleta == 3) || (%Ruleta == 4) || (%Ruleta == 5) || (%Ruleta == 6) { 
              .set -u10 %Ruleta $rand(100,500) 
              $Ruta(Saldo, $nick, Moneda, Saldo, +, %Ruleta)
              $Ruta(Bote, Bote, Moneda, +, $calc(%Ruleta / 2))
              .msg $chan Usuario12 $nick la Ruleta se detiene en... 03CLICK!, y ganas12 $bytes(%Ruleta,b) $+ $ %Moneda $+ .
            }
            ; Pierdes.
            else { 
              .set -u10 %Ruleta $rand(100,500) 
              $Ruta(Saldo, $nick, Moneda, Saldo, -, %Ruleta)
              $Ruta(Bote, Bote, Moneda, +, %Ruleta)
              .msg $chan Usuario12 $nick la Ruleta se detiene en... 04Ban!, y pierdes12 $bytes(%Ruleta,b) $+ $ %Moneda $+ .
            } 
          }
        }
      }
      %Ruleta | .halt
    }

    elseif ($1 == !Traga) || ($1 ==  .Traga) || ($1 == @Traga) { 
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
        else { 
          if ($Ruta(User, $nick, Moneda) < 1000) { .msg $chan Usuario12 $nick Necesitas12 1000$ %Moneda }
          else { 
            if ($2 == $null) {
              .set -u10 %Traga $rand(1,4) 
              .set -u10 %Traga.Sim $rand(1,2) 
              .set -u10 %Traga.Mo $rand(500,1500)
              if (%Traga == 1) || (%Traga == 2) || (%Traga == 3) { 
                $Ruta(Saldo, $nick, Moneda, Saldo, +, %Traga.Mo)
                $Ruta(Bote, Bote, Moneda, +, $calc(%Traga.Mo / 2))
                .msg $chan Usuario12 $nick Tira de la traga y saca... [13@] + [13@] y Ganas12 $bytes(%Traga.Mo,b) $+ $ %Moneda $+ . 
              } 
              else { 
                $Ruta(Saldo, $nick, Moneda, Saldo, -, $calc(%Traga.Mo / 5))
                $Ruta(Bote, Bote, Moneda, +, %Traga.Mo)
                .msg $chan Usuario12 $nick Tira de la traga y saca... [13&] + [13&] y Pierdes12 $bytes($calc(%Traga.Mo / 5),b) $+ $ %Moneda $+ .
              } 
            }
          }
        }
      }
      .unset %Traga* | .halt
    }

    elseif ($1 == !Premio) || ($1 ==  .Premio) || ($1 == @Premio) { 
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
        else { 
          .set -u10 %Premio.Moneda $rand(50,500)
          .msg $chan Usuario12 $nick tu premio es12 $bytes(%Premio.Moneda,b) $+ $ %Moneda $+ .
          $Ruta(Saldo, $nick, Moneda, Saldo, +, %Premio.Moneda) 
        }
      }
      .unset %Premio* | .halt
    }

    elseif ($1 == !Elijo) || ($1 ==  .Elijo) || ($1 == @Elijo) { 
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
        else { 
          if ($Ruta(User, $nick, Moneda) < 200) { .msg $chan Usuario12 $nick Necesitas12 200$ %Moneda }
          else { 
            if ($2 != $null) { 
              .set -u10 %Bot $rand(1,3) 
              if ($2 == Piedra) { 
                if (%Bot == 1) { 
                  .msg $chan Usuario12 $nick Saca 04Piedra y yo saco 04Piedra, Empate, y Ganas 300$ %Moneda 
                  $Ruta(Saldo, $nick, Moneda, Saldo, +, 300)
                } 
                elseif (%Bot == 2) { 
                  .msg $chan Usuario12 $nick Sacas 04Piedra y yo 07Tijeras, y Ganas 500$ %Moneda 
                  $Ruta(Saldo, $nick, Moneda, Saldo, +, 500)
                } 
                elseif (%Bot == 3) { 
                  .msg $chan Usuario12 $nick Sacas 04Piedra y yo 12Papel, y Pierdes 200$ %Moneda 
                  $Ruta(Saldo, $nick, Moneda, Saldo, -, 200)
                  $Ruta(Bote, Bote, Moneda, +, 200)
                } 
              } 
              elseif ($2 == Papel) { 
                if (%Bot == 1) { 
                  .msg $chan Usuario12 $nick Sacas 12Papel y yo 12Papel, Empate, y Ganas 300$ %Moneda 
                  $Ruta(Saldo, $nick, Moneda, Saldo, +, 300)
                } 
                elseif (%Bot == 2) { 
                  .msg $chan Usuario12 $nick Sacas 12Papel y yo 04Piedra, y Ganas 500$ %Moneda 
                  $Ruta(Saldo, $nick, Moneda, Saldo, +, 500)
                } 
                elseif (%Bot == 3) { 
                  .msg $chan Usuario12 $nick Sacas 12Papel y yo 07Tijeras, y Pierdes 200$ %Moneda 
                  $Ruta(Saldo, $nick, Moneda, Saldo, -, 200)
                  $Ruta(Bote, Bote, Moneda, +, 200)
                } 
              } 
              elseif ($2 == Tijeras) { 
                if (%Bot == 1) { 
                  .msg $chan Usuario12 $nick Sacas 07Tijeras y yo 07Tijeras, Empate, y Ganas 300$ %Moneda 
                  $Ruta(Saldo, $nick, Moneda, Saldo, +, 300)
                } 
                elseif (%Bot == 2) { 
                  .msg $chan Usuario12 $nick Sacas 07Tijeras y yo 12Papel, y Ganas 500$ %Moneda 
                  $Ruta(Saldo, $nick, Moneda, Saldo, +, 500)
                } 
                elseif (%Bot == 3) { 
                  .msg $chan Usuario12 $nick Sacas 07Tijeras y yo04Piedra, y Pierdes 200$ %Moneda 
                  $Ruta(Saldo, $nick, Moneda, Saldo, -, 200)
                  $Ruta(Bote, Bote, Moneda, +, 200)
                } 
              } 
              else { .msg $chan Usuario12 $nick Elija entre 12Papel, 07Tijeras o 04Piedra } 
            }
            else { .msg $chan Usuario12 $nick Lo Siento pero es 12Papel, 07Tijeras e 04Piedra. } 
          } 
        } 
      }
      .unset %Bot | .halt
    } 

    elseif ($1 == !Numero) || ($1 ==  .Numero) || ($1 == @Numero) { 
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
        else { 
          if ($readini(%Saldo,$nick,Numero) == $null) { 
            .writeini %Saldo $nick Numero $rand(1,10) | .writeini %Saldo $nick Puntos 0
            .msg $chan Usuario12 $nick Tu numero es12 $readini(%Saldo,$nick,Numero) Pon !Mayor o !Menor para jugar. 
          }
          else { .msg $chan Usuario12 $nick Tu numero es12 $readini(%Saldo,$nick,Numero) con12 $readini(%Saldo,$nick,Puntos) puntos. Tip: Por cada punto, son 50$ %Moneda $+ . }
        }
      }
      .halt
    }

    elseif ($1 == !Mayor) || ($1 ==  .Mayor) || ($1 == @Mayor) {
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
        else { 
          .set -u6 %Mayor $rand(1,10) 
          if ($readini(%Saldo,$nick,Numero) <= %Mayor) { 
            .writeini %Saldo $nick Numero %Mayor 
            .writeini %Saldo $nick Puntos $calc($readini(%Saldo,$nick,Puntos) + 1)
            .msg $chan Usuario12 $nick Tu numero ahora es12 $readini(%Saldo,$nick,Numero) y te llevas 121 punto.
          }
          else { 
            $Ruta(Saldo, $nick, Moneda, Saldo, +, $calc($readini(%Saldo,$nick,Puntos) * 50))
            .msg $chan Usuario12 $nick Ups perdiste. Tu numero es12 %Mayor y te llevas una Ganancia de12 $calc($readini(%Saldo,$nick,Puntos) * 50) $+ $ %Moneda $+ .
            .writeini %Saldo $nick Numero %Mayor 
            .writeini %Saldo $nick Puntos 0 
          }
        }
      }
      .halt
    }

    elseif ($1 == !Menor) || ($1 ==  .Menor) || ($1 == @Menor) { 
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
        else { 
          .set -u6 %Menor $rand(1,10) 
          if ($readini(%Saldo,$nick,Numero) >= %Menor) { 
            .writeini %Saldo $nick Numero %Menor 
            .writeini %Saldo $nick Puntos $calc($readini(%Saldo,$nick,Puntos) + 1)
            .msg $chan Usuario12 $nick Tu numero ahora es12 $readini(%Saldo,$nick,Numero) y te llevas 121 punto.
          }
          else { 
            $Ruta(Saldo, $nick, Moneda, Saldo, +, $calc($readini(%Saldo,$nick,Puntos) * 50))
            .msg $chan Usuario12 $nick Ups perdiste. Tu numero es12 %Menor y te llevas una Ganancia de12 $calc($readini(%Saldo,$nick,Puntos) * 50) $+ $ %Moneda $+ .
            .writeini %Saldo $nick Numero %Menor 
            .writeini %Saldo $nick Puntos 0 
          }
        }
      }
      .halt
    }

    elseif ($1 == !Robar) || ($1 ==  .Robar) || ($1 == @Robar) { 
      .inc -z %Tiempo $+ $nick 4
      if ($readini(%Saldo,$nick,Reg) == $null) { $Ruta(Aviso, $nick) }
      else { 
        if ($Ruta(User, $nick, Estado) == Ban) { $Ruta(Ban, $nick, $chan) } 
        else { 
          if (%Robar [ $+ [ $nick ] ] != $null) { .msg $chan Usuario12 $nick Debes esperar $duration(%Robar [ $+ [ $nick ] ]) $+ ! ;-) }
          else {
            .set -i %Robar_Tiempo 180
            if ($2 == $null) { .msg $chan Usuario12 $nick Falta el nick para robar. Cmd: $1 nick 03co04di01go. }
            else {
              if ($readini(%Saldo,$2,Reg) == $null) { $Ruta(Avisa, $2) } 
              elseif ($2 == $nick) { .msg $chan Usuario12 $nick no podes robarte a ti mism@. }
              else { 
                if ($Ruta(User, $2, Seguro) == ON) {
                  .set -z %Robar $+ $nick $calc(%Robar_Tiempo / 2) 
                  .writeini %Saldo $2 Code $calc($readini(%Saldo,$2,Code) + 1)
                  if ($readini(%Saldo,$2,Code) >= 2) { 
                    .writeini %Saldo $2 Seguro OFF 
                    .writeini %Saldo $2 Code 0 
                    .msg $chan Usuario12 $nick rompiste la seguridad de12 $2 :D...
                  }
                  else { .msg $chan Usuario12 $nick casi rompes la seguridad de12 $2 :'D }
                }
                else { 
                  if ($3 == $null) || ($3 !isnum) || ($len($3) != 2) { 
                    .msg $chan Usuario12 $nick debes de adivinar el codigo de12 $2 es de dos digitos. Cmd: $1-2 99
                  }
                  else { 
                    if ($readini(%Saldo,$2,Codigo) == $null) { .writeini %Saldo $2 Codigo $rand(0,9) $+ $rand(0,9) }
                    .set -u30 %Codigo $readini(%Saldo,$2,Codigo)
                    if (%Codigo == $3) { 
                      .set -z %Robar $+ $nick %Robar_Tiempo 
                      .writeini %Saldo $2 Codigo $rand(0,9) $+ $rand(0,9)
                      .set -u10 %Porciento $rand(50,100) 
                      .set -u10 %RoCoin $int($calc($readini(%Saldo,$2,Moneda) / %Porciento))
                      $Ruta(Saldo, $nick, Moneda, Saldo, +, %RoCoin)
                      $Ruta(Saldo, $2, Moneda, Saldo, -, %RoCoin)
                      $Ruta(Bote, Bote, Moneda, +, %RoCoin)
                      .msg $chan Usuario12 $nick has robado a12 $2 un total de12 $bytes(%RoCoin,b) $+ $ %Moneda $+ .
                    }
                    else {
                      .set -u10 %P1 $left($3,1) 
                      .set -u10 %P2 $right($3,1)
                      .set -u10 %S1 $left(%Codigo,1) 
                      .set -u10 %S2 $right(%Codigo,1)
                      .set -z %Robar $+ $nick $calc(%Robar_Tiempo / 50) 
                      if (%P1 == %S1) {
                        if (%P1 == %S2) { .msg $chan $nick codigo para $2 es03 %P1 $+ 01 $+ %P2 }
                        else { .msg $chan $nick codigo para $2 es03 %P1 $+ 04 $+ %P2 }
                      }
                      elseif (%P1 != %S1) {
                        if (%P2 != %S2) { 
                          if (%P1 == %S2) { 
                            if (%P2 == %S1) { .msg $chan $nick codigo para $2  es01 %P1 $+ 01 $+ %P2 }
                            elseif (%P2 != %S1) { .msg $chan $nick codigo para $2  es01 %P1 $+ 04 $+ %P2 }
                          }
                          elseif (%P1 != %S2) { 
                            if (%P2 == %S1) { .msg $chan $nick codigo para $2 es04 %P1 $+ 01 $+ %P2 }
                            elseif (%P2 != %S1) { .msg $chan $nick codigo para $2 es04 %P1 $+ 04 $+ %P2 }
                          }
                        }
                        elseif (%P2 == %S2) { 
                          if (%P1 == %S2) { .msg $chan $nick codigo para $2 es01 %P1 $+ 03 $+ %P2 }
                          else { .msg $chan $nick codigo para $2 es04 %P1 $+ 03 $+ %P2 }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        .unset %Porciento %RoCoin %P1 %P2 %S1 %S2 %Codigo | .halt
      } 
    }
  }

}
