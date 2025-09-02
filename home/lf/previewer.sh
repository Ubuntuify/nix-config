#!/usr/bin/env bash

MIME=$(file --mime-type -b "$1")

case "$MIME" in
  # .pdf
  *application/pdf*)
    pdftotext "$1" -
    ;;
  # .7z
  *application/x-7z-compressed*)
    7zz l "$1"
    ;;
  # .tar .tar.Z
  *application/x-tar*)
    tar -tvf "$1"
    ;;
  # .tar.*
  *application/x-compressed-tar*|*application/x-*-compressed-tar*)
    tar -tvf "$1"
    ;;
  # .rar
  *application/vnd.rar*)
    7zz l "$1"
    ;;
  # .zip
  *application/zip*)
    unzip -l "$1"
    ;;
  # all images displayed through sixel
  image/*)
    chafa -f sixel -s "$2x$3" --animate off --polite on "$1"
    ;;
  # any plain text file that doesn't have a specific handler
  *text/*)
    # return false to always repaint, in case terminal size changes
    bat --force-colorization --paging=never --style=changes,numbers \
        --terminal-width $(($2 - 3)) "$1" && false
    ;;
  *)
    echo $(fish -c \"set_color --bold blue\") unknown format: $(fish -c \"set_color normal\") $MIME
    ;;
esac
