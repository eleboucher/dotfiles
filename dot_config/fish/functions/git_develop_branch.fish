function git_develop_branch --description 'Print the repository develop branch name'
    command git rev-parse --git-dir >/dev/null 2>&1; or return
    for branch in dev devel develop development
        if command git show-ref -q --verify refs/heads/$branch
            echo $branch
            return
        end
    end
    # fall back to develop
    echo develop
end
