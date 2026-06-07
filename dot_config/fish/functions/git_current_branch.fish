function git_current_branch --description 'Print the current git branch name'
    set -l ref (git symbolic-ref --quiet HEAD 2>/dev/null)
    set -l ret $status
    if test $ret -ne 0
        if test $ret -eq 128
            # no git repo
            return
        end
        # detached HEAD: fall back to short SHA
        set ref (git rev-parse --short HEAD 2>/dev/null); or return
    end
    string replace 'refs/heads/' '' $ref
end
