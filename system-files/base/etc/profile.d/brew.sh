#!/usr/bin/env bash

BREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"
if [ -f "$BREW_PATH" ]; then
    eval "$($BREW_PATH shellenv)"
fi