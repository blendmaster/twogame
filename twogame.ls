nash-equilibria = (p1, p2, m, n) ->
  ne = []
  if u.0 > u.4 and u.1 > u.3
    ne.push 0
  if u.2 > u.6 and u.3 > u.1
    ne.push 1
  if u.4 > u.0 and u.5 > u.7
    ne.push 2
  if u.6 > u.2 and u.7 > u.5
    ne.push 3
  return ne

identity = -> it

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

names =
     *   <[Hegemony              Samaritan-D         Chicken-Peace   Biased-Cycle         Inferior-Cycle   Endless-Cycle     Called-Bluff          Bully             Chicken-Comp         Chicken-Hero         Chicken-Battle    Chicken]>
     *   <[Samson                Battle-Harmony      Generous        Quasi-Cycle          Tragic-Cycle     Inspector-Cycle   Patron                Battle-Lock       Protector            Battle-Hero          Battle            Passive-Samaritan]>
     *   <[Delilah               Hero-Harmony        Hero-Peace      Pursuit-Cycle        Fixed-Cycle      Crisis-Cycle      Hero-Dilemma          Hero-Lock         Hero-Compromise      Hero                 Hero-Battle       Hero-Chicken]>
     *   <[Hostage               Compromise-Hmny     Dominant        Compromise-Coord     Second-Best      Big-Bully         Misery                Compromise-Lock   Compromise           Compromise-Hero      Protector         Compro-Chicken]>
     *   <[Blackmailer           Lock-Harmony        Lock-Peace      Lock-Coordination    Lock-Assurance   Hamlet            Total-Conflict        Deadlock          Lock-Compromise      Lock-Hero            Lock-Battle       Bully]>
     *   <[Hegemonic-Stability   Dilemma-Hmny        Altruist        Revelation           Alibi            Asym-Dilemma      Dilemma               Total-Conflict    Misery               Dilemma-Hero         Patron            Called-Bluff]>
     *   <[Anticipation          Hunt-Harmony        Hunt-Peace      Hunt-Coordination    Hunt-Assurance   Stag-Hunt         Asym-Dilemma          Hamlet            Big-Bully            Crisis-Cycle         Inspector-Cycle   Endless-Cycle]>
     *   <[Mutual                Assurance-Harmony   Privilege       Assur-Coord          Asurrance        Assurance-Hunt    Alibi                 Asurrance-Lock    Second-Best          Fixed-Cycle          Tragic-Cycle      Inferior-Cycle]>
     *   <[Coord-Concord         Coord-Harmony       Coord-Peace     Coordination         Coord-Assur      Coord-Hunt        Revelation            Coord-Lock        Coord-Compromise     Pursuit-Cycle        Quasi-Cycle       Biased-Cycle]>
     *   <[Aligned               Peace-Harmony       Peace           Peace-Coordination   Privilege        Peace-Hunt        Altruist              Peace-Lock        Dominant             Peace-Hero           Generous          Peace-Chicken]>
     *   <[Harmony-Concord       Harmony             Harmony-Peace   Harmony-Coord        Harmony-Assur    Harmony-Hunt      Hmny-Dilemma          Harmony-Lock      Harmony-Compromise   Harmony-Hero         Harmony-Battle    Samaritan-D]>
     *   <[Concord               Concord-Harmony     Aligned         Concord-Coord        Mutual           Anticipation      Hegemonic-Stability   Blackmailer       Hostage              Delilah              Samson            Hegemony]>

pairs = []
games = []
orders = {}
for name-class, i in names
  p1 = classes1[i]
  for name, j in name-class
    p2 = classes2[j]
    games[][i][j] = [p1.0, p2.0, p1.1, p2.1, p1.2, p2.2, p1.3, p2.3]
    orders{}[p1][p2] = pairs.length
    pairs.push [i, j]

u = games[11][0]slice!

tran = (sel, duration) ->
  if duration > 0
    sel.transition!duration duration
  else
    sel

int-prop = ->
  el = document.get-element-by-id it
  Bacon.from-event-target el, \input -> el.value
    .skip-duplicates!
    .to-property el.value
    .map (parse-int _, 10)

