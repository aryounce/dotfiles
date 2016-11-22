## STANDARD CONFIG ###

# Load all custom paths and manpaths from ~/.paths and ~/.manpaths

[[ -e ~/.shell/paths ]] && PATH=${PATH}:$(tr -s '\n' ':' < ~/.shell/paths)
[[ -e ~/.shell/manpaths ]] && MANPATH=$(tr -s '\n' ':' < ~/.shell/manpaths):${MANPATH}

# Load all shell configs
for file in bash_prompt exports aliases functions extra; do
  file="${HOME}/.shell/${file}"
  [[ -e "${file}" ]] && source "${file}"
done

## GENERAL CONFIG ###

shopt -s nocaseglob
shopt -s histappend
shopt -s checkwinsize
