#!/bin/bash
player_1=50
player_2=50

player_1_guess=0
player_2_guess=0
turn=1
place=0
finish=true

p2_3=" |       |       #       |       |O"
p2_2=" |       |       #       |   O   | "
p2_1=" |       |       #   O   |       | "
p0_0=" |       |       O       |       | "
p1_1=" |       |   O   #       |       | "
p1_2=" |   O   |       #       |       | "
p1_3="O|       |       #       |       | "
ball=$p0_0

print_board () {
    echo " Player 1: $player_1         Player 2: $player_2 "
    echo " --------------------------------- "
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo "$ball"
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo " --------------------------------- "
    if test $turn -ge 2; then
        echo "       Player 1 played: $player_1_guess"
        echo "       Player 2 played: $player_2_guess"
        echo
    fi
}

choose_num () {
    echo "PLAYER 1 PICK A NUMBER: "
    read -s player_1_guess
    while (! [[ "$player_1_guess" =~ ^[0-9]+$ ]]) || [[ ($player_1_guess -ge $[$player_1+1]) ]] || [[ (-1 -ge $player_1_guess) ]]
    do
        echo "NOT A VALID MOVE !"
        echo "PLAYER 1 PICK A NUMBER: "
        read -s player_1_guess
    done

    echo "PLAYER 2 PICK A NUMBER: "
    read -s player_2_guess
    while (! [[ "$player_2_guess" =~ ^[0-9]+$ ]]) || [[ ($player_2_guess -ge $[$player_2+1]) ]] || [[ (-1 -ge $player_2_guess) ]]
    do
        echo "NOT A VALID MOVE !"
        echo "PLAYER 2 PICK A NUMBER: "
        read -s player_2_guess
    done

    turn=$[$turn+1]
    if test $player_2_guess -eq $player_1_guess 
    then
        player_1=$[$player_1-$player_1_guess]
        player_2=$[$player_2-$player_2_guess]
    elif test $player_2_guess -ge $player_1_guess
    then
        place=$[$place-1]
        player_1=$[$player_1-$player_1_guess]
        player_2=$[$player_2-$player_2_guess]
    else
        place=$[$place+1]
        player_1=$[$player_1-$player_1_guess]
        player_2=$[$player_2-$player_2_guess]
    fi

    if test $place -eq 0; then
        ball=$p0_0
    elif test $place -eq 1; then
        ball=$p2_1
    elif test $place -eq 2; then
        ball=$p2_2
    elif test $place -eq 3; then
        ball=$p2_3
    elif test $place -eq -1; then
        ball=$p1_1
    elif test $place -eq -2; then
        ball=$p1_2
    else
        ball=$p1_3
    fi
}

check_win () {
    if test $place -eq 3; then
        echo "PLAYER 1 WINS !"
        finish=false
    elif test $place -eq -3; then
        echo "PLAYER 2 WINS !"
        finish=false
    elif test $player_1 -eq 0 -a $player_2 -ge 1; then
        echo "PLAYER 2 WINS !"
        finish=false
    elif test $player_2 -eq 0 -a $player_1 -ge 1; then
        echo "PLAYER 1 WINS !"
        finish=false
    elif test $player_1 -eq 0 -a $player_2 -eq 0; then
        if test $place -ge 1; then
            echo "PLAYER 1 WINS !"
            finish=false
        elif test -1 -ge $place; then
            echo "PLAYER 2 WINS !"
            finish=false
        else
            echo "IT'S A DRAW !"
            finish=false
        fi
    fi
}

print_board
while $finish
do
    choose_num
    print_board
    check_win
done