import std/strutils

const digits = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
                "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

var sum = 0
for line in lines("input.txt"):
  var
    firstDigit = 0
    lastDigit = 0
    firstIndex = int.high
    lastIndex = -1
  for i, digit in digits:
    let fi = line.find(digit)
    if fi != -1 and firstIndex > fi:
      firstIndex = fi
      firstDigit = if i > 9: i - 10 else: i
    let li = line.rfind(digit)
    if li != -1 and lastIndex < li:
      lastIndex = li
      lastDigit = if i > 9: i - 10 else: i
  sum += firstDigit * 10 + lastDigit

echo sum
