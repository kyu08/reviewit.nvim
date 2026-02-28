#!/bin/bash
set -e

PLENARY_PATH="${PLENARY_PATH:-$HOME/.local/share/nvim/lazy/plenary.nvim}"

if [ ! -d "$PLENARY_PATH" ]; then
  PLENARY_PATH=".testenv/plenary.nvim"
  if [ ! -d "$PLENARY_PATH" ]; then
    git clone --depth=1 https://github.com/nvim-lua/plenary.nvim.git "$PLENARY_PATH"
  fi
fi

export PLENARY_PATH

nvim --headless -u tests/minimal_init.lua \
  -c "RunTests ${1:-tests}"
