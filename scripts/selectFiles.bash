#!/usr/bin/env bash

curPos=0
keepLooping="true"
selection=()

shopt -s nullglob
files=(*.webm *.mkv)
shopt -u nullglob

trapHandler() { printf '\e[?1049l'; exit 130; }

renderer() {
    local loopPos=0
    for file in "${files[@]}" ;do
        # Selection highlighter
        [[ -n ${selection[loopPos]} ]] &&
        (( selection[loopPos] == loopPos )) && {
            printf '\e[41m%s\e[0m\n' "$file"
            ((loopPos++))
            continue
        }
        # Cursor highlighter
        (( curPos == loopPos )) && {
            printf '\e[7m%s\e[0m\n' "$file"
            ((loopPos++))
            continue
        }
        # Normal printing
        echo "$file"
        ((loopPos++))
    done
}
inputHandler() {
    local needsToStop="false"
    local upRegex="A|w|k"
    local downRegex="B|s|j"
    local arrowRegex="^\["
    local wholeInput=""

    while read -rsN 1 input ;do
        case "$input" in
            # Start of a sequence
            $'\e'|"[") ;;
            # Up and down arrows
            A|B|w|s|j|k)
                # Broken up/down arrow escape sequences
                [[ $input =~ A|B ]] &&
                [[ ! $wholeInput =~ $arrowRegex ]] && continue

                [[ $input =~ $upRegex ]] && ((
                    curPos > 0
                        ? curPos--
                        : ( curPos=$((${#files[@]}-1)) )
                ))
                [[ $input =~ $downRegex ]] && ((
                    curPos < ${#files[@]}-1
                        ? curPos++
                        : ( curPos=0 )
                ))
                needsToStop="true"
            ;;
            # Left and right arrows are ignored
            C|D|a|d) needsToStop="true" ;;
            # Selector
            " ")
                if [[ -n ${selection[$curPos]} ]] ;then
                    unset "selection[curPos]"
                else
                    selection[curPos]="$curPos"
                fi
                needsToStop="true"
            ;;
            # Accept selection
            $'\n')
                [[ -z ${selection[*]} ]] && {
                    selection[curPos]="$curPos"
                }
                keepLooping="false"
                needsToStop="true"
            ;;
            # Quit command
            q|Q|e|E) printf '\e[?1049l'; exit 0 ;;
            # Ignore everything else
            *) ;;
        esac
        "$needsToStop" && break
        wholeInput+="$input"
    done
}

main() {
    trap trapHandler SIGINT SIGTERM
    # Opens alternate buffer + saves cursor
    printf '\e[?1049h'
        while "$keepLooping" ;do
            renderer; inputHandler
            printf '\e[2J' # Clears the whole screen
        done
    # Closes alternate buffer + restores cursor
    printf '\e[?1049l'

    # Confirmation prompt
    local doIt="false"
    while read -p "Use file [y|n]? " -r answer ;do
        case "$answer" in
            y|Y|s|S) doIt="true"; break ;;
            n|N)     break ;;
            *)       printf '\e[F' ;;
        esac
    done
    if "$doIt" ;then
        # Uses the selected files
        local listOfSelectedFiles=() file
        for n in "${selection[@]}" ;{
            printf -v file '%q' "${files[n]}"
            listOfSelectedFiles+=("$file")
        }
        echo "${listOfSelectedFiles[@]}"
    fi
}
main

