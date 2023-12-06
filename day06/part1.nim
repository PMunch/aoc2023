import std/[strutils, sequtils]
import npeg

type Records = object
  times, distances: seq[int]

let parser = peg("records", r: Records):
  records <- timelist * '\n' * distlist * '\n' * !1
  timelist <- "Time:" * +' ' * >numberlist:
    r.times = ($1).splitWhitespace().map(parseInt)
  distlist <- "Distance:" * +' ' * >numberlist:
    r.distances = ($1).splitWhitespace().map(parseInt)
  numberlist <- +(*' ' * number)
  number <- +Digit

var records: Records
assert parser.match(readFile("input.txt"), records).ok

var sum = 1
for i, time in records.times:
  var possibilities = 0
  for holdtime in 1..<time:
    if holdtime * (time - holdtime) > records.distances[i]:
      possibilities += 1
  sum *= possibilities

echo sum
