#!/usr/bin/env bash
set -euo pipefail
 
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 [work|private] <git-clone-args...>"
  exit 1
fi
 
profile="$1"
shift
 
case "$profile" in
  work)
    GIT_NAME="Work User"
    GIT_EMAIL="work@example.com"
    GIT_SIGNINGKEY="WORKSIGNKEYID" # from your gpg keyring
    #####(in ~/.ssh/config)
    # Host workalias-fhskdhfu79878.github.com
    #    HostName github.com
    #    IdentityFile ~/.ssh/work_ecdsa
    SSH_ALIAS="workalias-fhskdhfu79878.github.com"
    ;;
  private)
    GIT_NAME="Private User"
    GIT_EMAIL="private@example.com"
    GIT_SIGNINGKEY="PRIVATESIGNKEYID" # from your gpg keyring
    #####(in ~/.ssh/config)
    # Host github.com
    #    HostName github.com
    #    IdentityFile ~/.ssh/private_ecdsa
    SSH_ALIAS="github.com"
    ;;
  *)
    echo "Unknown profile: $profile (expected 'work' or 'private')"
    exit 1
    ;;
esac
 
# ie. git@github.com:user/repo.git -> git@workalias-fhskdhfu79878.github.com:user/repo.git
args=("$@")
for i in "${!args[@]}"; do
  args[$i]="${args[$i]//github.com/$SSH_ALIAS}"
done
 
git clone "${args[@]}"
 
# Assumption: the final arg is probably the repo
repo_dir="$(basename "${args[-1]}" .git)"
 
if [[ ! -d "$repo_dir/.git" ]]; then
  echo "Could not determine cloned repo directory."
  exit 1
fi
 
(
  cd "$repo_dir"
  git config --local user.name "$GIT_NAME"
  git config --local user.email "$GIT_EMAIL"
  git config --local user.signingkey "$GIT_SIGNINGKEY"
  git config --local commit.gpgsign true
  git config --local tag.gpgsign true
  cd - >/dev/null
)
 
echo "Cloned and configured repository in '$repo_dir' for profile '$profile'."
