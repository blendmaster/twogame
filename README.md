# 2-player game visualization

Based primarily off of [Bryan Brun's *Transforming 2x2 Games* chart][0].

[0]: http://www.bryanbruns.com/2x2chart/

## Design

displays: .display #d[1-n]
classes: .utility # .u[cd]{2}[12]
         .player # .p[12]
         .outcome # o[cd]{2}

js global state, since a unique control `<input>` doesn't exist:

    u = [[\ccp1 \ccp2] [\cdp1 \cdp2]
         [\dcp1 \dcp2] [\ddp1 \ddp2]]

The type of each display is controlled via `<select>`. The number of displays
is controlled via `<input type=range>` since making the equivalent of
a Backbone collection with Bacon.js is difficult.

