import std/strutils
import npeg

type Records = object
  times, distances: seq[int]

let parser = peg("records", r: Records):
  records <- timelist * '\n' * distlist * '\n' * !1
  timelist <- "Time:" * +' ' * >numberlist:
    r.times.add ($1).replace(" ", "").parseInt
  distlist <- "Distance:" * +' ' * >numberlist:
    r.distances.add ($1).replace(" ", "").parseInt
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
