#!/bin/bash

#------------------[ Variables ]------------------
QUIT=0
CATEGORY_NAMES=("Books" "Film" "Music" "Video Games" "Science & Nature" "Mythology" "Sports" "History" "Anime & Manga" "Cartoons & Animations")
CATEGORY_NUMS=(10 11 12 15 17 20 21 23 31 32)
DIFFICULTIES=("easy" "medium" "hard")

#------------------[ Functions ]------------------
isInputNum() {
    if [[ $1 =~ ^([1-9]|10)$ ]]; then
        return 0
    else
        printf "+--------------------------------------------------+\n"
        printf "| Input must be a number, you bloody pillock!     |\n"
        printf "| And no minuses as well!                         |\n"
        printf "+--------------------------------------------------+\n"
        return 1
    fi
}

isQuitInputValid(){
    if [[ -z $1 ]]; then
        return 1
    elif [[ $1 != "Y" && $1 != "y" && $1 != "N" && $1 != "n" ]]; then
        printf "%s\n" "Invalid input, mate!"
        return 1
    else
        return 0
    fi
}

#------------------[ Shell start ]------------------
printf "%s\n" "============================================================"
printf "%s\n" "  Hello there, old chap. Fancy a spot of trivia, then?     "
printf "%s\n" "============================================================"

while [[ $QUIT == 0 ]];
do
    ###[ Prompting for categories ]###
    printf "\n%s\n" "----------[ Select a category ]----------"
    for i in "${!CATEGORY_NAMES[@]}"; do
        printf "%2d. %s\n" "$((i + 1))" "${CATEGORY_NAMES[i]}"
    done

    read -p "Your choice: " categoryChoice

    if ! isInputNum "$categoryChoice"; then
        continue
    fi



    ###[ Prompt quit]###
    while true;
    do
        read -p "Stop playing? (Y/N): " quitAns

        if isQuitInputValid "$quitAns"; then
            break
        fi
    done

    if [[ $quitAns == "Y" || $quitAns == "y" ]]; then
        QUIT=1
    fi
done

printf "%s\n" "================[ Bye bye, old chap! ]================"
