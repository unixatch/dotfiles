#!/usr/bin/env bash

(:)
curPos=0
keepLooping="true"
selection=()
shopt -s nullglob
files=(*.webm *.mkv *.mp4)
shopt -u nullglob

filenameLengths=()
for file in "${files[@]}" ;do
    totalLines=0
    for (( i = 0; i < ${#file}; )) ;{
        (( totalLines++ ))
        i=$((i + LINES))
    }
    filenameLengths+=( "$totalLines" )
    totalLines=0
done

sigwinchHandler() (:)
trapHandler() { printf '\e[?1049l'; exit; }

renderer() {
    local loopPos=0 curTotLines=0 lines=()
    for file in "${files[@]}" ;do
        (( curTotLines+=filenameLengths[loopPos] ))
        (( curTotLines - curPos > LINES )) && break

        # Selection highlighter
        [[ -n ${selection[loopPos]} ]] &&
        (( selection[loopPos] == loopPos )) && {
            lines+=( $'\e[41m'"$file"$'\e[0m\n' )
            ((loopPos++))
            continue
        }
        # Cursor highlighter
        (( curPos == loopPos )) && {
            lines+=( $'\e[7m'"$file"$'\e[0m\n' )
            ((loopPos++))
            continue
        }
        # Normal printing
        lines+=("$file\n")
        ((loopPos++))
    done
    IFS= lines="${lines[*]}"
    printf '\e[3J\e[1J%b' "$lines"
}
inputHandler() {
    local needsToStop="false"
    local upRegex="A|w|k"
    local downRegex="B|s|j"
    local arrowRegex="^\["
    local wholeInput=""

    # TODO: Emacs bindings?
    # TODO: vim shortcuts like 3k?
    while read -rsN 1 input ;do
        case "$input" in
            # Up and down arrows
            A|B|w|s|j|k)
                # Broken up/down arrow escape sequences
                [[ $input =~ A|B ]] &&
                [[ ! $wholeInput =~ $arrowRegex ]] && {
                    wholeInput=""
                    continue
                }

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
            q|Q|e|E) exit 0 ;;
            # Ignore everything else
            *) ;;
        esac
        "$needsToStop" && break
        wholeInput+="$input"
    done
}

main() {
    trap trapHandler SIGINT SIGTERM EXIT
    trap sigwinchHandler SIGWINCH
    # Opens alternate buffer + saves cursor
    printf '\e[?1049h'
        while "$keepLooping" ;do
            renderer; inputHandler
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

