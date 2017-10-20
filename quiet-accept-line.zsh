# quiet-accept-line

# Zle Widget to execute command without adding it to history
# and triggering a new prompt
function quiet-accept-line () {
    # Backup prompt and build an invisible one with same
    # number of line
    OLDPROMPT="$PROMPT"
    local nline=$(echo "$PROMPT" |wc -l)
    if [ $nline = 1 ]
    then PROMPT=""
    else PROMPT="$(repeat $(($nline -1)) echo)"
    fi
    # Backup and reset current buffer
    ZLE_LAST_QUIET_ACCEPT_LINE="$BUFFER"
    local _BUFFER="$BUFFER"
    BUFFER=""
    # Erase current prompt
    zle reset-prompt
    echo -n $reset_color
    # run command
    eval $_BUFFER
    # reset original prompt
    PROMPT="$OLDPROMPT"
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
}
zle -N last-quiet-accept-line
bindkey '^X^K' last-quiet-accept-line
