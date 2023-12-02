import std/[strutils, sequtils, enumerate]

type
  Limits = enum
    Red = (12, "red"),
    Green = (13, "green"),
    Blue = (14, "blue")

var possibleGamesSum = 0
for id, game in enumerate(1, lines("input.txt")):
  let draws = game[game.find(':')+1..^1].split(';').mapIt(it.split(',').mapIt(it.strip.split(' ')))
  block check:
    for draw in draws:
      for color in draw:
        if color[0].parseInt > color[1].parseEnum[:Limits].ord:
          break check
    possibleGamesSum += id

echo possibleGamesSum
