set -e

export PATH="$(dirname $0:A):$PATH"

echo "Launching Tests"
zsh << "SCRIPT"
disable -r end
source <(antibody init)
antibody bundle rylnd/shpec
shpec
SCRIPT
