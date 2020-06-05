#!/bin/bash
#
# Synchronize this repository with the dotfiles in $HOME.
#

[[ ! -e manifest.txt ]] && \
    echo "This script must be run from the project root." && \
    exit 1

function sync_cleanup() {
    [[ ! -z "${tmpdir}" ]] && [[ -d ${tmpdir} ]] && rm -r ${tmpdir}
}

tmpdir=`mktemp -q -d '.dotfile-XXXXXX'`

[[ ! -d ${tmpdir} ]] && \
    echo "Could not create temporary directory, aborting." && \
    exit 2

mkdir -p ${tmpdir}/merged

# Ensure the temporary directory is cleaned up on exit.
trap 'sync_cleanup' EXIT

echo ">>> Inspecting all files from 'manifest.txt' for changes."

for dotfile in `cat manifest.txt`;
do
    # Skip lines that start with '#'
    [[ "${dotfile:0:1}" == "#" ]] && continue

    # Copy files mentioned in the manifest that exist in $HOME, but are not
    # part of the repo (or have been deleted).
    if [[ ! -e ${dotfile} ]];
    then
        echo "Copying missing file in manifest from \$HOME into repo: ${dotfile}"
        cp ~/${dotfile} ${dotfile}
        continue
    fi

    diff -q $dotfile ~/${dotfile} 2> /dev/null

    if [[ $? != 0 ]];
    then
        echo -n "[ (s)kip, (r)eview, (m)erge, (q)uit ]"

        while [[ true ]];
        do
            read -n 1 -s dotfile_cmd

            case $dotfile_cmd in
                r)
                    diff -y $dotfile ~/${dotfile} | less
                    ;;

                m)
                    dotfile_path=`dirname ${tmpdir}/merged/${dotfile}`
                    [[ ! -z "${dotfile_path}" ]] && [[ ! -d ${dotfile_path} ]] && mkdir -p ${dotfile_path}

                    echo ""
                    echo "--- Using 'sdiff' in interactive mode to merge. For more information see:"
                    echo "--- https://www.gnu.org/software/diffutils/manual/html_node/Merge-Commands.html#Merge-Commands"

                    # Redirection of STDERR is due to similar behavior, in macOS 10.15, to the bug linked below.
                    # https://bugs.launchpad.net/ubuntu/+source/diffutils/+bug/73337
                    sdiff ${dotfile} ~/${dotfile} -o ${tmpdir}/merged/${dotfile} 2> /dev/null

                    # Copy merged dotfiles into place in the repository so that they can be
                    # inspected, staged, and commited.
                    if [[ ! -e ${tmpdir}/merged/${dotfile} ]];
                    then
                        echo "File was not merged successfully. Skipping."
                    elif [[ `stat -f '%z' ${tmpdir}/merged/${dotfile}` == "0" ]];
                    then
                        echo "Merged file is zero bytes. Skipping."
                    else
                        cp ${tmpdir}/merged/${dotfile} ${dotfile}
                        echo "'${dotfile}' has been updated in the respository."
                    fi
                    break
                    ;;

                q)
                    echo ""
                    exit 0
                    ;;

                *)
                    echo ""
                    break
                    ;;
            esac
        done
    fi
done
