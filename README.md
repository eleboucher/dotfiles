# dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).
Hyprland + Noctalia, fish, ghostty, neovim (LazyVim), k9s.

Secrets (SSH keys, kubeconfig, talos config) are encrypted with
[age](https://age-encryption.org/). The age key is **not** in this repo.

## Bootstrap a new machine

1. Install `chezmoi`, `age`, and the [1Password CLI](https://developer.1password.com/docs/cli/).

2. Restore the age key from 1Password (vault `kubernetes`,
   document `chezmoi/sops age key (keys.txt)`):

   ```sh
   mkdir -p ~/.config/sops/age
   op document get "chezmoi/sops age key (keys.txt)" --vault kubernetes > ~/.config/sops/age/keys.txt
   chmod 600 ~/.config/sops/age/keys.txt
   ```

   (Or copy it from the 1Password app if `op` isn't authenticated yet.)

3. Apply:

   ```sh
   chezmoi init --apply eleboucher
   ```

## Secrets workflow

- CLI tokens (`GITHUB_TOKEN`, `GITLAB_TOKEN`, …) live in 1Password and are
  exported as fish universal variables locally (`set -Ux NAME value`).
  `fish_variables` is deliberately unmanaged (see `.chezmoiignore`).
- When rotating a token: update the 1Password item, then re-run `set -Ux`.
- `chezmoi add` refuses files containing secrets (`add.secrets = "error"`).
