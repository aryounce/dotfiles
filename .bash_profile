##
## bash configuration entrypoint for interactive instances
##

#
# Load all custom paths and manpaths from ~/.paths and ~/.manpaths
#

# Reset PATH to only include the paths provided by the system.
[[ -e /etc/paths ]] && PATH=$(tr -s '\n' ':' < /etc/paths)

# Add our own entries to PATH
[[ -e ~/.shell/paths ]] && PATH=${PATH}$(tr '\n\n' '\n' < ~/.shell/paths | tr -s '\n' ':')

# TODO Clean up MANPATH logic
[[ -e ~/.shell/manpaths ]] && MANPATH=$(tr -s '\n' ':' < ~/.shell/manpaths):${MANPATH}

#
# Load all shell configs
#
for file in bash_prompt exports aliases functions dev cloud extra;
do
  file="${HOME}/.shell/${file}"
  [[ -e "${file}" ]] && source "${file}"
done

# Load homebrew configs on macOS
[[ $(uname -s) == "Darwin" ]] && [[ -e ~/.shell/homebrew ]] && {
  source ~/.shell/homebrew
}

#
# bash options (see: https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)
#
shopt -s nocaseglob   # Makes filename expansion case-insensitive.
shopt -s histappend   # The history list will be appended to HISTFILE.
shopt -s checkwinsize # Updates LINES and COLUMNS after non-builtin execution.