s  = d3.scale.linear!domain [1 4] .range [5 30]
sx = d3.scale.linear!domain [1 4] .range [0 200]
sy = d3.scale.linear!domain [1 4] .range [200 0]

drag-normal = d3.behavior.drag!
  .on \dragstart !->
    document.body.class-list.add \dragging
  .on \dragend !->
    document.body.class-list.remove \dragging
  .on \drag !(, i) ->
    u[i] -= d3.event.dy / 40
    u[i] = Math.min 4, Math.max 1, u[i]
    d3.select-all \.dwabs .each !->
      @__type__.bind.call d3.select(@first-element-child)

drag-dyn = d3.behavior.drag!
  .origin -> @__pos__
  .on \dragstart !->
    document.body.class-list.add \moving
  .on \dragend !->
    document.body.class-list.remove \moving
  .on \drag !->
    u[it + 1] = sx.invert d3.event.x
    u[it + 1] = Math.min 4, Math.max 1, u[it + 1]
    u[it] = sy.invert d3.event.y
    u[it] = Math.min 4, Math.max 1, u[it]
    d3.select-all \.dwabs .each !->
      @__type__.bind.call d3.select(@first-element-child)

df = d3.format '1.2g'

TYPE = {}
class DisplayType then (@id, @name, @bind, @transitions) -> TYPE[@id] = @
const TYPES = (.map -> new DisplayType it.0, it.1, it.2, it.3) [] =
  * \table 'Normal (Numbers)'
      !->
        @select-all \.utility .data u .text df
        ne = nash-equilibria u[0 2 4 6], u[1 3 5 7], 2 2
        @select-all \td .classed \ne (, i) -> i in ne
      table: (duration) !->
        @select-all \.utility
          .call drag-normal
  * \normal     'Normal Form'
      (duration) !->
        @select-all \.utility .data u
          tran .., duration .attr \r s
        ne = nash-equilibria u[0 2 4 6], u[1 3 5 7], 2 2
        @select-all \.rcell .classed \ne (, i) -> i in ne
      dynamics: (duration) !->
      categories: (duration) !->
      normal: (duration) !->
        @select-all \.utility
          .call drag-normal
  * \dynamics   'Dynamics Chart'
      (duration) !->
        p1p =
          * if u.0 < u.4
              [u.1, u.5, u.0, u.4]
            else
              [u.5, u.1, u.4, u.0]
          * if u.2 < u.6
              [u.3, u.7, u.2, u.6]
            else
              [u.7, u.3, u.6, u.2]
        p2p =
          * if u.1 < u.3
              [u.1, u.3, u.0, u.2]
            else
              [u.3, u.1, u.2, u.0]
          * if u.5 < u.7
              [u.5, u.7, u.4, u.6]
            else
              [u.7, u.5, u.6, u.4]
        pp = 0
        @select-all \.dynamic.p1 .data p1p
          tran .., duration
            .attr \x1 sx << (.0)
            .attr \x2 sx << (.1)
            .attr \y1 (+ pp) << sy << (.2)
            .attr \y2 (+ pp) << sy << (.3)
        @select-all \.dynamic.p2 .data p2p
          tran .., duration
            .attr \x1 (- pp) << sx << (.0)
            .attr \x2 (- pp) << sx << (.1)
            .attr \y1 sy << (.2)
            .attr \y2 sy << (.3)
        @select-all \.outcome .data [0,2,4,6]
          ..each !->
            @__pos__ = x: sx(u[it + 1]), y: sy u[it]
          tran .., duration
            .attr \transform -> "translate(#{sx u[it + 1]}, #{sy u[it]})"
      dynamics: (duration) !->
        @select-all \.outcome .data [0,2,4,6]
          .call drag-dyn
      categories: (duration) !->
  * \categories 'Text Categories'
      (duration) !->
        p1 = [0 2 4 6]map((it, i) -> [i, u[it]])sort usort
          .map(([oi], i) -> [i, oi])sort usort .map (.0 + 1)
        p2 = [1 3 5 7]map((it, i) -> [i, u[it]])sort usort
          .map(([oi], i) -> [i, oi])sort usort .map (.0 + 1)

        current-game = orders[p1]?[p2]
        @select \.name .node!value = current-game
        @select \.zero-sum .text do
          if (u.0 + u.1) is (u.2 + u.3) is (u.4 + u.5) is (u.6 + u.7)
            \Yes
          else
            \No


      dynamics: (duration) !->
      categories: (duration) !->
        @select \.name
          ..select-all \option .data pairs
            .enter!append \option .attr \value ((,i) -> i) .text ([i, j]) ->
              names[i][j]

          p1 = [0 2 4 6]map((it, i) -> [i, u[it]])sort usort
            .map(([oi], i) -> [i, oi])sort usort .map (.0 + 1)
          p2 = [1 3 5 7]map((it, i) -> [i, u[it]])sort usort
            .map(([oi], i) -> [i, oi])sort usort .map (.0 + 1)

          current-game = orders[p1]?[p2]
          ..node!value = current-game

          ..on \change !->
            [i, j] = pairs[@value]
            u := games[i][j]slice!
            d3.select-all \.dwabs .each !->
              @__type__.bind.call d3.select(@first-element-child), 1000ms
  * \order 'Order Table'
    (duration) !->
      coords =
        * 65  125
        * 125 75
        * 165 125
        * 225 75
        * 65  225
        * 125 175
        * 165 225
        * 225 175

      p1s = [0, 2, 4, 6]map((it, i) -> [it, u[it]])sort usort
      p2s = [1, 3, 5, 7]map((it, i) -> [it, u[it]])sort usort

      li = d3.svg.line!

      @select \.order-path.p1
        tran .., 1000ms
          .attr \d li p1s.map -> coords[it.0]
      @select \.order-path.p2
        tran .., 1000ms
          .attr \d li p2s.map -> coords[it.0]
    order: (duration) !->
  * \field 'Vector Field'
    (duration) !->

    field: (duration) !->
      n = @select \canvas .node!
      tot = 200
      particles = for i til tot
        x: Math.random!, y: Math.random!, life: 10 + (Math.random! * 50).|.0
      ctx = n.get-context \2d
      tick = !->
        if n.parent-node?
          request-animation-frame update
      update = !->
        ctx
          ..fill-style = 'rgba(255, 255, 255, 0.1)'
          ..fill-rect 0 0 w, h

        new-p = []
        for p in particles
          [dx, dy] = dyn p.x, p.y
          dx *= 0.03
          dy *= 0.03
          ctx.begin-path!
          ctx.move-to p.x * w, p.y * h
          p.x += dx
          p.y += dy
          ctx.line-to p.x * w, p.y * h
          ctx.stroke!
          if 0 < p.x < 1 and 0 < p.y < 1 and --p.life > 0
            new-p.push p

        particles := new-p
        while particles.length < tot
          particles.push do
            x: Math.random!, y: Math.random!, life: 10

        set-timeout tick, 50ms

      update!

