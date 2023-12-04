import std/[strutils, setutils, sequtils, math]
import npeg

type
  Card = object
    id: int
    winningNumbers: set[1..99]
    ourNumbers: set[1..99]

let parser = peg("cards", cards: seq[Card]):
  cards <- +(card * "\n")
  card <- "Card" * +' ' * >number * ':' * >numberlist * " | " * >numberlist:
    cards.add Card(
      id: parseInt($1),
      winningNumbers: strip($2).splitWhitespace().mapIt(range[1..99](it.parseInt)).toSet,
      ourNumbers: strip($3).splitWhitespace().mapIt(range[1..99](it.parseInt)).toSet)
  numberlist <- +(*' ' * number)
  number <- +Digit

var cards: seq[Card]
assert parser.match(readFile("input.txt"), cards).ok

var score = 0
for card in cards:
  let winning = (card.winningNumbers * card.ourNumbers).card.float
  score += (if winning > 0: 2.pow(winning - 1) else: 0).int

echo score
