# Auto-regenerate completions when the binary is newer than the cached file.
# Completions are written to ~/.config/fish/completions/ and only refreshed
# after a tool upgrade — no startup cost once the file exists.

function __regen_completion -a name cmd
    set -l out ~/.config/fish/completions/$name.fish
    set -l bin (command -v $name 2>/dev/null)
    if test -z "$bin"
        return
    end
    if not test -f "$out"; or test "$bin" -nt "$out"
        eval $cmd > $out 2>/dev/null
    end
end

__regen_completion kubectl "kubectl completion fish"
__regen_completion helm    "helm completion fish"
__regen_completion flux    "flux completion fish"
__regen_completion docker  "docker completion fish"
__regen_completion flux-operator "flux-operator completion fish"
__regen_completion gcx "gcx completion fish"

# terraform uses -install-autocomplete which writes directly to the completions dir
if type -q terraform
    set -l tf_out ~/.config/fish/completions/terraform.fish
    set -l tf_bin (command -v terraform)
    if not test -f "$tf_out"; or test "$tf_bin" -nt "$tf_out"
        terraform -install-autocomplete 2>/dev/null
    end
end

functions -e __regen_completion
