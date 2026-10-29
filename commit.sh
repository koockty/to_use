#!/bin/bash
set -e

MESSAGE="$*"

if [ -z "$MESSAGE" ]; then
  echo "用法: ./commit.sh <提交信息>"
  exit 1
fi

git add -A
git commit -m "$MESSAGE"
git -c credential.helper= push 
