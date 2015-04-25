extensions [sound] 

patches-own [newColor line]
globals [score] 
breed [balls ball] 
breed [points point]


to-report even? [n]
  report remainder n 2 = 0
end

to-report odd? [n] 
  report not even? n 
end

to-report everyThird? [n]
  report remainder n 3 = 0
end

to-report everyFourth? [n] 
  report remainder n 4 = 0 
end

to-report everyFifth? [n] 
  report remainder n 5 = 0 
end

to-report everySixth? [n] 
  report remainder n 6 = 0 
end

to-report listLines
  report remove-duplicates [line] of patches with [pcolor != black] 
end

  

to-report loser1? 
  if [ycor] of ball 0 = max-pycor or score < 0 
  [report true] 
  report false
end 

to-report loser2? 
  if score < 0 
  [report true] 
  report false
end





to newGame
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks 
    
    makeBarsL1
  makeCharacter
  
end









to nameLines 
  ask patches with [pcolor != black]
  [set line pycor]
end

to functionGap [x]
  ask n-of one-of [ 1 2  ] patches with [line = x ] 
  [set pcolor black]
end

to giveBarsGaps
   foreach listLines
   functionGap
   ask one-of patches with [pycor = 0] 
   [set pcolor black]
end











to makeBarsL1 
  ask patches with [everySixth? pycor ] 
  [set pcolor 45] 
  nameLines
 giveBarsGaps
   
end  
  

to makeBarsL2 
 ask patches with [everyFifth? pycor ] 
  [set pcolor 65]
  nameLines
 giveBarsGaps
  

end  

to makeBarsL3 
  ask patches with [everyFourth? pycor ] 
  [set pcolor 85] 
  nameLines
 giveBarsGaps
end  

to makeBarsL4 
  ask patches with [everyThird? pycor ] 
  [set pcolor 115] 
 nameLines
 giveBarsGaps
end  

to makeBarsL5 
  ask patches with [even? pycor ] 
  [set pcolor 135] 
  nameLines
 giveBarsGaps
end  








to makeCharacter 
  crt 1 
  [set breed balls
    move-to one-of patches with [pcolor = black and pxcor > 5 ] 
    set heading 180
    set shape "circle" 
    set color red
    setxy 0 1 
    set score 0]
end 
to addPoints 
  crt 3
  [ set breed points
    set shape one-of ["tree" "flower" "flower" "flower" "flower" "bug" "bug" "bug" "bug" "car"  ] 
    move-to one-of patches with [pcolor = black]
    set heading 0
    set size 3
  ]
end







to moveNorth
  
  ask patches 
  [set newColor [pcolor] of patch-at 0 -1]
  ask patches 
  [set pcolor newColor]
  ask ball 0 
  [set score score + 1]
  if [ycor] of balls = max-pycor   
  [stop]  
 
end 
  
 

to fallDown
  ask ball 0
  [if [pcolor] of patch-ahead 1 = black
    and [ycor] of ball 0 > min-pycor 
    [set ycor ycor - 1
      
    ] ]
   


end













 to killPoints 
  ask points with [ycor = max-pycor or any? balls-here] 
  [die] 
   
  end


to ScorePoints 
  ask balls with [ any? points-here with [shape = "flower"] ]
    [set score score + 10]
    ask balls with [any? points-here with [shape = "bug"] ]
    [set score score - 10]
   ask balls with [any? points-here with [shape = "car"]]
   [lose] 
   ask balls with [any? points-here with [shape = "tree"]]
   [hatch 3 
     [ set breed points
       set shape "flower" 
       set size 3
       setxy random-xcor ycor]]
   

  killPoints
end

to moveCars 
  ask points with [shape = "car" ] 
  [setxy xcor + 1 ycor ]
end

to BarBlock
  
  ask balls with [pcolor != black] 
    [setxy xcor ycor + 1]
    ask points  with [pcolor != black] 
      [setxy xcor ycor + 2] 
    
  end 

to moveLeft 
  ask ball 0 
  [if xcor > min-pxcor 
  [set xcor xcor - 1 ]
  ]
  every .02 [fallDown]
end

to moveRight 
  ask ball 0 
  [if xcor < max-pxcor 
  [set xcor xcor + 1] 
  ] 
  every .02 [fallDown]
end 







 



  

to lose 
  ask ball 0 
  [set shape "face sad" 
    set size 10
    setxy 0 0]
