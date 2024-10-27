# -*- coding: utf-8 -*-
# Spec for the zle widgets

setopt aliases
source $(dirname $0:A)/../quiet-accept-line.plugin.zsh

OUTPUT=$(mktemp)
ZLE_CALL=()
stub_command zle 'ZLE_CALL+=( "$1 \"$PROMPT\"" )'
reset_stub_zle() { ZLE_CALL=(); }

with_stub_eval() {
    local tmp=$(mktemp)
    stub_command eval 'echo "$@" > '$tmp'; builtin eval ${@}'
    $1
    EVAL=$(cat $tmp)
    unstub_command eval
}

describe "Quiet Accept line"
    it "does nothing with no buffer prompt correctly"
        PROMPT=">"
        with_stub_eval quiet-accept-line
        assert equal "${ZLE_CALL[1]}" ''
        reset_stub_zle
    end
    it "reset prompt correctly"
        PROMPT=">"
        BUFFER="echo yo"
        with_stub_eval quiet-accept-line
        assert equal "${ZLE_CALL[1]}" 'reset-prompt ""'
        assert equal "${ZLE_CALL[2]}" '-R ">"'
        assert equal "${ZLE_CALL[3]}" 'reset-prompt ">"'
        reset_stub_zle
    end

    it "run BUFFER as a command"
        BUFFER="echo yo"
        with_stub_eval quiet-accept-line > $OUTPUT
        assert equal "$EVAL" "echo yo"
        assert glob "$(cat $OUTPUT)" "*yo*" # output is now padded
        reset_stub_zle
    end

    it "pass output to command if specified"
        BUFFER="echo yo"
        file_tmp=$(mktemp)
        function save-it() { cat > $file_tmp; }
        ZLE_QAL_COMMAND=save-it with_stub_eval quiet-accept-line > $OUTPUT
        assert equal "$EVAL" "echo yo"
        assert equal "$(cat $OUTPUT)" ""
        assert glob "$(cat $file_tmp)" "*yo*" # output is now padded
    end

    it "empty buffer after run"
        BUFFER="echo yo"
        with_stub_eval quiet-accept-line > $OUTPUT
        assert equal "$BUFFER" ""
        assert glob "$(cat $OUTPUT)" "*yo*" # output is now padded
        reset_stub_zle
    end

    it "save current line"
        BUFFER="echo save me"
        with_stub_eval quiet-accept-line > $OUTPUT
        assert equal "$BUFFER" ""
        assert equal "$ZLE_QAL_LAST" "echo save me"
        reset_stub_zle
    end
end

describe "Silent Accept line"

    it "run BUFFER as a command, quietly"
        BUFFER="echo yo"
        export ZLE_QAL_SILENT_DUMP_FILE=/dev/null
        with_stub_eval silent-accept-line > $OUTPUT
        assert equal "$EVAL" "echo yo"
        assert equal "$(cat $OUTPUT)" ""
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
        reset_stub_zle
    end
    it "does handles prompt correctly"
        PROMPT=">" BUFFER="echo yo"
        with_stub_eval silent-accept-line
        assert equal "${ZLE_CALL[1]}" 'reset-prompt ""'
        assert equal "${ZLE_CALL[2]}" '-R ">"'
        assert equal "${ZLE_CALL[3]}" 'reset-prompt ">"'
        assert equal "${ZLE_CALL[4]}" '-R ">"'
        assert equal "${ZLE_CALL[5]}" 'get-line ">"'
        reset_stub_zle
    end
end

describe "Pager Accept line"
    it "does nothing with no buffer prompt correctly"
       export BUFFER=""
        PROMPT=">"
        with_stub_eval pager-accept-line
        assert equal "${ZLE_CALL[1]}" ''
        reset_stub_zle
    end

    it "forward content to pager correctly"
        BUFFER="echo yo"
        file_tmp=$(mktemp)
        function save-it() { cat > $file_tmp; }
        export ZLE_QAL_PAGER=save-it
        with_stub_eval pager-accept-line > $OUTPUT
        assert equal "$EVAL" "echo yo"
        assert equal "$(cat $OUTPUT)" "" # no output
        assert equal "$(cat $file_tmp)" "yo"
        reset_stub_zle
    end
    it "does handles prompt correctly"
        PROMPT=">" BUFFER="echo yo"
        with_stub_eval pager-accept-line
        assert equal "${ZLE_CALL[1]}" 'reset-prompt ""'
        assert equal "${ZLE_CALL[2]}" '-R ">"'
        assert equal "${ZLE_CALL[3]}" 'reset-prompt ">"'
        assert equal "${ZLE_CALL[4]}" '-R ">"'
        assert equal "${ZLE_CALL[5]}" 'get-line ">"'
        reset_stub_zle
    end
end

describe "Compact Accept line"
    it "does nothing with no buffer prompt correctly"
        PROMPT=">"
        with_stub_eval compact-accept-line
        assert equal "${ZLE_CALL[1]}" ''
        reset_stub_zle
    end
    it "reset prompt correctly to short one"
        PROMPT=">"
        BUFFER="echo yo"
        with_stub_eval compact-accept-line
        assert equal "${ZLE_CALL[1]}" 'reset-prompt "%B$%b "'
        assert equal "${ZLE_CALL[2]}" '-R ">"'
        assert equal "${ZLE_CALL[3]}" 'accept-line ">"'
        reset_stub_zle
    end
    # no check, for "run BUFFER as a command" and "empty buffer after run",
    # accept-line takes cares of it
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
