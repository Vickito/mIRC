### Hola 👋

Esté es un script diseñado para jugar en el irc.

Puedes modificarlo si gustas.
Esperó que los disfruten!
Usarlo con cuidado! 
Solo pido que lo uses con calma, de buena forma, por respeto y derecho del autor.
Y nada de plagios!
#
### Cómo puedo ponerlo en mi bot?
Es algo fácil...
1) Primero descargas los archivos, puedes usar `git clone https://github.com/Vickito/mIRC.git` desde tu consola o simplemente puedes clickear esto [Files](https://github.com/Vickito/mIRC/archive/refs/heads/main.zip)
2) Debes tener el `mIRC` [mIRC](https://www.mirc.com/get.html) antes que nada.
3) Te recomendaría un editor de codigos, como `Visual Code Studio` o `Nodejs` etc.
4) Puedes poner el archivo principal en la carpeta `scripts` de tu mIRC, cada vez que instala un mIRC se crea una carpeta con otros archivos dentro, ahí estará la carpeta `scripts`.
5) Luego en tu mIRC, puedes poner `/load -rs scripts/BotNick.mrc` y `/load -rs scripts/BotNick_Main.mrc` (desde la barra de msj). 
6) Si el paso anterior no te funcionó. Puedes presionar `Alt+R` o puedes ir a `Tools` y luego presionar `Scripts File...` Luego veras algunas pestañas como `Aliases`, `Popups`, `Remote`, `Users` y `Variables`. Pero donde debes presionar es en `Remote` ahí pondras el archivo. Si estás en `Remote` podras ver en la parte de arriba en la izquierda `File` y le daras a `Load...` o `Ctrl+L`. En ambos caso podrás elegir el archivo buscandolo.
#
### Modificar el archivo!
1) Debes cambiar la parte de `%Pass` para que tenga una clave privada, así solo tú tienes acceso a todas las funciones!
2) Si gustas, puedes cambiar `%Moneda` & `%Moneda2` a tu gusto, puedes ponerle los nombres que quieras, siempre y cuando siga la logica!
3) También la ruta, si es que quieres poner el archivo en otra carpeta que no sea `scripts/`.
4) Cambia el simbolo de `%prefix`, el predestinado es `!`.
#
### Luego de haber modificado el archivo...
1) Debes poner en el privado de tu bot `/msg TuNickBot !log in Pass`.
2) Te recuerdo: La clave la puedes cambiar en el archivo. Si crees que es mucho, puedes hacer `/auser tunick 300` desde el mismo Bot.
3) Luego puedes poner en tu sala `!Juegos enable` para activar los juegos y puedes usar `!Alta` para tener saldo.
4) Queda en ti usarlo bien!
#
### Si no sabes los comandos
Puedes usar `!Ayuda`
