# returns array of equilibrium positions
ne = (p1, p2, m, n) ->
  # p1 best responses
  p1br = {}
  for row til m
    :next-col for col til n
      for other-col til n
        if col is not other-col
          if p1[row * m + other-col] > p1[row * m + col]
            continue next-col
      p1br[row * m + col] = true

  # p2 best responses
  p2br = {}
  for col til n
    :next-row for row til m
      for other-row til m
        if row is not other-row
          if p2[other-row * m + col] > p2[row * m + col]
            continue next-row
      p2br[row * m + col] = true

  # intersection are pure strategy NE
  for br1 in Object.keys p1br
    if p2br[br1]
      br1

# array of combination arrays `n` long, e.g. [[1,2], [2,1]]
combinations = (n) ->
  if n is 0
    []
  else if n is 1
    [[1]]
  else
    combs = []
    for comb in combinations n - 1
      for i til n
        c = comb.slice!
        c.splice i, 0, n
        combs.push c
    return combs

# draws pattern of NE on canvas ctx for 2x3 strategies
ne-pattern = ->
  patt = combinations 6
  for p1 in patt
    for p2 in patt
      ne(p1, p2, 2, 3)length

p = ne-pattern!
console.log """
P2
#{p.length} #{p.0.length} 2
#{p.map((.join ' '))join \\n}"""
