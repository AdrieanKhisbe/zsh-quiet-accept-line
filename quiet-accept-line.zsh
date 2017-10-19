
function quiet-accept-line () {
    OLDPROMPT=$PROMPT
    local nline=$(echo "$PROMPT" |wc -l)
    if [ $nline = 1 ]; then PROMPT=""; else PROMPT="$(repeat $(($nline -1)) echo)"; fi
    local _BUFFER=$BUFFER
    BUFFER=""
    zle reset-prompt
    echo -n $reset_color
    eval $_BUFFER
    PROMPT=$OLDPROMPT
    zle reset-prompt
}
zle -N quiet-accept-line
bindkey '^X^M' quiet-accept-line
