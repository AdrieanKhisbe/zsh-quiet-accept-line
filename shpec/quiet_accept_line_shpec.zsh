# -*- coding: utf-8 -*-
# Spec for the zle widgets

setopt aliases
source $(dirname $0:A)/../quiet-accept-line.plugin.zsh

OUTPUT=$(mktemp)
ZLE_CALL=()
stub_command zle 'ZLE_CALL+=( "$1 \"$PROMPT\"" )'
reset_stub_zle() { ZLE_CALL=(); }

with_stub_eval() {
    stub_command eval 'EVAL="$@"; builtin eval ${@}'
    $1
    unstub_command eval
}

describe "Quiet Accept line"
    it "reset prompt correctly"
        PROMPT=">"
        with_stub_eval quiet-accept-line
        assert equal "${ZLE_CALL[1]}" 'reset-prompt ""'
        assert equal "${ZLE_CALL[2]}" '-R ">"'
        assert equal "${ZLE_CALL[3]}" 'reset-prompt ">"'
        reset_stub_zle
    end

    it "run BUFFER as a command"
        BUFFER="echo yo"
        with_stub_eval quiet-accept-line > $OUTPUT
        output=$(cat $OUTPUT)
        assert equal "$EVAL" "echo yo"
        assert equal "$output" "yo"
        reset_stub_zle
    end

    it "empty buffer after run"
        BUFFER="echo yo"
        with_stub_eval quiet-accept-line > $OUTPUT
        output=$(cat $OUTPUT)
        assert equal "$BUFFER" ""
        assert equal "$output" "yo"
        reset_stub_zle
    end

    it "save current line"
        BUFFER="echo save me"
        with_stub_eval quiet-accept-line > $OUTPUT
        assert equal "$BUFFER" ""
        assert equal "$ZLE_QAL_LAST" "echo save me"
    end
end

describe "Silent Accept line"

    it "run BUFFER as a command, quietly"
        BUFFER="echo yo"
        with_stub_eval silent-accept-line > $OUTPUT
        output=$(cat $OUTPUT)
        assert equal "$EVAL" "echo yo"
        assert equal "$output" ""
        reset_stub_zle
    end

    it "empty buffer after run"
        BUFFER="echo yo"
        with_stub_eval silent-accept-line
        assert equal "$BUFFER" ""
        reset_stub_zle
    end

    it "save current line"
        BUFFER="echo save me"
        with_stub_eval silent-accept-line
        assert equal "$BUFFER" ""
        assert equal "$ZLE_QAL_LAST" "echo save me"
    end
end

describe "Last Quiet Accept line"

    it "restore last qal"
        ZLE_QAL_LAST="echo my secret command"
        last-quiet-accept-line
        assert equal "$BUFFER" "echo my secret command"
    end

    it "goes to the end of the last qal"
        reset_stub_zle
        last-quiet-accept-line
        assert equal "${ZLE_CALL[1]}" "end-of-line \"$PROMPT"\"
        reset_stub_zle
    end
end
