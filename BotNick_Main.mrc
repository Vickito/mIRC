/**
* Archivo oficial, parte del archivo BotNick_Main.mrc
*
*/

alias -l Main {
  /set %Main $+(scripts\Game\,$network,\)
  /set %Saldo $+(%Main,Cuenta.txt) 
  /set %Banco $+(%Main,Banco.txt) 
  /set %Mod $+(%Main,Mod.txt)
  /set -i %prefix !

  if ($1 == Main) { 
    /load -rs scripts\BotNick_Main.mrc 
  } 

  if ($exists(%Main) == $false) { 
    .mkdir %Main 
    /writeini %Saldo Bote Moneda 25000 
    /writeini %Saldo Bote Moneda_2 25 
  }

  ;Simbolos y graficos. %Mo es de Moneda
  /set -i %Moneda Monedas 
  /set -i %Moneda_2 Diamantes

  ;Costo.
  /set -i %Contar 5 
  /set -i %Bote_Costo 15 
  /set -i %Moneda_2_Costo 1000 
  /set -i %Seguro_Costo 5

  if ($1 == Ban) { /msg $3 *Ban* $2 no podes jugar. Si crees que es un error ponte en contacto con un moderador. Usa !Mod. }

  ;$1 es para el nick
  if ($1 == Reg) { 
    ;Saldo
    /writeini %Saldo $2 Hora Ultima vez usado -> $asctime(dd/mmm/yyyy hh:nntt zzz)
    /writeini %Saldo $2 Reg $3-
    /writeini %Saldo $2 Seguro ON
    /writeini %Saldo $2 Info Activo 
    /writeini %Saldo $2 Moneda 1000 
    /writeini %Saldo $2 Moneda_2 10 
    ;Banco
    /writeini %Banco $2 Hora Ultima vez usado -> $asctime(dd/mmm/yyyy hh:nntt zzz)
    /writeini %Banco $2 Moneda 0 
    /writeini %Banco $2 Moneda_2 0
    ;Mensaje de salida
    /msg $2 Saldo $2 puedes usar %prefix $+ Ayuda en la sala para más información. 
  } 

  if ($1 == Hora) { /writeini % [ $+ [ $3 ] ] $2 Hora Ultima vez usado -> $asctime(dd/mmm/yyyy hh:nntt zzz) }

  ;$2 es para el nick y el $3 es para el comando.
  if ($1 == User) { 
    if ($3 == Moneda) { /return $bytes( $readini( %Saldo, $2, Moneda), b) }
    if ($3 == Moneda_2) { /return $bytes( $readini( %Saldo, $2, Moneda_2), b) }
    if ($3 == Botes) { /return $readini( %Saldo, $2, Botes) }
    if ($3 == Info) { /return $readini( %Saldo, $2, Info) }
    if ($3 == Seguro) { /return $readini( %Saldo, $2, Seguro) }
  } 
  if ($1 == Banco) { 
    if ($3 == Total) { /msg $4 Banco $2 un total de $bytes( $readini( %Banco, $2, Moneda), b) %Moneda $+ ,  $+ $bytes( $readini( %Banco, $2, Moneda_2), b) %Moneda_2 $+ . }
    if ($3 == Moneda) { /return $bytes( $readini( %Banco, $2, Moneda), b) }
    if ($3 == Moneda_2) { /return $bytes( $readini( %Banco, $2, Moneda_2), b) }
  }

  ;$2 es para el nick y el $1 es para la sala.
  Elseif ($1 == Aviso) { 
    /msg $2 Saldo $2 no tiene saldo, si quieres registrarse usa !Reg en la sala. $&
      Le recuerdo que su nick debe de tener el modo +r para evitar robos o perdida de saldo. 
  }
  Elseif ($1 == Avisa) { /msg $3 Banco $2 no tiene saldo. }

  ;$1 es para el nick, el $2 es para el comando, $3 es para la sala, $4 es para el archivo Saldo/Banco.
  Elseif ($1 == Poco) { 
    if ($3 == Moneda) { /msg $4 * $+ $5 $+  $2 Solo dispones de $bytes( $readini( % [ $+ [ $5 ] ], $2, Moneda), b) %Moneda $+ . }
    Elseif ($3 == Moneda_2) { /msg $4 * $+ $5 $+  $2 Solo dispones de $bytes( $readini( % [ $+ [ $5 ] ], $2, Moneda_2), b) %Moneda_2 $+ . }
  } 

  ;$1 es para el nick, $2 Moneda o Moneda_2, $3 Es Saldo o Banco, $4 es para quitar(-) o poner(+), $5 es la cantidad
  Elseif ($1 == Saldo) {
    if ($2 != $null) && ($3 != $null) && ($4 != $null) && ($5 != $null) { 
      /writeini % [ $+ [ $4 ] ] $2-3 $int( $calc( $readini( % [ $+ [ $4 ] ], $2, $3) $5-6)) 
    } 
  }

  Elseif ($1 == Bote) {
    if ($3 == Gana) { /writeini %Saldo Bote Gana $2 } 
    Else { /writeini %Saldo $2 $3 $int( $calc( $readini( %Saldo, $2, $3) $4-5)) } 
  } 
} 

