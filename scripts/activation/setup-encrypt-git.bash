#!/usr/bin/env bash

if [ -f ~/.ssh/allowed_signers ]; then
  rm -f ~/.ssh/allowed_signers
fi

touch ~/.ssh/allowed_signers

if [ -f ~/.ssh/id_ed25519.pub ]; then
  echo "* $(cat "$HOME/.ssh/id_ed25519.pub")" >"$HOME/.ssh/allowed_signers"
fi
