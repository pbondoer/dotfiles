#!/bin/bash
while [[ $PWD != / ]] ; do
    if [[ -f .ENV ]]; then
        cat $PWD/.ENV
        exit 0
    fi
    cd ..
done
cat $HOME/.ENV
