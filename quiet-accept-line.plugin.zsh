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

# Zle Widget to execute command without adding it to history
# and triggering a new prompt
function quiet-accept-line () {
    # Backup and reset current buffer
    local _BUFFER="$BUFFER"; BUFFER=""
    ZLE_QAL_LAST="$_BUFFER"
    # Erase current prompt, replace by an invisible one
    # with same number of line
    PROMPT="$(repeat $(($(echo \"$PROMPT\"|wc -l) -1)) echo)"\
          zle reset-prompt; zle -R
    # TODO: only redraw if something was printed!

    # ! FIXME: add a separating line ???
    echo -n $reset_color
    # run command, capture and process log
    tmpfile=$(mktemp)
    eval $_BUFFER 2> >(sed "s:^:__ERR__>>:") | tee $tmpfile > /dev/null # hack to capture both
    if [ -s $tmpfile ] ; then
        echo $(tput dim)
        cat $tmpfile | sed "s:^__ERR__>>\(.*\)\$:$(tput setaf 1)\1$(tput setaf 0):" | sed "s:^:  :" | less
        # TODO: apply optional effect. (could be pager!) 💭💡
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
}
zle -N quiet-accept-line
bindkey "${ZLE_QAL_QUIET_KEY:-^X^M}" quiet-accept-line # ⌨️ this is "alt enter"

function silent-accept-line () {
    ZLE_QAL_LAST="$BUFFER"
    eval $BUFFER 2> >(sed "s:^:__ERR__>>:") >&1 >> $ZLE_QAL_SILENT_DUMP_FILE
    ZLE_QAL_STATUS=$?
    BUFFER=""
}
zle -N silent-accept-line
bindkey "${ZLE_QAL_SILENT_KEY:-^X^J}" silent-accept-line

# 💭💡 add variant for pager! page-accept-line (less/lets)

function last-quiet-accept-line () {
    BUFFER="$ZLE_QAL_LAST"
    zle end-of-line
}
zle -N last-quiet-accept-line
bindkey "${ZLE_QAL_LAST_KEY:-^X^K}" last-quiet-accept-line
# TODO: turn into a ring!
