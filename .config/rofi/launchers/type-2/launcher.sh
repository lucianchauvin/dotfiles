#!/usr/bin/env bash

dir="$HOME/.config/rofi/launchers/type-2"
theme='style-3'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
