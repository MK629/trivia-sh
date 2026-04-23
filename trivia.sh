#!/bin/bash

#------------------[ Variables ]------------------
QUIT=0
CATEGORY_NAMES=("Books" "Film" "Music" "Video Games" "Science & Nature" "Mythology" "Sports" "History" "Anime & Manga" "Cartoons & Animations")
CATEGORY_NUMS=(10 11 12 15 17 20 21 23 31 32)
DIFFICULTIES=("easy" "medium" "hard")

#------------------[ Functions ]------------------
isCatInputValid() {
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

isDiffInputValid() {
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

isAnsInputValid() {
    if [[ $1 =~ ^([1-4])$ ]]; then
        return 0
    elif (( $1 < 0 || $1 > 4 )); then
        printf "+--------------------------------------------------+\n"
        printf "| Keep the number in range, mate!                  |\n"
        printf "+--------------------------------------------------+\n"
        return 1
    else
        printf "+--------------------------------------------------+\n"
        printf "| Input must be a number, you bloody pillock!      |\n"
        printf "| And no minuses as well!                          |\n"
        printf "+--------------------------------------------------+\n"
        return 1
    fi
}

checkAnswer(){
    CORRECT="$1"
    CHOSEN="$2"

    if [[ "$CHOSEN" == "$CORRECT" ]]; then
        printf "+----------------------------------------------------------------------------------------------------------------+\n"
        printf " THAT'S RIGHT! The answer is indeed: ${CHOSEN}.\n"
        printf "+----------------------------------------------------------------------------------------------------------------+\n"
    else
        printf "+----------------------------------------------------------------------------------------------------------------+\n"
        printf " NOPE! The actual answer is: ${CORRECT}.\n"
        printf "+----------------------------------------------------------------------------------------------------------------+\n"
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

    while true; do
        read -p "Your choice: " categoryChoice

        if isCatInputValid "$categoryChoice"; then
            break
        fi
    done

    ###[ Prompting for difficulties ]###
    printf "\n%s\n" "----------[ Select a category ]----------"
    for i in "${!DIFFICULTIES[@]}"; do
        printf "%2d. %s\n" "$((i + 1))" "${DIFFICULTIES[i]}"
    done

    while true; do
        read -p "Your choice: " difficultyChoice

        if isDiffInputValid "$difficultyChoice"; then
            break
        fi
    done

    ###[ Trivia curl and set variables ]###
    QUESTION_JSON=$(curlTrivia ${CATEGORY_NUMS[$(($categoryChoice - 1))]} ${DIFFICULTIES[(($difficultyChoice - 1))]} | jq '.results[0]')

    printf "%s\n" "============================================================\n"

    QUESTION=$(printf "$QUESTION_JSON" | jq '.question' | hxunent)
    CORRECT_ANS=$(printf "$QUESTION_JSON" | jq '.correct_answer' | hxunent)
    ANSWERS=()
    ANSWERS+=("$CORRECT_ANS")
    ANSWERS+=("$(printf "$QUESTION_JSON" | jq '.incorrect_answers[0]' | hxunent)")
    ANSWERS+=("$(printf "$QUESTION_JSON" | jq '.incorrect_answers[1]' | hxunent)")
    ANSWERS+=("$(printf "$QUESTION_JSON" | jq '.incorrect_answers[2]' | hxunent)")

    #Scramble answers
    for i in "${!ANSWERS[@]}"; do
        j=$((RANDOM % 4))
        tmp="${ANSWERS[i]}"
        ANSWERS[i]="${ANSWERS[j]}"
        ANSWERS[j]="$tmp"
    done

    ###[ Ask question, prompt answer]###
    printf "%s\n" "QUESTION: $QUESTION"

    for i in "${!ANSWERS[@]}"; do
        printf "%2d. %s\n" "$((i + 1))" "${ANSWERS[i]}"
    done

    while true; do
        read -p "Choose your answer: " trivAns

        if isAnsInputValid "$trivAns"; then
            break
        fi
    done

    checkAnswer "$CORRECT_ANS" "${ANSWERS[(($trivAns - 1))]}"

    ###[ Prompt quit]###
    while true;
    do
        read -p "Stop playing? (Y/N): " quitAns

        if isQuitInputValid "$quitAns"; then
            break
        fi
    done

    if [[ "$quitAns" == "Y" || "$quitAns" == "y" ]]; then
        QUIT=1
    fi
done

printf "%s\n" "================[ Bye bye, old chap! ]================"
