#!/bin/bash

score=0
total=6

echo "Running lab validation..."

if id "devuser" &>/dev/null; then
  echo "[PASS] User exists"
  ((score++))
else
  echo "[FAIL] User missing"
fi

if getent group developers &>/dev/null; then
  echo "[PASS] Group exists"
  ((score++))
else
  echo "[FAIL] Group missing"
fi

if id -nG devuser | grep -qw "developers"; then
  echo "[PASS] User in group"
  ((score++))
else
  echo "[FAIL] User not in group"
fi

if [ -d "/projects/dev" ]; then
  echo "[PASS] Directory exists"
  ((score++))
else
  echo "[FAIL] Directory missing"
fi

owner=$(stat -c "%U" /projects/dev 2>/dev/null)
group=$(stat -c "%G" /projects/dev 2>/dev/null)

if [[ "$owner" == "devuser" && "$group" == "developers" ]]; then
  echo "[PASS] Correct ownership"
  ((score++))
else
  echo "[FAIL] Incorrect ownership"
fi

perm=$(stat -c "%a" /projects/dev 2>/dev/null)

if [ "$perm" == "770" ]; then
  echo "[PASS] Correct permissions"
  ((score++))
else
  echo "[FAIL] Incorrect permissions"
fi

echo "Score: $score / $total"