end 

to setLevel 
   if score = 100
  [cp
    makeBarsL2] 
  if score = 100
    [cp
    makeBarsL3] 
   if score = 300
  [cp
    makeBarsL4] 
   if score = 400
  [cp
    makeBarsL5] 
end

to win 
  if score = 500
  [ ask ball 0 
    [set shape "face happy" 
      set size 10
      setxy 0 0
      set heading 0] ]
  end
  


  
to startGame 
  every 10 [addPoints]
  scorePoints
  every .02 [fallDown]

  every .4
  [moveNorth]  
  BarBlock
   if loser1? 
  [lose stop]
  if loser2? 
  [lose stop]
  
  setLevel  
  every .7 [moveCars]
  win
end 

@#$#@#$#@
GRAPHICS-WINDOW
210
10
685
686
15
21
15.0
1
10
1
1
1
0
1
1
1
-15
15
-21
21
0
0
1
ticks
30.0

BUTTON
25
38
111
71
NIL
newGame
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
23
103
112
136
NIL
startGame
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
39
163
131
196
NIL
moveLeft
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
59
210
160
243
NIL
moveRight
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

MONITOR
64
287
122
332
NIL
score 
17
1
11

BUTTON
775
211
881
244
NIL
giveBarsGaps
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

Falldown is a game where the screen is continuously moving up and the goal is to not get the ball hit by the top wall. 
## HOW IT WORKS

  The ball is designed to fall through the gaps in the given bars. The longer the ball survives the more points the player acquires. In order to level up, the score has to reach certain numbers: Level 1 = 0, Level 2 = 100, Level 3 = 200, and so forth. There are 5 levels in total. The player wins after reaching 500. 



## HOW TO USE IT

Use the Letter A key (left) and Letter D key (right) to maneuver the ball.It automatically falls through the gaps. 

## THINGS TO NOTICE

There are also extra elements that can add or subtract points. The flowers adds ten points and the bugs subtract 10 points. When you hit the tree, 3 extra flowers replace it (which means 30 extra points!). Since the turtles are set to bounce, the player can only receive points from the positive elements when they are settled on the bar.  it when it’s on the ground, and if you want to avoid the car/bug, slip by it while it’s in the air. There is no way to get back up once you fall through a hole. So once a flower/tree is passed, it cannot be hit again. There are also two other possible ways of losing 

## CREDITS AND REFERENCES

http://itunes.apple.com/us/app/falldown!/id323493586?mt=8 (original game) 

Mr. Platek helped with the code moveNorth and fallDown

to moveNorth
  
  ask patches 
  [set newColor [pcolor] of patch-at 0 -1]
  ask patches 
  [set pcolor newColor]
  ask ball 0 
  [set score score + 1]
  if [ycor] of balls = max-pycor   
  [stop]  
 
end 

to fallDown
  ask ball 0
  [if [pcolor] of patch-ahead 1 = black
    and [ycor] of ball 0 > min-pycor 
    [set ycor ycor - 1
      
    ] ]
   


end
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
false
0
Circle -13840069 true false 96 182 108
Circle -13840069 true false 110 127 80
Circle -13840069 true false 110 75 80
Line -2674135 false 150 100 80 30
Line -2674135 false 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -1184463 true false 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -16777216 true false 47 195 58
Circle -16777216 true false 195 195 58

circle
true
0
Circle -7500403 true true 0 0 300
Line -7500403 true 105 165 165 240
Circle -7500403 true true 120 165 30
Rectangle -7500403 true true 135 165 135 180

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

clock
true
0
Circle -7500403 true true 30 30 240
Polygon -16777216 true false 150 31 128 75 143 75 143 150 158 150 158 75 173 75
Circle -16777216 true false 135 135 30

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
true
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -13791810 true false 85 132 38
Circle -13791810 true false 130 147 38
Circle -13791810 true false 192 85 38
Circle -13791810 true false 85 40 38
Circle -13791810 true false 177 40 38
Circle -13791810 true false 177 132 38
Circle -13791810 true false 70 85 38
Circle -13791810 true false 130 25 38
Circle -1184463 true false 96 51 108
Circle -955883 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -13840069 true false 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -13840069 true false 65 21 108
Circle -13840069 true false 116 41 127
Circle -13840069 true false 45 90 120
Circle -13840069 true false 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
