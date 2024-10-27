Zsh Quiet-Accept-Line
=====================

[![Tag Version](https://img.shields.io/github/tag/AdrieanKhisbe/zsh-quiet-accept-line.svg)](https://github.com/AdrieanKhisbe/zsh-quiet-accept-line/tags)
[![Build Status](https://img.shields.io/github/checks-status/AdrieanKhisbe/zsh-quiet-accept-line/master)](https://github.com/AdrieanKhisbe/dirzsh-quiet-accept-lineactions/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


> **Zsh plugin** is to enable to run typed zsh command without triggering a new prompt and saving the query to the history

[![asciicast](https://asciinema.org/a/143440.png)](https://asciinema.org/a/143440) _(outputed now :scroll:)_

## Usage
This plugins define several `zle` widgets:

- `quiet-accept-line`: run the current typed command, without output a new prompt (it removes and rewrite command)
  - bound to <kbd>C-x RET</kbd>/<kbd>C-x C-m</kbd>, **<kbd>ESC ENTER</kbd>**, (this is <kbd>Alt enter</kbd> on macos). Configurable with `ZLE_QAL_QUIET_KEY`
- `pager-accept-line`: run the current typed command outputing output in pager, preserve(restore) existing prompt
  - bound to both <kbd>C-x C-RET</kbd>/<kbd>C-x C-m</kbd>, <kbd>ESC CTRL-ENTER</kbd> **AND** <kbd>A-C-m</kbd>, <kbd> CTRL-ALT-ENTER</kbd> (overridable with `ZLE_QAL_PAGER_KEY` and `ZLE_QAL_PAGER_KEY2`)
  - pager configurable with `ZLE_QAL_PAGER`, default to less

- `compact-accept-line`: run the current typed command persisting a more compact prompt
  - bound to <kbd>\C-N</kbd>/<kbd>C-n</kbd>,(overridable with `ZLE_QAL_COMPACT_KEY`)
  - compact prompt default to `$` bold, configurable with `ZLE_QAL_COMPACT_PROMPT`

- `silent-accept-line`: run the current typed command, without output a new prompt. output wil be suppressed
  -  bound to <kbd>^X^\C-N</kbd> aka <kbd>ESC C-N</kbd>  (overridable with `ZLE_QAL_SILENT_KEY`)
  - content is dump in a temporary file (`/tmp/zsh-quiet-accept-line-silent-$$.log` pattern). It can be configured with `ZLE_QAL_SILENT_DUMP_FILE` or disabled setting this env var to `/dev/null`
- `last-quiet-accept-line` bound to <kbd>C-x C-k</kbd>: restore to the prompt the last command that was run with `quiet/silent-accept-line``

Optionaly status code of the quietly runned command can be display.
To do so, set `ZLE_QAL_STATUS_DISPLAY` to `true`, `on` or `yes`.
(`QAL` stands for *Quiet Accept Line*)

Also note, after running a command, the eventual commands that where pushed with an `ESC-Q` are restored.

## Installation

Just source [quiet-accept-line](./quiet-accept-line.zsh) content, or if you use a plugin manager set `adrieankhisbe/zsh-quiet-accept-line` as plugin:

- for [antigen](https://github.com/zsh-users/antigen), just add **zsh-quiet-accept-line** to your bundles as `adrieankhisbe/zsh-quiet-accept-line`
   `antigen bundle adrieankhisbe/zsh-quiet-accept-line`
- same for [antidote](https://github.com/mattmc3/antidote) and [antibody](https://github.com/getantibody/antibody)
- for [zplug](https://github.com/zplug/zplug), add `zplug "adrieankhisbe/zsh-quiet-accept-line"`

## Configuration [TO BE UPDATED]

Keys can be configured based on the following variables: `ZLE_QAL_QUIET_KEY`, `ZLE_QAL_SILENT_KEY`, and `ZLE_QAL_LAST_KEY`. (default being `^X^M`, `^X^J` and `^X^K`)

Output of the status code can be customized with the following variable:

- `ZLE_QAL_STATUS_DURATION`: how long status is displayed, blocking the prompt (default 0.5s)
- `ZLE_QAL_STATUS_OK`: what is output for successful command (default green `✔` with prompt color escape `%{%}`)
- `ZLE_QAL_STATUS_KO`: what is output for failing command (default red `✖` with prompt color escape `%{%}`)
  note that status is saved to `ZLE_QAL_STATUS` variable

## About

This plugin was driven by the need to improve [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect/blob/master/CHANGELOG.md) zsh history saving that was poluting terminal with `fc` commands.
After some research I end up on the following [stack overflow question](https://unix.stackexchange.com/questions/336680/how-to-execute-command-without-storing-it-in-history-even-for-up-key-in-zsh), that inspired the initial implementation.