w = h = 200

# a = proportion of p2 playing D
# b = proportion of p1 playing D
# i.e. in normal form with 0,0 in top left
function dyn a, b
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

function usort [ai, a], [bi, b]
  if a is b then 0 else if a > b then 1 else -1

$ = document~get-element-by-id

bind-type = !(type, display) ->
  $ "d#display"
    ..__type__ = TYPE[type]
    while ..first-child?
      ..remove-child ..first-child
    ..append-child $("t-#type")content.clone-node true
    TYPE[type].bind.call d3.select ..first-element-child

init-type = !(type, display) ->
  d = $ "d#display"
  dd = d3.select d
  t = d.__type__
  for type in TYPES
    t.transitions[type.id]?call dd, 1000ms

displays = d3.select \#displays
int-prop \num-displays .on-value !->
  displays.select-all \.display .data d3.range(it)
    ..exit!remove!
    ..enter!append \div .attr \class \display
      ..append \div .append \select
        ..select-all \option .data TYPES .enter!append \option
          .attr \value (.id) .text (.name)
          .attr \selected (, i, j) -> if i is j then \selected
        ..on \change !(, i) ->
          bind-type @value, i
          init-type @value, i
      ..append \div
        ..attr \class \dwrap
        ..append \div
          ..attr \class \dwabs
          ..attr \id (-> "d#it")
          ..each !(, i) ->
            bind-type TYPES[i % *].id, i
            init-type @value, i

