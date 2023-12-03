import std/[strutils, tables]

let grid = readFile("input.txt").split("\n")[0..^2]

var
  currentNumber = ""
  gears: Table[tuple[x, y: int], int]
  gearPos = (-1, -1)
  sum = 0

proc resetNumber() =
  if gearPos != (-1, -1):
    if gears.contains gearPos:
      sum += gears[gearPos] * parseInt(currentNumber)
    else:
      gears[gearPos] = parseInt(currentNumber)
  currentNumber = ""
  gearPos = (-1, -1)

for y, line in grid:
  for x, c in line:
    if c in Digits:
      currentNumber.add c
      for yo in -1..1:
        for xo in -1..1:
          if y + yo >= 0 and y + yo < grid.len and
             x + xo >= 0 and x + xo < line.len:
            if grid[y + yo][x + xo] == '*':
              gearPos = (x + xo, y + yo)
    else:
      resetNumber()
  resetNumber()

echo sum
