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

## Installation

Just source [diraction](./quiet-accept-line.zsh) content, or if you use a plugin manager add `adrieankhisbe/zsh-quiet-accept-line` as plugin:

- for [antigen](https://github.com/zsh-users/antigen), just add **zsh-quiet-accept-line** to your bundles as `adrieankhisbe/zsh-quiet-accept-line`
   `antigen bundle adrieankhisbe/zsh-quiet-accept-line`
- for [zplug](https://github.com/zplug/zplug), add `zplug "adrieankhisbe/zsh-quiet-accept-line"`
