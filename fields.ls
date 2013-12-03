classes2 =
  [3 4 1 2]
  [2 4 1 3]
  [1 4 2 3]
  [1 4 3 2]
  [2 4 3 1]
  [3 4 2 1]
  [4 3 2 1]
  [4 2 3 1]
  [4 1 3 2]
  [4 1 2 3]
  [4 2 1 3]
  [4 3 1 2]

classes1 =
  [2 3 1 4]
  [3 2 1 4]
  [3 1 2 4]
  [2 1 3 4]
  [1 2 3 4]
  [1 3 2 4]
  [1 4 2 3]
  [1 4 3 2]
  [2 4 3 1]
  [3 4 2 1]
  [3 4 1 2]
  [2 4 1 3]


games = []
for i til 12
  p1 = classes1[i]
  for j til 12
    p2 = classes2[j]
    games[][i][j] = [p1.0, p2.0, p1.1, p2.1, p1.2, p2.2, p1.3, p2.3]

{width: w, height: h} = canvas = document.get-element-by-id \canvas
gw = w / 12
gh = h / 12
ctx = canvas.get-context \2d

tot = 600
particles = for i til tot
  x: Math.random! * w, y: Math.random! * h, life: (Math.random! * 20).|.0, color: if Math.random! > 0.5 then \white else \black

update = !->
  #ctx
    #..fill-style = 'rgba(255, 255, 255, 0.005)'
    #..fill-rect 0 0 w, h

  new-p = []
  for {x, y}: p in particles
    gi = (12 - (x / gw) .|. 0) % 12
    gx = (x % gw) / gw
    gj = (12 - (y / gh) .|. 0) % 12
    gy = (y % gh) / gh
    #console.log gi, gx, gj, gy
    game = games[gi][gj]

    [dx, dy] = dyn gx, gy, game

    dx *= 2.8
    dy *= 2.8
    ctx.stroke-style = p.color
    ctx.begin-path!
    ctx.move-to x, y
    p.x += dx
    p.y += dy
    ctx.line-to p.x, p.y
    ctx.stroke!
    if --p.life > 0
      new-p.push p

  particles := new-p
  while particles.length < tot
    particles.push do
      x: Math.random! * w, y: Math.random! * h, life: (Math.random! * 20).|.0, color: if Math.random! > 0.5 then \white else \black

  request-animation-frame update

update!

# a = proportion of p2 playing D
# b = proportion of p1 playing D
# i.e. in normal form with 0,0 in top left
function dyn a, b, u
  expected1c = (1 - a) * u.0 + a * u.2 # 4
  expected1d = (1 - a) * u.4 + a * u.6 # 3
  expected2c = (1 - b) * u.1 + b * u.5 # 4
  expected2d = (1 - b) * u.3 + b * u.7 # 3
  avg-payoff1 = b * expected1d + (1 - b) * expected1c # 4
  avg-payoff2 = a * expected2d + (1 - a) * expected2c # 4

  # from 1c to 1d
  d1d = (1 - b) * Math.max 0, (expected1d - avg-payoff1) # -1 -> 0
  # from 1d to 1c
  d1c = b       * Math.max 0, (expected1c - avg-payoff1) # 1
  # from 2c to 2d
  d2d = (1 - a) * Math.max 0, (expected2d - avg-payoff2) # 0
  # from 2d to 2c
  d2c = a       * Math.max 0, (expected2c - avg-payoff2) # 1

  # x axis: proportion of p2 playing D [0 1]
  # y axis: proportion of p1 playing D [0 1]
  [d2d - d2c, d1d - d1c]
