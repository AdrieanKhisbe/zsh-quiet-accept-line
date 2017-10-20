Zsh Quiet-Accept-Line
=====================

[![Build Status](https://travis-ci.org/AdrieanKhisbe/zsh-quiet-accept-line.svg?branch=master)](https://travis-ci.org/AdrieanKhisbe/zsh-quiet-accept-line)

## About
The goal of this zsh plugin is to enable to run typed zsh command without triggering a new prompt and saving the query to the history


## Usage
This plugins define 3 `zle` widgets:

- `quiet-accept-line` bound to <kbd>C-x RET</kbd>/<kbd>C-x C-m</kbd>: run the current typed command, without output a new prompt
- `silent-accept-line` bound to <kbd>C-x C-j</kbd>: run the current typed command, without output a new prompt. output wil be suppressed
- `last-quiet-accept-line` bound to <kbd>C-x C-k</kbd>: restore to the prompt the last command that was run with `quiet/silent-accept-line``

Optionaly status code of the quietly runned command can be display.
To do so, set `ZLE_QAL_STATUS_DISPLAY` to `true`, `on` or `yes`.
(`QAL` stands for *Quiet Accept Line*)

## Installation

Just source [quiet-accept-line](./quiet-accept-line.zsh) content, or if you use a plugin manager set `adrieankhisbe/zsh-quiet-accept-line` as plugin:

- for [antigen](https://github.com/zsh-users/antigen), just add **zsh-quiet-accept-line** to your bundles as `adrieankhisbe/zsh-quiet-accept-line`
   `antigen bundle adrieankhisbe/zsh-quiet-accept-line`
- for [zplug](https://github.com/zplug/zplug), add `zplug "adrieankhisbe/zsh-quiet-accept-line"`

## Configuration

Output of the status code can be customized with the following variable:

- `ZLE_QAL_STATUS_DURATION`: how long status is displayed, blocking the prompt (default 0.5s)
- `ZLE_QAL_STATUS_OK`: what is output for successful command (default green `✔` with prompt color escape `%{%}`)
- `ZLE_QAL_STATUS_KO`: what is output for failing command (default red `✖` with prompt color escape `%{%}`)
  note that status is saved to `ZLE_QAL_STATUS` variable
