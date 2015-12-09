#!/bin/bash -e

# commit data
read -p 'Commit message: ' message

git add . -A
git commit -m "$message"
git push origin source

# update website
rake publish
