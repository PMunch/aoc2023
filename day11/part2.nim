import std/[enumerate, setutils]

var
  galaxies: seq[tuple[x, y: int]]
  galaxiesX: set[uint8]
  galaxiesY: set[uint8]

for y, line in enumerate(lines("input.txt")):
  for x, tile in line:
    if tile == '#':
      galaxiesX.incl x.uint8
      galaxiesY.incl y.uint8
      galaxies.add (x, y)

var sum = 0
for f in 0..<galaxies.high:
  let first = galaxies[f]
  for s in f+1..galaxies.high:
    let
      second = galaxies[s]
      dx = abs(second.x - first.x) +
        (toSet(min(second.x, first.x).uint8..max(second.x, first.x).uint8) - galaxiesX).card * 999_999
      dy = abs(second.y - first.y) +
        (toSet(min(second.y, first.y).uint8..max(second.y, first.y).uint8) - galaxiesY).card * 999_999
    sum += dx + dy

echo sum

