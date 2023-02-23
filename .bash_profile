#
# bash Configuration Entrypoint
#

# Load all custom paths and manpaths from ~/.paths and ~/.manpaths
[[ -e ~/.shell/paths ]] && PATH=${PATH}:$(tr -s '\n' ':' < ~/.shell/paths)
[[ -e ~/.shell/manpaths ]] && MANPATH=$(tr -s '\n' ':' < ~/.shell/manpaths):${MANPATH}

# Load all shell configs
for file in bash_prompt exports aliases functions cloud extra; do
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
