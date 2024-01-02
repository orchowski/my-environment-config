#!/bin/bash
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

mkdir -p "$HOME/.config/skhd/"
mkdir -p "$HOME/.config/yabai/"
cp $(dirname $(readlink -f $0))/mac-specific/yabairc $HOME/.config/yabai/yabairc
cp $(dirname $(readlink -f $0))/mac-specific/skhdrc $HOME/.config/skhd/skhdrc
