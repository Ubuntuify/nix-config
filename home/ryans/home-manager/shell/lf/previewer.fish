#!/usr/bin/env fish

set -fu MIME (file --mime-type -b "$argv[1]")

# If the file is a symlink, find the MIME of the actual file itself, requires GNU coreutils.
if test $MIME = "inode/symlink"
  set -fu MIME (file --mime-type -b (readlink -f $argv[1]))
end

switch $MIME
  # PDF files (uses poppler-utils)
  case "*application/pdf*"
    pdftotext "$argv[1]" -

  # Compression formats
  case "*application/x-7z-compressed*"
    7zz l "$argv[1]"
  case "*application/x-tar*"
    tar -tvf "$argv[1]"
  case "*application/x-compressed-tar*" "*application/x-*-compressed-tar*"
    tar -tvf "$argv[1]"
  case "*application/vnd.rar*"
    7zz l "$argv[1]"
  case "*application/zip*"
    unzip -l "$argv[1]"

  # Prints any image as a sixel to terminal (won't work if the terminal emulator does not support it.)
  case "image/*"
    chafa -f sixel -s "$argv[2]\x$argv[3]" --animate off --polite on "$argv[1]"

  # Gives syntax highlighting to any file that is a text file.
  case "*text/*"
    bat --force-colorization --paging=never --style=changes,numbers \
      --terminal-width (math $argv[2] - 3) "$argv[1]" && false

  # If the script does not recognize the format, it prints the format for debugging.
  case "*"
    echo (set_color --bold --underline blue)"unknown format:"(set_color normal)" $MIME"
end

