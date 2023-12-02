import std/[strutils, sequtils, enumerate]

type
  Color = enum
    Red = "red",
    Green = "green",
    Blue = "blue"

var gamesSum = 0
for id, game in enumerate(1, lines("input.txt")):
  let draws = game[game.find(':')+1..^1].split(';').mapIt(it.split(',').mapIt(it.strip.split(' ')))
  var colors: array[Color, int]
  for draw in draws:
    for color in draw:
      let c = color[1].parseEnum[:Color]
      colors[c] = max(colors[c], color[0].parseInt)
  gamesSum += colors[Red] * colors[Green] * colors[Blue]

echo gamesSum
