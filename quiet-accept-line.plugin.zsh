#       ___        _      _          _                      _        _     _
#      / _ \ _   _(_) ___| |_       / \   ___ ___ ___ _ __ | |_     | |   (_)_ __   ___
#     | | | | | | | |/ _ \ __|____ / _ \ / __/ __/ _ \ '_ \| __|____| |   | | '_ \ / _ \
#     | |_| | |_| | |  __/ ||_____/ ___ \ (_| (_|  __/ |_) | ||_____| |___| | | | |  __/
#      \__\_\\__,_|_|\___|\__|   /_/   \_\___\___\___| .__/ \__|    |_____|_|_| |_|\___|
#                                                    |_|
#                                                                                           Ξ

# quiet-accept-line
# Author: Adrien Becchis (@AdrieanKhisbe on github&twitter)
# Homepage: http://github.com/AdrieanKhisbe/zsh-quiet-accept-line
# License: MIT License<adriean.khisbe@live.fr>
# Version: v0.1.1
# Released on: 2020-08-30


ZLE_QAL_STATUS_DURATION=${ZLE_QAL_STATUS_DURATION:-0.5}
ZLE_QAL_STATUS_OK=${ZLE_QAL_STATUS_OK:-"%{$fg_bold[green]%}✔"}
ZLE_QAL_STATUS_KO=${ZLE_QAL_STATUS_KO:-"%{$fg_bold[red]%}✖"}

ZLE_QAL_SILENT_DUMP_FILE=${ZLE_QAL_SILENT_DUMP_FILE:-/tmp/zsh-quiet-accept-line-silent-$$.log}
ZLE_QAL_COMMAND=${ZLE_QAL_COMMAND:-cat}
ZLE_QAL_PAGER=${ZLE_QAL_PAGER:-$PAGER}
ZLE_QAL_COMPACT_PROMPT=${ZLE_QAL_COMPACT_PROMPT:-'%B$%b '}

# Zle Widget to execute command without adding it to history
# and triggering a new prompt
function quiet-accept-line () {
    # do nothing if nothing to do 🧠
    if [ -z "$BUFFER" ]; then
        return
    fi

    # Backup and reset current buffer
    local _BUFFER="$BUFFER"; BUFFER=""
    ZLE_QAL_LAST="$_BUFFER"
    local tmpfile=$(mktemp)
    eval $_BUFFER 2> >(sed "s:^:__ERR__>>:") | tee $tmpfile > /dev/null # hack to capture both
    # 💭 Maybe effect on cursor

    # ! FIXME: add a separating line ???
    echo -n $reset_color
    # run command, capture and process log
    if [ -s $tmpfile ] ; then
         # Erase current prompt, replace by an invisible one with same number of line
        PROMPT="" zle reset-prompt; zle -R

        # Display log from generated content
        {echo $(tput dim) ; cat $tmpfile ; } \
         | sed "s:^__ERR__>>\(.*\)\$:$(tput setaf 1)\1$(tput setaf 0):" \
         | sed "s:^:  :" \
         | ${ZLE_QAL_COMMAND:-cat} # apply optional effect with command
    fi
    # TODO: see for prefix of logs
    # todo: see if tail last line, specially if previous command was hidden too

    ZLE_QAL_STATUS=$?

    if [[ $ZLE_QAL_STATUS_DISPLAY =~ ^(true|on|yes)$ ]]; then
        [ $ZLE_QAL_STATUS -eq 0 ] \
            && RPROMPT="$ZLE_QAL_STATUS_OK" \
            || RPROMPT="$ZLE_QAL_STATUS_KO"
        zle reset-prompt; zle -R
        RPROMPT=""
        sleep $ZLE_QAL_STATUS_DURATION
    fi

    # reset original prompt
    zle reset-prompt
    zle get-line # can pop up ESC-Q command if any  # ❓ see if optional behavior
}
zle -N quiet-accept-line
bindkey "${ZLE_QAL_QUIET_KEY:-^X^M}" quiet-accept-line # ⌨️ this is "alt enter"

function pager-accept-line () {
    if [ -z "$BUFFER" ]; then return; fi

    # Backup and reset current buffer
    local _BUFFER="$BUFFER"; BUFFER=""

    ZLE_QAL_LAST="$_BUFFER"
    eval $_BUFFER \
      2> >(sed "s:^\(.*\)\$:$(tput setaf 1)\1$(tput setaf 0):") \
      | ${ZLE_QAL_PAGER:-less}
    ZLE_QAL_STATUS=$?

    # remove prompt and reset original prompt
    PROMPT="" zle reset-prompt; zle -R
    zle reset-prompt; zle -R
    zle get-line # can pop up ESC-Q command if any # ❓ see if make this optional behavior
}
zle -N pager-accept-line
bindkey "${ZLE_QAL_PAGER_KEY:-^X^\C-M}" pager-accept-line
bindkey "${ZLE_QAL_PAGER_KEY2:-\e^\C-M}" pager-accept-line

function compact-accept-line () {
    if [ -z "$BUFFER" ]; then return; fi
    PROMPT="$ZLE_QAL_COMPACT_PROMPT" zle reset-prompt; zle -R
    zle accept-line;
}
zle -N compact-accept-line
bindkey "${ZLE_QAL_COMPACT_KEY:-\C-N}" compact-accept-line

function silent-accept-line () {
    if [ -z "$BUFFER" ]; then return; fi
    # Backup and reset current buffer
    local _BUFFER="$BUFFER"; BUFFER=""

    ZLE_QAL_LAST="$_BUFFER"
    eval $_BUFFER > $ZLE_QAL_SILENT_DUMP_FILE
    ZLE_QAL_STATUS=$?

    # remove prompt and reset original prompt
    PROMPT="" zle reset-prompt; zle -R
    zle reset-prompt; zle -R
    zle get-line # can pop up ESC-Q command if any  # ❓ see if optional behavior
}
zle -N silent-accept-line
bindkey "${ZLE_QAL_SILENT_KEY:-^X^\C-N}" silent-accept-line

# 💭 Next ideas 💡
# +❗ add variants
#   - for pager! page-accept-line (less/lets)
#   -  to compact the prompt $ $BUFFER, result
# + Add qal cli to control var

function last-quiet-accept-line () {
    BUFFER="$ZLE_QAL_LAST"
    zle end-of-line
}
zle -N last-quiet-accept-line
bindkey "${ZLE_QAL_LAST_KEY:-^X^K}" last-quiet-accept-line
# TODO: turn into a ring!
