import std/[strutils, setutils, sequtils]
import npeg

type
  NumRange = 1..99
  Card = object
    id: int
    winningNumbers: set[NumRange]
    ourNumbers: set[NumRange]

let parser = peg("cards", cards: seq[Card]):
  cards <- +(card * "\n")
  card <- "Card" * +' ' * >number * ':' * >numberlist * " | " * >numberlist:
    cards.add Card(
      id: parseInt($1),
      winningNumbers: strip($2).splitWhitespace().mapIt(it.parseInt.NumRange).toSet,
      ourNumbers: strip($3).splitWhitespace().mapIt(it.parseInt.NumRange).toSet)
  numberlist <- +(*' ' * number)
  number <- +Digit

var cards: seq[Card]
assert parser.match(readFile("input.txt"), cards).ok

var counts = newSeqWith[int](cards.len, 1)
for i, card in cards:
  let winning = (card.winningNumbers * card.ourNumbers).card
  for w in (i+1)..(i+winning):
    counts[w] += counts[i]
echo counts.foldl(a+b)
