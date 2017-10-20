# quiet-accept-line

ZLE_QAL_STATUS_OK="%{$fg_bold[green]%}✔"
ZLE_QAL_STATUS_KO="%{$fg_bold[red]%}✖"

# Zle Widget to execute command without adding it to history
# and triggering a new prompt
function quiet-accept-line () {
    # Backup and reset current buffer
    local _BUFFER="$BUFFER"; BUFFER=""
    ZLE_LAST_QUIET_ACCEPT_LINE="$_BUFFER"
    # Erase current prompt, replace by an invisible one
    # with same number of line
    PROMPT="$(repeat $(($(echo \"$PROMPT\"|wc -l) -1)) echo)" \
          zle reset-prompt
    echo -n $reset_color
    # run command
    eval $_BUFFER
    local _status=$?

    if $ZLE_QAL_DISPLAY_STATUS; then
        [ $_status -eq 0 ] && RPROMPT="$ZLE_QAL_STATUS_OK" zle reset-prompt \
                           || RPROMPT="$ZLE_QAL_STATUS_KO" zle reset-prompt
        sleep 0.5
    fi

    # reset original prompt
    zle reset-prompt
}
zle -N quiet-accept-line
bindkey '^X^M' quiet-accept-line

function silent-accept-line () {
    ZLE_LAST_QUIET_ACCEPT_LINE="$BUFFER"
    eval $BUFFER > /dev/null
    BUFFER=""
}
zle -N silent-accept-line
bindkey '^X^J' silent-accept-line

function last-quiet-accept-line () {
    BUFFER="$ZLE_LAST_QUIET_ACCEPT_LINE"
    zle end-of-line
}
zle -N last-quiet-accept-line
bindkey '^X^K' last-quiet-accept-line