On *:start: {
  /echo -s [******] BotNick [******] [15|08|2020]
  if (%Aviso_Main != $null) { 
    /msg %Aviso_Main Archivo $remove($nopath($script),.mrc) cargado correctamente!
    /unset %Aviso_Main 
  }
}

on *:text:!Main:*: {
.Main
  if ($level($nick) >= 200) { 
    if ($2 == $null) {
      /set -u30 %Aviso_Main $nick
      /reseterror 
      $Main(Main) 
    }
  } 
  /halt
}

On *:TEXT:*:#: { 
  .Main 
  if ($1 == %prefix $+ Juegos) || ($1 == %prefix $+ Juego) { 
    if ($level($nick) >= 200) { 
      if ($2 == Enable) { 
        if ($readini(%Saldo,+,$chan) == ON) { /msg $chan Juegos estan Enable. } 
        else { /writeini %Saldo + $chan ON | /msg $chan Juegos Activados... } 
      }
      elseif ($2 == Disable) { 
        if ($readini(%Saldo,+,$chan) == OFF) { /msg $chan Juegos estan Disable. } 
        else { /writeini %Saldo + $chan OFF | /msg $chan Juegos Desactivados... } 
      }
      else { 
        if ($readini(%Saldo,+,$chan) == ON) { /msg $chan Juegos Enable Para Desactivarlo usa Disable. } 
        else { /msg $chan Juegos Disable Para Activarlo usa Enable. } 
      }
    }
    /halt
  }

  if ($1 == %prefix $+ Ayuda) {
    if (%Ay1 [ $+ [ $nick ] ] != $null) { /halt } 
    else { 
      /inc -z %Ay1 $+ $nick 130
      /inc %Ay2 | /timer 1 %Ay2 /msg $nick Ayuda $nick
      /inc %Ay2 | /timer 1 %Ay2 /msg $nick !Reg [Para Saldo e Banco] 
      /inc %Ay2 | /timer 1 %Ay2 /msg $nick !Bote, !Saldo, !Transferir, !Vender, !Comprar, !Costo, !Banco, !Info, !Baja. 
      /inc %Ay2 | /timer 1 %Ay2 /msg $nick !Suerte, !Premio, !Robar, !Numero/!Mayor/!Menor y para ganar el bote, puedes usar !Suerte
      if ($level($nick) >= 200) {
        /inc %Ay2 | /timer 1 %Ay2 /msg $nick Mod
        /inc %Ay2 | /timer 1 %Ay2 /msg $nick !Reg nick [Puedes registrar a otros users]. !Info nick Unban/Ban [Puedes permitir o prohibir a alguien jugar (solo se debe usar en casos extremos)].
        /inc %Ay2 | /timer 1 %Ay2 /msg $nick !Juego Enbale/Disable [Para (des)activar los juegos en la salas].
      }
    }
    /unset %Ay2 | /halt
  }

  if ($readini( %Saldo, +, $chan) != ON) { 
    if ($level($nick) >= 200) { /msg $nick Juegos estan desactivados. }
    else { /halt }
    /halt 
  }
  if (%Tiempo [ $+ [ $nick ] ] == $null) { 

    if ($1 == %prefix $+ Reg) { 
      /inc -z %Tiempo $+ $nick 4
      if ($2 == $null) { 
        if ($readini( %Saldo, $nick, Reg) != $null) { /msg $chan Saldo $nick esta Registrado. } 
        else { $Main( Reg, $nick, Reg por $nick) } 
      }
      else { 
        if ($level($nick) >= 200) { 
          if ($readini( %Saldo, $2, Reg) != $null) { $Main( Avisa, $2, $chan) } 
          else { $Main( Reg, $2, Reg por $nick) } 
        } 
      } 
      /halt
    } 
    if ($1 == %prefix $+ Baja) {
      /inc -z %Tiempo $+ $nick 4
      if ($2 == $null) { 
        if ($readini( %Saldo, $nick, Reg) == $null) { /msg $chan Saldo $nick no esta Registrado. } 
        else { .remove %Saldo $nick | /msg $chan Saldo $nick dado de baja! } 
      }
      else { 
        if ($level($nick) >= 200) { 
          if ($readini( %Saldo, $2, Reg) != $null) { /msg $chan Saldo $2 no esta Registrado. } 
          else { .remove %Saldo $nick | /msg $chan Saldo $2 dado de baja! } 
        } 
      } 
    }

    elseif ($1 == %prefix $+ Costo) {
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        $Main( Hora, $nick, Saldo)
        /inc %Costo/Msg 1 | /timer 1 %Costo/Msg /msg $nick Usuario $nick el costo de los productos:
        /inc %Costo/Msg 1 | /timer 1 %Costo/Msg /msg $nick (=) %Moneda_2 es de %Moneda_2_Costo %Moneda 
        /inc %Costo/Msg 1 | /timer 1 %Costo/Msg /msg $nick (=) Bote es de %Bote_Costo %Moneda_2
        /inc %Costo/Msg 1 | /timer 1 %Costo/Msg /msg $nick (=) Seguro es de %Seguro_Costo %Moneda_2
        /unset %Costo.*
      }
      /halt
    } 

    elseif ($1 == %prefix $+ Saldo) {
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        $Main( Hora, $nick, Saldo)
        if ($2 == $null) || ($2 == $nick) { 
          /msg $chan Saldo $nick un total de $Main( User, $nick, Moneda) %Moneda y $Main( User, $nick, Moneda_2) %Moneda_2 $+ . Info $Main( User, $nick, Info) y Seguro $Main( User, $nick, Seguro) $+ .
        }
        else { 
          if ($readini( %Saldo, $2, Reg) == $null) { $Main( Avisa, $2, $chan) } 
          else { /msg $chan Saldo $2 un total de $Main( User, $2, Moneda) %Moneda y $Main( User, $2, Moneda_2) %Moneda_2 $+ . Info $Main( User, $2, Info) y Seguro $Main( User, $2, Seguro) $+ . }
        }
      }
      /halt
    }

    elseif ($1 == %prefix $+ Bote) {
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        $Main( Hora, $nick, Saldo)
        if ($2 == $null) { 
          if ($readini( %Saldo, Bote, Gana) != $null) { /set -u10 %Bote.Gana $readini( %Saldo, Bote, Gana) ultimo ganador. } 
          else { /unset %Bote.Gana }
          /msg $chan Bote $nick es de $bytes( $readini( %Saldo, Bote, Moneda), b) %Moneda y $bytes( $readini( %Saldo, Bote, Moneda_2), b) %Moneda_2 $+ . %Bote.Gana
        } 
      }
      /halt
    }

    elseif ($1 == %prefix $+ Info) { 
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        $Main( Hora, $nick, Saldo)
        if ($2 == $null) { 
          if ($readini(%Saldo, $nick, Info) == Activo) { /set -u10 %Info es Activo. } 
          else { set -u10 %Info es Ban. } 
          /msg $chan Info $nick %Info
        } 
        else { 
          if ($3 == $null) { 
            if ($readini(%Saldo, $2, Info) == Activo) { set -u10 %Info es Activo. } 
            else { set -u10 %Info es Ban. } 
            /msg $chan Info $2 %Info
            /unset %Info
          } 
          else {
            if ($level($nick) >= 200) { 
              if ($3 == Unban) { /writeini %Saldo $2 Info Activo | /msg $chan [Info: Activo] Para el usuario $2 } 
              elseif ($3 == Ban) { /writeini %Saldo $2 Info Ban | /msg $chan [Info: Ban] Para el usuario $2 } 
              else { /msg $chan $1-2 Unban/Ban } 
            } 
          } 
        }
      } 
      /halt
    } 

    elseif ($1 == %prefix $+ Transferir) {
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        $Main( Hora, $nick, Saldo)
        if ($2 == $null) || ($2 == $nick) { /msg $chan Transferir $nick -> $1 nick %Moneda $+ / $+ %Moneda_2 Cantidad }
        else {
          if ($readini( %Saldo, $2, Reg) == $null) { $Main( Avisa, $2, $chan) }
          else {
            if ($3 == Moneda) || ($3 == Monedas) { 
              if ($4 !isnum) || ($4 == 0) || ($4 == $null) { /msg $chan Transferir $nick -> $1 nick %Moneda Cantidad(1 a $Main( User, $nick, Moneda) $+ ) } 
              else { 
                if ($readini(%Saldo, $nick, Moneda) >= $4) { 
                  $Main( Saldo, $2, Moneda, Banco, +, $4) 
                  $Main( Saldo, $nick, Moneda, Saldo, -, $4)
                  /msg $chan Transferir $nick -> has dado a $2 un total de $bytes( $4, b) %Moneda $+ .
                } 
                else { $Main( Poco, $nick, Moneda, $chan, Saldo) } 
              } 
            }
            elseif ($3 == Diamante) || ($3 == Diamantes) { 
              if ($4 !isnum) || ($4 == 0) || ($4 == $null) { /msg $chan Transferir $nick -> $1 nick %Moneda_2 Cantidad(1 a $Main( User, $nick, Moneda_2) $+ ) } 
              else { 
                if ($readini(%Saldo, $nick, Moneda_2) >= $4) { 
                  $Main( Saldo, $2, Moneda_2, Banco, +, $4) 
                  $Main( Saldo, $nick, Moneda_2, Saldo, -, $4)
                  /msg $chan Transferir $nick -> has dado a $2 un total de $bytes( $4, b) %Moneda_2 $+ .
                } 
                else { $Main( Poco, $nick, Moneda_2, $chan, Saldo) } 
              } 
            }
            else { /msg $chan Transferir $nick -> $1 nick %Moneda $+ / $+ %Moneda_2 Cantidad }
          }
        }
      }
      /halt
    }

    elseif ($1 == %prefix $+ Vender) {
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        $Main( Hora, $nick, Saldo)
        if ($2 == Diamante) || ($2 == Diamantes) { 
          if ($3 !isnum) || ($3 == 0) || ($3 == $null) { /msg $chan Vender $nick -> $1 %Moneda_2 Cantidad(1 a $Main( User, $nick, Moneda_2) $+ ) } 
          else { 
            if ($Main( User, $nick, Moneda_2) >= $3) { 
              $Main( Saldo, $nick, Moneda, Saldo, +, $calc(%Moneda_2_Costo * $3))
              $Main( Saldo, $nick, Moneda_2, Saldo, -, $3)
              $Main( Bote, Bote, Moneda_2, +, $3)
              /msg $chan Vender $nick has vendido un total de $bytes( $3, b) %Moneda_2 por la cantidad de $bytes( $int( $calc( %Moneda_2_Costo * $3)), b) %Moneda $+ .
            } 
            else { $Main( Poco, $nick, Moneda, $chan, Saldo) } 
          } 
        }
        else { /msg $chan Vender $nick -> $1 %Moneda_2 }
      }
      /halt
    }

    elseif ($1 == %prefix $+ Comprar) {
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        $Main( Hora, $nick, Saldo)
        if ($2 == Diamante) || ($2 == Diamantes) { 
          if ($3 !isnum) || ($3 == 0) || ($3 == $null) { /msg $chan Comprar $nick -> $1-2 Cantidad(1 a 10000) } 
          else { 
            /set %Comprar_Costo $calc($3 * %Moneda_2_Costo)
            if ($Main( User, $nick, Moneda) >= %Comprar_Costo) { 
              $Main( Saldo, $nick, Moneda_2, Saldo, +, $3)
              $Main( Saldo, $nick, Moneda, Saldo, -, %Comprar_Costo)
              $Main( Bote, Bote, Moneda, +, $3)
              /msg $chan Comprar $nick has obtenido $bytes( $3, b) %Moneda_2 por $bytes( $int(%Comprar_Costo), b) %Moneda $+ .
            }
            else { $Main(Poco, $nick, Moneda, $chan, Saldo) } 
          } 
        }
        elseif ($2 == Seguro) { 
          if ($Main( User, $nick, Seguro) == ON) { /msg $chan Usuario $nick dispones un seguro. }
          else {
            if ($Main( User, $nick, Moneda_2) >= %Seguro_Costo) { 
              /writeini %Saldo $nick Seguro ON 
              $Main( Saldo, $nick, Moneda_2, Saldo, -, %Seguro_Costo)
              $Main( Bote, Bote, Moneda_2, +, %Seguro_Costo)
              /msg $chan Comprar $nick has obtenido un Seguro, por %Seguro_Costo %Moneda_2 $+ .
            }
            else { $Main( Poco, $nick, Moneda_2, $chan, Saldo) } 
          }
        }
        else { /msg $chan Comprar $nick -> $1 %Moneda_2 $+ /Seguro }
      }
      /unset %Comprar_Costo | /halt
    }

    elseif ($1 == %prefix $+ Banco) {
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else {  
        $Main(Hora, $nick, Banco)
        if ($2 == Saldo) || ($2 == Info) {
          if ($3 == $null) || ($3 == $nick) { $Main( Banco, $nick, Total, $chan) }
          else { 
            if ($level($nick) >= 300) { 
              if ($readini(%Saldo,$3,Reg) == $null) { $Main( Avisa, $nick, $chan) } 
              else { $Main( Banco, $3, Total, $chan) } 
            }
          }
        }
        elseif ($2 == Ingreso) || ($2 == Ingresar) {
          if ($3 == Moneda) || ($3 == Monedas) { 
            if ($4 !isnum) || ($4 == 0) || ($4 == $null) { /msg $chan Banco $nick -> $1 %Moneda Cantidad(1 a $Main( User, $nick, Moneda) $+ ) } 
            else { 
              if ($readini(%Saldo, $nick, Moneda) >= $4) { 
                $Main( Saldo, $nick, Moneda, Banco, +, $4) 
                $Main( Saldo, $nick, Moneda, Saldo, -, $4)
                /msg $chan Banco $nick has ingresado $bytes( $4, b) %Moneda a tu cuenta.
              } 
              else { $Main( Poco, $nick, Moneda, $chan, Saldo) } 
            } 
          }
          elseif ($3 == Diamante) || ($3 == Diamantes) { 
            if ($4 !isnum) || ($4 == 0) || ($4 == $null) { /msg $chan Usuario usa $1 %Moneda_2 Cantidad(1 a $Main( User, $nick, Moneda_2) $+ ) } 
            else { 
              if ($readini(%Saldo, $nick, Moneda_2) >= $4) { 
                $Main( Saldo, $nick, Moneda_2, Banco, +, $4) 
                $Main( Saldo, $nick, Moneda_2, Saldo, -, $4)
                /msg $chan Banco $nick has ingresado $bytes( $4, b) %Moneda_2 a tu cuenta.
              } 
              else { $Main( Poco, $nick, Moneda_2, $chan, Saldo) } 
            } 
          } 
          else { /msg $chan Banco $nick -> $1-2 %Moneda o %Moneda_2 y cantidad }
        }
        elseif ($2 == Retiro) || ($2 == Retirar) {
          if ($3 == Moneda) || ($3 == Monedas) { 
            if ($4 !isnum) || ($4 == 0) || ($4 == $null) { /msg $chan Banco $nick -> $1 %Moneda Cantidad(1 a $Main( User, $nick, Moneda) $+ ) } 
            else { 
              if ($readini(%Saldo, $nick, Moneda) >= $4) { 
                $Main(Banco, $nick, Moneda, Banco, -, $4)
                $Main(Banco, $nick, Moneda, Saldo, +, $4)
                /msg $chan Banco $nick has retirado $bytes( $4, b) %Moneda de tu cuenta.
              } 
              else { $Main( Poco, $nick, Moneda, $chan, Banco) } 
            } 
          }
          elseif ($3 == Diamante) || ($3 == Diamantes) { 
            if ($4 !isnum) || ($4 == 0) || ($4 == $null) { /msg $chan Banco $nick -> $1 %Moneda_2 Cantidad(1 a $Main( User, $nick, Moneda_2) $+ ) } 
            else { 
              if ($readini(%Saldo, $nick, Moneda_2) >= $4) { 
                $Main( Banco, $nick, Moneda_2, Banco, -, $4)
                $Main( Banco, $nick, Moneda_2, Saldo, +, $4)
                /msg $chan Banco $nick has retirado $bytes( $4, b) %Moneda_2 de tu cuenta.
              } 
              else { $Main( Poco, $nick, Moneda_2, $chan, Banco) } 
            } 
          } 
          else { /msg $chan Banco $nick -> $1-2 %Moneda $+ / $+ %Moneda_2 }
        }
        else { /msg $chan Banco $nick -> $1 Saldo/Ingresar/Retirar }
      }
      /halt
    }

    elseif ($1 == !Suerte) || ($1 == .Suerte) || ($1 == @Suerte) { 
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        if ($Main( User, $nick, Info) == Ban) { $Main( Ban, $nick, $chan) } 
        else { 
          if ($readini( %Saldo, $nick, Moneda) < 500) { /msg $chan Suerte $nick necesitas 500 %Moneda $+ . }
          else { 
            /set -u10 %Suerte $rand( 1, 12) 
            if (%Suerte == 1) { 
              /msg $chan Suerte $nick debe de ser tu dia de suerte, te llevas $bytes( $readini( %Saldo, Bote, Moneda), b) %Moneda y $bytes( $readini( %Saldo, Bote, Moneda_2),b) %Moneda_2 $+ .
              $Main( Saldo, $nick, Botes, Saldo, +, 1)
              $Main( Bote, $nick, Gana) 
              $Main( Saldo, $nick, Moneda, Saldo, +, $readini( %Saldo, Bote, Moneda)) 
              $Main( Saldo, $nick, Moneda_2, Saldo, +, $readini( %Saldo, Bote, Moneda_2))
              $Main( Bote, Bote, Moneda, +, 1000) 
              $Main( Bote, Bote, Moneda_2, +, 10) 
            } 
            elseif (%Suerte == 2) || (%Suerte == 3) || (%Suerte == 4) || (%Suerte == 5) || (%Suerte == 6) { 
              /set -u10 %Suerte_rand $rand( 200, 800) 
              $Main( Saldo, $nick, Moneda, Saldo, +, %Suerte_rand)
              $Main( Bote, Bote, Moneda, +, $calc(%Suerte_rand / 2))
              /msg $chan Suerte $nick tuviste suerte, ganas $bytes( %Suerte_rand, b) %Moneda $+ .
            }
            else { 
              /set -u10 %Suerte_rand $rand( 100, 500) 
              $Main( Saldo, $nick, Moneda, Saldo, -, %Suerte_rand)
              $Main( Bote, Bote, Moneda, +, %Suerte_rand)
              /msg $chan Suerte $nick mala suerte, pierdes $bytes( %Suerte_rand, b) %Moneda $+ .
            } 
          }
        }
      }
      %Suerte* | /halt
    }

    elseif ($1 == !Premio) || ($1 == .Premio) || ($1 == @Premio) { 
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        if ($Main( User, $nick, Info) == Ban) { $Main( Ban, $nick, $chan) } 
        else { 
          /set -u10 %Premio_rand $rand(50,500)
          /msg $chan Premio $nick tu Premio es $bytes( %Premio_rand, b) %Moneda $+ .
          $Main( Saldo, $nick, Moneda, Saldo, +, %Premio_rand) 
        }
      }
      /unset %Premio* | /halt
    }

    elseif ($1 == !Numero) || ($1 == .Numero) || ($1 == @Numero) { 
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        if ($Main( User, $nick, Info) == Ban) { $Main( Ban, $nick, $chan) } 
        else { 
          if ($readini(%Saldo,$nick,Numero) == $null) { 
            /writeini %Saldo $nick Numero $rand(1,10) | /writeini %Saldo $nick Puntos 0
            /msg $chan Numero $nick tu numero es $readini( %Saldo, $nick, Numero) Pon !Mayor o !Menor para jugar. 
          }
          else { /msg $chan Numero $nick tu numero es $readini( %Saldo, $nick, Numero) con $readini( %Saldo, $nick, Puntos) puntos. Tip: Cada punto es 50 %Moneda $+ . }
        }
      }
      /halt
    }

    elseif ($1 == !Mayor) || ($1 == .Mayor) || ($1 == @Mayor) {
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        if ($Main( User, $nick, Info) == Ban) { $Main( Ban, $nick, $chan) } 
        else { 
          if ($readini( %Saldo, $nick, Numero) == $null) { /msg $chan Numero $nick usa !Numero y luego usa $1 }
          else {
            /set %Mayor $rand(1,10) 
            if ($readini( %Saldo, $nick, Numero) <= %Mayor) { 
              /writeini %Saldo $nick Numero %Mayor 
              /writeini %Saldo $nick Puntos $calc($readini(%Saldo,$nick,Puntos) + 1)
              /msg $chan Mayor $nick Tu numero ahora es $readini( %Saldo, $nick, Numero) y te llevas 1 punto.
            }
            else {  
              if ($readini( %Saldo, $nick, Puntos) == 0) { /msg $chan Mayor $nick ups perdiste. Tu numero es %Mayor  y no ganas nada. }
              else {
                $Main( Saldo, $nick, Moneda, Saldo, +, $calc( $readini( %Saldo, $nick, Puntos) * 50))
                /msg $chan Mayor $nick ups perdiste. Tu numero es %Mayor y ganas $calc( $readini( %Saldo, $nick, Puntos) * 50) %Moneda $+ .
                /writeini %Saldo $nick Numero %Mayor 
                /writeini %Saldo $nick Puntos 0 
              }
            }
          }
        }
      }
      /unset %Mayor | /halt
    }

    elseif ($1 == !Menor) || ($1 == .Menor) || ($1 == @Menor) { 
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        if ($Main( User, $nick, Info) == Ban) { $Main( Ban, $nick, $chan) } 
        else { 
          if ($readini( %Saldo, $nick, Numero) == $null) { /msg $chan Numero $nick usa !Numero y luego usa $1 }
          else {
            /set %Menor $rand(1,10) 
            if ($readini( %Saldo, $nick, Numero) >= %Menor) { 
              /writeini %Saldo $nick Numero %Menor 
              /writeini %Saldo $nick Puntos $calc($readini(%Saldo,$nick,Puntos) + 1)
              /msg $chan Menor $nick Tu numero ahora es $readini(%Saldo,$nick,Numero) y te llevas 1 punto.
            }
            else { 
              if ($readini( %Saldo, $nick, Puntos) == 0) { /msg $chan Menor $nick ups perdiste. Tu numero es %Mayor  y no ganas nada. }
              else {
                $Main( Saldo, $nick, Moneda, Saldo, +, $calc( $readini( %Saldo, $nick, Puntos) * 50))
                /msg $chan Menor $nick ups perdiste. Tu numero es %Menor y ganas $calc( $readini( %Saldo, $nick, Puntos) * 50) %Moneda $+ .
                /writeini %Saldo $nick Numero %Menor 
                /writeini %Saldo $nick Puntos 0 
              }
            }
          }
        }
      }
      /unset %Menor | /halt
    }

    elseif ($1 == !Robar) || ($1 == .Robar) || ($1 == @Robar) { 
      /inc -z %Tiempo $+ $nick 4
      if ($readini( %Saldo, $nick, Reg) == $null) { $Main( Aviso, $nick) }
      else { 
        if ($Main( User, $nick, Info) == Ban) { $Main( Ban, $nick, $chan) } 
        else { 
          if (%Robar [ $+ [ $nick ] ] != $null) { /msg $chan Robar $nick debes esperar $duration(%Robar [ $+ [ $nick ] ]) $+ ! }
          else {
            /set -i %Robar_Tiempo 60
            if ($2 == $null) { /msg $chan Robar $nick dame un nick. Cmd: $1 nick codigo. }
            else {
              if ($readini( %Saldo, $2, Reg) == $null) { $Main( Avisa, $2) } 
              elseif ($2 == $nick) { /msg $chan Robar $nick no podes robarte a ti mismo/a. }
              else { 
                if ($Main( User, $2, Seguro) == ON) {
                  /writeini %Saldo $2 Seguro OFF 
                  /msg $chan Robar $nick rompiste la seguridad de $2 :D... 
                }
                else { 
                  if ($3 == $null) || ($3 !isnum) || ($len($3) != 2) { /msg $chan Robar $nick debes de adivinar el codigo de $2 dos digitos. Cmd: $1-2 99 }
                  else { 
                    if ($readini( %Saldo, $2, Codigo) == $null) { /writeini %Saldo $2 Codigo $rand( 0, 9) $+ $rand( 0, 9) }
                    /set -u30 %Codigo $readini( %Saldo, $2, Codigo)
                    if (%Codigo == $3) { 
                      /set -z %Robar $+ $nick %Robar_Tiempo 
                      /writeini %Saldo $2 Codigo $rand( 0, 9) $+ $rand( 0, 9)
                      /set -u10 %Porciento $rand(50,100) 
                      /set -u10 %RoMoneda $int( $calc( $readini( %Saldo, $2, Moneda) / %Porciento))
                      $Main( Saldo, $nick, Moneda, Saldo, +, %RoMoneda)
                      $Main( Saldo, $2, Moneda, Saldo, -, %RoMoneda)
                      $Main( Bote, Bote, Moneda, +, %RoMoneda)
                      /msg $chan Robar $nick has robado a $2 un total de $bytes( %RoMoneda, b) %Moneda $+ .
                    }
                    else {
                      /set -u10 %P1 $left( $3, 1) 
                      /set -u10 %P2 $right( $3, 1)
                      /set -u10 %S1 $left( %Codigo, 1) 
                      /set -u10 %S2 $right( %Codigo, 1)
                      /set -z %Robar $+ $nick $calc(%Robar_Tiempo / 6) 
                      if (%P1 == %S1) {
                        if (%P1 == %S2) { /msg $chan Robar $nick codigo para $2 es %P1 $+  $+ %P2 }
                        else { /msg $chan Robar $nick codigo para $2 es %P1 $+  $+ %P2 }
                      }
                      elseif (%P1 != %S1) {
                        if (%P2 != %S2) { /msg $chan Robar $nick codigo para $2 es %P1 $+  $+ %P2 }
                        elseif (%P2 == %S2) { /msg $chan Robar $nick codigo para $2 es %P1 $+  $+ %P2 }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        /unset %Porciento %RoMoneda %P1 %P2 %S1 %S2 %Codigo | /halt
      } 
    }
  }

}
