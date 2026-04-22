#!/bin/bash

#------------------[ Variables ]------------------
QUIT=0
CATEGORY_NAMES=("Books" "Film" "Music" "Video Games" "Science & Nature" "Mythology" "Sports" "History" "Anime & Manga" "Cartoons & Animations")
CATEGORY_NUMS=(10 11 12 15 17 20 21 23 31 32)
DIFFICULTIES=("easy" "medium" "hard")

#------------------[ Functions ]------------------
isInputNumForCat() {
    if [[ $1 =~ ^([1-9]|10)$ ]]; then
        return 0
    elif (( $1 < 0 || $1 > 10 )); then
        printf "+--------------------------------------------------+\n"
        printf "| Keep the number in range, mate!                  |\n"
        printf "+--------------------------------------------------+\n"
        return 1
    else
        printf "+--------------------------------------------------+\n"
        printf "| Input must be a number, you bloody pillock!     |\n"
        printf "| And no minuses as well!                         |\n"
        printf "+--------------------------------------------------+\n"
        return 1
    fi
}

isInputNumForDiff() {
    if [[ $1 =~ ^([1-3])$ ]]; then
        return 0
    elif (( $1 < 0 || $1 > 3 )); then
        printf "+--------------------------------------------------+\n"
        printf "| Keep the number in range, mate!                  |\n"
        printf "+--------------------------------------------------+\n"
        return 1
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

curlTrivia(){
    CATEGORY=$1
    DIFFICULTY=$2
    curl "https://opentdb.com/api.php?amount=1&category=$CATEGORY&difficulty=$DIFFICULTY&type=multiple"
}

#------------------[ Shell start ]------------------
printf "%s\n" "============================================================"
printf "%s\n" "  Hello there, old chap. Fancy a spot of trivia, then?      "
printf "%s\n" "============================================================"

while [[ $QUIT == 0 ]];
do
    ###[ Prompting for categories ]###
    printf "\n%s\n" "----------[ Select a category ]----------"
    for i in "${!CATEGORY_NAMES[@]}"; do
        printf "%2d. %s\n" "$((i + 1))" "${CATEGORY_NAMES[i]}"
    done

    read -p "Your choice: " categoryChoice

    if ! isInputNumForCat "$categoryChoice"; then
        continue
    fi

    ###[ Prompting for difficulties ]###
    printf "\n%s\n" "----------[ Select a category ]----------"
    for i in "${!DIFFICULTIES[@]}"; do
        printf "%2d. %s\n" "$((i + 1))" "${DIFFICULTIES[i]}"
    done

    read -p "Your choice: " difficultyChoice

    if ! isInputNumForDiff "$difficultyChoice"; then
        continue
    fi

    ###[ Curling question ]###
    QUESTION_JSON=$(curlTrivia ${CATEGORY_NUMS[$(($categoryChoice - 1))]} ${DIFFICULTIES[(($difficultyChoice - 1))]} | hxunent | jq ".results" )

    echo $QUESTION_JSON | jq

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
