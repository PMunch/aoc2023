import std/[strutils, sequtils]
import npeg

type
  Map = object
    mappings: seq[Mapping]
  Mapping = object
    sourceStart: int
    destStart: int
    span: int
  Almanac = object
    seeds: seq[int]
    seedToSoil: Map
    soilToFertilizer: Map
    fertilizerToWater: Map
    waterToLight: Map
    lightToTemperature: Map
    temperatureToHumidity: Map
    humidityToLocation: Map

proc `[]`(map: Map, source: int): int =
  for mapping in map.mappings:
    if source in mapping.sourceStart..<(mapping.sourceStart + mapping.span):
      return mapping.destStart + source - mapping.sourceStart
  return source

proc parseMappings(map: var Map, capture: auto) =
  for i in 1..<capture.len:
    let numberlist =
      capture[i].s.splitWhitespace().mapIt(it.parseInt)
    map.mappings.add Mapping(
      destStart: numberlist[0],
      sourceStart: numberlist[1],
      span: numberlist[2])

let parser = peg("almanac", a: Almanac):
  almanac <- "seeds: " * >numberlist * n * mappinglist:
    a.seeds = ($1).splitWhitespace().mapIt(it.parseInt)
  numberlist <- +(*' ' * number)
  number <- +Digit
  n <- +'\n'
  mappinglist <- seedToSoil * soilToFertilizer * fertilizerToWater *
    waterToLight * lightToTemperature * temperatureToHumidity *
    humidityToLocation * !1
  seedToSoil <- "seed-to-soil map:\n" * +(>numberlist * '\n') * n:
    parseMappings(a.seedToSoil, capture)
  soilToFertilizer <- "soil-to-fertilizer map:\n" * +(>numberlist * '\n') * n:
    parseMappings(a.soilToFertilizer, capture)
  fertilizerToWater <- "fertilizer-to-water map:\n" * +(>numberlist * '\n') * n:
    parseMappings(a.fertilizerToWater, capture)
  waterToLight <- "water-to-light map:\n" * +(>numberlist * '\n') * n:
    parseMappings(a.waterToLight, capture)
  lightToTemperature <- "light-to-temperature map:\n" * +(>numberlist * '\n') * n:
    parseMappings(a.lightToTemperature, capture)
  temperatureToHumidity <- "temperature-to-humidity map:\n" * +(>numberlist * '\n') * n:
    parseMappings(a.temperatureToHumidity, capture)
  humidityToLocation <- "humidity-to-location map:\n" * +(>numberlist * '\n'):
    parseMappings(a.humidityToLocation, capture)

var a: Almanac
assert parser.match(readFile("input.txt"), a).ok

template convert(n, f, t: untyped): untyped =
  a.`f To t`[n]

var smallestLocation = int.high
for i in countup(0, a.seeds.high, 2):
  echo i, "/", a.seeds.high
  for seed in a.seeds[i]..(a.seeds[i]+a.seeds[i+1]):
    smallestLocation = min(smallestLocation,
      seed.convert(seed, soil).convert(soil, fertilizer).
           convert(fertilizer, water).convert(water, light).
           convert(light, temperature).convert(temperature, humidity).
           convert(humidity, location))

echo smallestLocation
