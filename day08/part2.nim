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
    starts: seq[Location]
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
    if ($1)[^1] == 'A':
      s.result.starts.add s.locations[$1]
  label <- (Upper | Digit)[3]

proc parseInput(x: string): Map =
  var state: ParseState
  let pr = parser.match(x, state)
  if not pr.ok:
    var e = newException(ParseError, "Couldn't parse input, got as far as: " & $pr.matchMax)
    e.matchMax = pr.matchMax
    raise e
  state.result

let map = parseInput(readFile("input.txt"))

type
  StartPos = object
    label: string
    inputPos: int

var
  cache: Table[StartPos, tuple[location: Location, length: int]]
  currentLocations: seq[tuple[startPos: StartPos, startIdx: int, location: Location, inputIdx: int]]
  steps = 0

for start in map.starts:
  currentLocations.add (startPos: StartPos(label: start.name, inputPos: 0), startIdx: 0, location: start, inputIdx: 0)



#proc `$`(l: Location): string =
#  l.name

block travelMap:
  while true:
    for direction in map.directions:
      for currentLocation in currentLocations.mitems:
        if currentLocation.inputIdx == steps:
          cache.withValue(
            StartPos(label: currentLocation.location.name,
             inputPos: currentLocation.inputIdx mod map.directions.len),
            value):
            currentLocation.location = value.location
            currentLocation.inputIdx += value.length
          currentLocation.location = case direction:
            of Left: currentLocation.location.left
            of Right: currentLocation.location.right
          inc currentLocation.inputIdx
      inc steps
      var ends = 0
      for currentLocation in currentLocations:
        if currentLocation.location.name[^1] == 'Z':
          cache[
            StartPos(label: currentLocation.location.name,
             inputPos: currentLocation.inputIdx mod map.directions.len)] =
            (location: currentLocation.location, length: currentLocation.inputIdx - currentLocation.startIdx)
          inc ends
      if ends == currentLocations.len: break travelMap

echo steps
