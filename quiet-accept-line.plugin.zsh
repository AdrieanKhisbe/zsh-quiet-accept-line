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
# Version: v0.1.0
# Released on: 2017-10-2#


ZLE_QAL_STATUS_DURATION=${ZLE_QAL_STATUS_DURATION:-0.5}
ZLE_QAL_STATUS_OK=${ZLE_QAL_STATUS_OK:-"%{$fg_bold[green]%}✔"}
ZLE_QAL_STATUS_KO=${ZLE_QAL_STATUS_KO:-"%{$fg_bold[red]%}✖"}

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
    echo -n $reset_color
    # run command
    eval $_BUFFER
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
bindkey "${ZLE_QAL_QUIET_KEY:-^X^M}" quiet-accept-line

function silent-accept-line () {
    ZLE_QAL_LAST="$BUFFER"
    eval $BUFFER > /dev/null
    ZLE_QAL_STATUS=$?
    BUFFER=""
}
zle -N silent-accept-line
bindkey "${ZLE_QAL_SILENT_KEY:-^X^J}" silent-accept-line

function last-quiet-accept-line () {
    BUFFER="$ZLE_QAL_LAST"
    zle end-of-line
}
zle -N last-quiet-accept-line
bindkey "${ZLE_QAL_LAST_KEY:-^X^K}" last-quiet-accept-line
