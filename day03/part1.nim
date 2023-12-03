import std/strutils

let grid = readFile("input.txt").split("\n")[0..^2]

var
  currentNumber = ""
  isPart = false
  sum = 0

proc resetNumber() =
  if isPart:
    sum += parseInt(currentNumber)
  currentNumber = ""
  isPart = false

for y, line in grid:
  for x, c in line:
    if c in Digits:
      currentNumber.add c
      for yo in -1..1:
        for xo in -1..1:
          if y + yo >= 0 and y + yo < grid.len and
             x + xo >= 0 and x + xo < line.len:
            if grid[y + yo][x + xo] notin Digits + {'.'}:
              isPart = true
    else:
      resetNumber()
  resetNumber()

echo sum
