

Zsh Quiet-Accept-Line
=====================

[![Tag Version](https://img.shields.io/github/tag/AdrieanKhisbe/zsh-quiet-accept-line.svg)](https://github.com/AdrieanKhisbe/zsh-quiet-accept-line/tags)
[![Build Status](https://img.shields.io/github/checks-status/AdrieanKhisbe/zsh-quiet-accept-line/master)](https://github.com/AdrieanKhisbe/zsh-quiet-accept-line/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


> Este **plugin de Zsh** te permite ejecutar comandos escritos en zsh sin generar un nuevo prompt, sin guardar entradas en el historial y sin que se muestre la salida.

Aquí hay una (_ya obsoleta_ :scroll:) vista previa :clapper::

[![asciicast](https://asciinema.org/a/143440.png)](https://asciinema.org/a/143440)

## Uso
Este plugin define varios widgets `zle` para ejecutar comandos desde la shell como variantes del clásico `accept-line`:

- `quiet-accept-line`: Ejecuta el comando actual escrito, sin generar un nuevo prompt (elimina y reescribe el búfer)
  - vinculado a <kbd>C-x RET</kbd>/<kbd>C-x C-m</kbd>, **<kbd>ESC ENTER</kbd>**, (en macOS es <kbd>Alt enter</kbd>). Configurable con `ZLE_QAL_QUIET_KEY`
  - la salida se puede redirigir mediante tubería a un programa/función personalizada con `ZLE_QAL_COMMAND`
- `pager-accept-line`: Ejecuta el comando actual escrito y redirige la salida a un pager, preservando (restaurando) el prompt existente
  - vinculado a <kbd>C-x C-RET</kbd>/<kbd>C-x C-m</kbd>, <kbd>ESC CTRL-ENTER</kbd> **Y** <kbd>A-C-m</kbd>, <kbd> CTRL-ALT-ENTER</kbd> (sobrescribible con `ZLE_QAL_PAGER_KEY` y `ZLE_QAL_PAGER_KEY2`)
  - pager configurable con `ZLE_QAL_PAGER`, por defecto `less`

- `compact-accept-line`: ejecuta el comando actual escrito mostrando un prompt más compacto
  - vinculado a <kbd>\C-N</kbd>/<kbd>C-n</kbd>, (sobrescribible con `ZLE_QAL_COMPACT_KEY`)
  - el prompt compacto es por defecto `$` en negrita, configurable con `ZLE_QAL_COMPACT_PROMPT`

- `silent-accept-line`: Ejecuta el comando actual escrito, sin generar un nuevo prompt. La salida se suprimirá
  -  vinculado a <kbd>^X^\C-N</kbd> alias <kbd>ESC C-N</kbd>  (sobrescribible con `ZLE_QAL_SILENT_KEY`)
  - el contenido se volca en un archivo temporal (patrón `/tmp/zsh-quiet-accept-line-silent-$$.log`). Se puede configurar con `ZLE_QAL_SILENT_DUMP_FILE` o desactivarse estableciendo esta variable de entorno a `/dev/null`
- `last-quiet-accept-line` vinculado a <kbd>C-x C-k</kbd>: restaura en el prompt el último comando que se ejecutó con `quiet/silent-accept-line`

- `history-ignore-accept-line`: ejecuta el comando actual escrito anteponiéndole un espacio para que no se almacene en el historial
  - vinculado a <kbd>C-x C-SPC</kbd> (sobrescribible con `ZLE_QAL_HISTORY_IGNORE_KEY`)


Opcionalmente, se puede mostrar el código de estado del comando ejecutado en silencio.
Para hacerlo, establece `ZLE_QAL_STATUS_DISPLAY` en `true`, `on` o `yes`.
(`QAL` son las siglas de *Quiet Accept Line*)

Ten también en cuenta que, después de ejecutar un comando, los comandos eventuales que se hubieran guardado con `ESC-Q` se restauran.

## Instalación

Simplemente ejecuta `source` con el contenido de [quiet-accept-line](./quiet-accept-line.zsh), o si usas un gestor de plugins, configura `adrieankhisbe/zsh-quiet-accept-line` como plugin:

- para [antigen](https://github.com/zsh-users/antigen), simplemente añade **zsh-quiet-accept-line** a tus bundles como `adrieankhisbe/zsh-quiet-accept-line`
   `antigen bundle adrieankhisbe/zsh-quiet-accept-line`
- lo mismo para [antidote](https://github.com/mattmc3/antidote) y [antibody](https://github.com/getantibody/antibody)
- para [zplug](https://github.com/zplug/zplug), añade `zplug "adrieankhisbe/zsh-quiet-accept-line"`

## Configuración

Las teclas se pueden configurar según las siguientes variables y sus valores por defecto:
- `ZLE_QAL_QUIET_KEY` (default `^X^M`, <kbd>Ctrl-X</kbd> <kbd>Ctrl-M</kbd>)
- `ZLE_QAL_SILENT_KEY` (default `^X^J`, <kbd>Ctrl-X</kbd> <kbd>Ctrl-J</kbd>)
- `ZLE_QAL_COMPACT_KEY` (default `^N`, <kbd>Ctrl-N</kbd>)
- `ZLE_QAL_PAGER_KEY` (default `^X^\C-M`, <kbd>Ctrl-X</kbd> <kbd>ESC</kbd> <kbd>Ctrl-M</kbd>)
- `ZLE_QAL_PAGER_KEY2` (default `\e^\C-M`, <kbd>ESC</kbd> <kbd>Ctrl-M</kbd>)
- `ZLE_QAL_LAST_KEY` (default `^X^K`, <kbd>Ctrl-X</kbd> <kbd>Ctrl-K</kbd>)
- `ZLE_QAL_HISTORY_IGNORE_KEY` (default `^X^ `, <kbd>Ctrl-X</kbd> <kbd>Ctrl-Space</kbd>)


La salida del código de estado se puede personalizar con las siguientes variables:

- `ZLE_QAL_STATUS_DURATION`: cuánto tiempo se muestra el estado, bloqueando el prompt (por defecto 0.5s)
- `ZLE_QAL_STATUS_OK`: qué se muestra para un comando exitoso (por defecto `✔` verde con el escape de color del prompt `%{%}`)
- `ZLE_QAL_STATUS_KO`: qué se muestra para un comando fallido (por defecto `✖` rojo con el escape de color del prompt `%{%}`)
  ten en cuenta que el estado se guarda en la variable `ZLE_QAL_STATUS`

Como se mencionó en la sección de uso, algunos comportamientos se pueden configurar, en particular:

- `ZLE_QAL_COMMAND`: comando para redirigir mediante tubería los registros (logs) del comando para `quiet-accept-line`
- `ZLE_QAL_PAGER`: pager para `pager-accept-line`, por defecto `$PAGER`
- `ZLE_QAL_SILENT_DUMP_FILE` por defecto (`/tmp/zsh-quiet-accept-line-silent-$$.log`), desactívelo con `/dev/null`
- `ZLE_QAL_COMPACT_PROMPT`: prompt compacto para `compact-accept-line`, por defecto `%B$%b `


## Acerca de

Este plugin nació de la necesidad de mejorar la guardación del historial de zsh de [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect/blob/master/CHANGELOG.md), que estaba ensuciando el terminal con comandos `fc`.
Después de alguna investigación, encontré la siguiente [pregunta en Stack Overflow](https://unix.stackexchange.com/questions/336680/how-to-execute-command-without-storing-it-in-history-even-for-up-key-in-zsh), la cual inspiró la implementación inicial.
