#!/usr/bin/env bash

echo "Getting submodules, please make sure that you are authenticated with your Git hosting site for your secrets."

git submodule update --remote --merge "secrets"

echo "Completed fetch, please check if there are any errors."
