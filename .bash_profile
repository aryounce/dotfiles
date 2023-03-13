#
# bash configuration entrypoint for interactive instances
#

# Load all custom paths and manpaths from ~/.paths and ~/.manpaths
export STARTING_PATH="${STARTING_PATH-$PATH}"

[[ -e ~/.shell/paths ]] && PATH="${STARTING_PATH}:$(tr -s '\n' ':' < ~/.shell/paths | sed -e "s+~+$HOME+g")"
[[ -e ~/.shell/manpaths ]] && MANPATH=$(tr -s '\n' ':' < ~/.shell/manpaths):${MANPATH}

# Detect if homebrew is installed and load 'bash-completion@2' if it is.
[[ $(which brew) ]] && [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && \
  source "$(brew --prefix)/etc/profile.d/bash_completion.sh"

# Load all shell configs
for file in exports aliases functions cloud extra bash_prompt; do
  file="${HOME}/.shell/${file}"
  [[ -e "${file}" ]] && source "${file}"
done

#
# General bash configuration, see:
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
#

shopt -s nocaseglob
shopt -s histappend
shopt -s checkwinsize
