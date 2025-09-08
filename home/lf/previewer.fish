#!/usr/bin/env fish

set -l MIME (file --mime-type -b "$argv[1]")

switch $MIME
  case \*application/pdf\*
    pdftotext "$argv[1]" -
  case \*application/x-7z-compressed\*
    7zz l "$argv[1]"
  case \*application/x-tar\*
    tar -tvf "$argv[1]"
  case \*application/x-compressed-tar\* \*application/x-\*-compressed-tar\*
    tar -tvf "$argv[1]"
  case \*application/vnd.rar\*
    7zz l "$argv[1]"
  case \*application/zip\*
    unzip -l "$argv[1]"
  case image/\*
    chafa -f sixel -s "$argv[2]\x$argv[3]" --animate off --polite on "$argv[1]"
  case \*text/\*
    bat --force-colorization --paging=never --style=changes,numbers \
      --terminal-width (math $argv[2] - 3) "$argv[1]" && false
  case "*"
    echo (set_color --bold blue)"unknown format: "(set_color normal)"$MIME"
end

