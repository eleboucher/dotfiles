# Cache the output of a tool's shell-init command and source it, so each
# interactive shell sources a cached file instead of re-running the tool.
#
# Usage: __cache_init <tool> "<init command>"
#   e.g. __cache_init starship "starship init fish"
#
# The cache is regenerated when it is missing or older than the tool binary.
function __cache_init --argument-names tool cmd
    # Skip silently if the tool isn't installed.
    if not type -q $tool
        return 0
    end

    set -l cache_dir $HOME/.cache/fish-init
    set -l cache_file $cache_dir/$tool.fish
    set -l bin (command -v $tool)

    # Regenerate the cache if it's missing or the binary is newer.
    if not test -s $cache_file; or test $bin -nt $cache_file
        test -d $cache_dir; or mkdir -p $cache_dir
        eval $cmd >$cache_file 2>/dev/null
    end

    source $cache_file
end
