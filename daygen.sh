#!/usr/bin/bash

CURRDATE=$(date +%d)
CODEDATE=$(($CURRDATE + 1))

mkdir $CODEDATE
cp ./template.gd "$CODEDATE/part1.gd"
touch "$CODEDATE/input.txt"
touch "$CODEDATE/demoin.txt"
