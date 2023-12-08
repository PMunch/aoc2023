import std/[strutils, sequtils, tables]
import npeg

type
  Location = ref object
    name: string
    left, right: Location
  Direction = enum
    Left = "L"
    Right = "R"
  Map = object
    start: Location
    directions: seq[Direction]
  ParseState = object
    locations: Table[string, Location]
    result: Map
  ParseError = object of CatchableError
    matchMax: int

let parser = peg("map", s: ParseState):
  map <- directions * "\n\n" * +node * !1
  directions <- +('R' | 'L'):
    s.result.directions = ($0).mapIt(parseEnum[Direction]($it))
  node <- >label * " = (" * >label * ", " * >label * ")\n":
    discard s.locations.hasKeyOrPut($2, Location(name: $2))
    discard s.locations.hasKeyOrPut($3, Location(name: $3))
    s.locations.withValue($1, value):
      value.left = s.locations[$2]
      value.right = s.locations[$3]
    do:
      s.locations[$1] = Location(name: $1, left: s.locations[$2], right: s.locations[$3])
    if $1 == "AAA":
      s.result.start = s.locations[$1]
  label <- Upper[3]

proc parseInput(x: string): Map =
  var state: ParseState
  let pr = parser.match(x, state)
  if not pr.ok:
    var e = newException(ParseError, "Couldn't parse input, got as far as: " & $pr.matchMax)
    e.matchMax = pr.matchMax
    raise e
  state.result

let map = parseInput(readFile("input.txt"))

var
  currentLocation = map.start
  steps = 0
block travelMap:
  while true:
    for direction in map.directions:
      currentLocation = case direction:
        of Left: currentLocation.left
        of Right: currentLocation.right
      inc steps
      if currentLocation.name == "ZZZ": break travelMap

echo steps
