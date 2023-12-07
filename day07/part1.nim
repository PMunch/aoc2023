import std/[strutils, sequtils, algorithm]

type
  Card = enum
    Ace = "A"
    King = "K"
    Queen = "Q"
    Jack = "J"
    Ten = "T"
    Nine = "9"
    Eight = "8"
    Seven = "7"
    Six = "6"
    Five = "5"
    Four = "4"
    Three = "3"
    Two = "2"
  Type = enum
    FiveOfAKind
    FourOfAKind
    FullHouse
    ThreeOfAKind
    TwoPair
    OnePair
    HighCard
  Game = object
    hand: seq[Card]
    bid: int

var games: seq[Game]
for line in "input.txt".lines:
  let split = line.splitWhitespace()
  games.add Game(
    bid: parseInt(split[1]),
    hand: cast[seq[char]](split[0]).mapIt(parseEnum[Card]($it))
  )

proc getType(game: Game): Type =
  var cards: array[Card, int]
  for card in game.hand:
    cards[card] += 1
  cards.sort()
  case cards[^1]:
  of 5: FiveOfAKind
  of 4: FourOfAKind
  of 3: (if cards[^2] == 2: FullHouse else: ThreeOfAKind)
  of 2: (if cards[^2] == 2: TwoPair else: OnePair)
  else: HighCard

games.sort(proc (x, y: Game): int =
  let
    xt = x.getType
    yt = y.getType
  if xt != yt:
    return yt.ord - xt.ord
  else:
    for i in 0..4:
      if x.hand[i] < y.hand[i]:
        return 1
      elif x.hand[i] > y.hand[i]:
        return -1
)

var sum = 0
for i, game in games:
  sum += (i + 1) * game.bid

echo sum
