import std/strutils

var sum = 0
for line in lines("input.txt"):
  var
    firstIndex = -1
    lastIndex = 0
  for i, c in line:
    if c in Digits:
      if firstIndex == -1:
        firstIndex = i
      lastIndex = i
  #sum += parseInt(line[firstIndex] & line[lastIndex])
  sum += (line[firstIndex].ord - '0'.ord)*10 + line[lastIndex].ord - '0'.ord

echo sum
