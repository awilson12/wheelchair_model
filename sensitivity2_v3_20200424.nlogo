; breeds
breed [patients patient]
breed [wheelchairs wheelchair]
breed [nurses nurse]

nurses-own[location]
patients-own[location transported? nextlocation contamCdiff contamMRSA AH finalcontammrsa finalcontamcdiff contamCdiffhandtemp contamMRSAhandtemp finalcontammrsa2 finalcontamcdiff2]
wheelchairs-own [contamCdiff1 contamCdiff2 contamMRSA1 contamMRSA2 AWwheel contamCdifftemp contamMRSAtemp]
patches-own[contamCdiff3 contamMRSA3 zone AW]

to setup
  ca ;clear all
  reset-ticks
  set-patch-size 3;
  resize-world -168 168 -168 168;
  ; set up 7 zones:
  ; 1. Acute
    let zone1-patches patches with [pxcor < 0 and pycor > 84 ]
    ask zone1-patches [
      set zone "Acute"
      set AW 0.25 * 535
      set contamMRSA3 0
      set contamCdiff3 0
      set pcolor white]

  ; 2. Common Spaces
  let zone2-patches patches with [ pycor < -84 ]
    ask zone2-patches [
      set zone "Common Spaces"
      set AW 0.25 * 535
      set contamMRSA3 0
      set contamCdiff3 0
      set pcolor white]

  ; 3. Domicilliary
    let zone3-patches patches with [ pxcor > 0 and pycor > 84]
    ask zone3-patches [
      set zone "Domicilliary"
      set AW 0.25 * 535
      set contamMRSA3 0
      set contamCdiff3 0
      set pcolor white]

  ; 4. Long Term Care
    let zone4-patches patches with [ pxcor > 0 and pycor < 84 and pycor > 0 ]
    ask zone4-patches [
      set zone "Long Term Care"
      set AW 0.25 * 535
      set contamMRSA3 0
      set contamCdiff3 0
      set pcolor white]

  ; 5. Outpatient Clinics
     let zone5-patches patches with [ pxcor < 0 and pycor < 84 and pycor > 0 ]
    ask zone5-patches [
      set zone "Out Patient Clinics"
      set AW 0.25 * 535
      set contamMRSA3 0
      set contamCdiff3 0
      set pcolor white]

  ; 6. Radiology
     let zone6-patches patches with [ pxcor < 0 and pycor < 0 and pycor > -84 ]
    ask zone6-patches [
      set zone "Radiology"
      set AW 0.25 * 535
      set contamMRSA3 0
      set contamCdiff3 0
      set pcolor white]

  ; 7. Specialy Care Services
   let zone7-patches patches with [ pxcor > 0 and pycor < 0 and pycor > -84 ]
    ask zone7-patches [
      set zone "Specialty Care Services"
      set AW 0.25 * 535
      set contamMRSA3 0
      set contamCdiff3 0
      set pcolor white]

  ; creating patients
  create-patients 1 [
    set AH random-float 90 + 445
    set size 3.3
    set color blue
    set shape "person"
    set transported? false
    let start random-float 1
    if start <= 1 / 7
       [set location "Acute"
        move-to one-of patches with [not any? patients-here and zone = "Acute"]]
    if start > 1 / 7 and start <= 2 / 7
       [set location "Common Spaces"
       move-to one-of patches with [not any? patients-here and zone = "Common Spaces"]]
    if start > 2 / 7 and start <= 3 / 7
       [set location "Domicilliary"
       move-to one-of patches with [not any? patients-here and zone = "Domicilliary"]]
    if start > 3 / 7 and start <= 4 / 7
       [set location "Long Term Care"
        move-to one-of patches with [not any? patients-here and zone = "Long Term Care"]]
    if start > 4 / 7 and start <= 5 / 7
       [set location "Out Patient Clinics"
          move-to one-of patches with [not any? patients-here and zone = "Out Patient Clinics"]]
    if start > 5 / 7 and start <= 6 / 7
       [set location "Radiology"
          move-to one-of patches with [not any? patients-here and zone = "Radiology"]]
    if start > 6 / 7 and start <= 7 / 7
       [set location "Specialty Care Services"
          move-to one-of patches with [not any? patients-here and zone = "Specialty Care Services"]]
   ]

  ;creating nurses
  create-nurses 1 [
    set size 3.3
    set color yellow
    set shape "person"
    let start.2 random-float 1
     if start.2 <= 1 / 7
       [set location "Acute"
        move-to one-of patches with [zone = "Acute"]]
    if start.2 > 1 / 7 and start.2 <= 2 / 7
       [set location "Common Spaces"
        move-to one-of patches with [zone = "Common Spaces"]]
    if start.2 > 2 / 7 and start.2 <= 3 / 7
       [set location "Domicilliary"
          move-to one-of patches with [zone = "Domicilliary"]]
    if start.2 > 3 / 7 and start.2 <= 4 / 7
       [set location "Long Term Care"
          move-to one-of patches with [zone = "Long Term Care"]]
    if start.2 > 4 / 7 and start.2 <= 5 / 7
       [set location "Out Patient Clinics"
          move-to one-of patches with [zone = "Out Patient Clinics"]]
    if start.2 > 5 / 7 and start.2 <= 6 / 7
       [set location "Radiology"
          move-to one-of patches with [zone = "Radiology"]]
    if start.2 > 6 / 7 and start.2 <= 7 / 7
       [set location "Specialty Care Services"
    move-to one-of patches with [zone = "Specialty Care Services"]]
    move-to one-of patches with [any? patients-here and not any? nurses-here]
  ]

  ;creating wheelchairs
  create-wheelchairs 1 [
    set size 1.94
    set color gray
    set AWwheel random-float 103.2 + 258.1
    move-to one-of patches with [not any? wheelchairs-here and any? patients-here]
    set contamCdiff1 0
    set contamCdiff2 0
    set contamMRSA1 0
    set contamMRSA2 0
  ]
  ask patients[
    set AH random-float 90 + 445
    set contamCdiff random-float 5 + 1 / AH
    set contamMRSA random-float 909999.6 + 0.38 / AH
    set transported? false

    ; CREATING TIES SO MOVEMENTS ARE TOGETHER
    create-link-to one-of nurses-here [tie]
    create-link-to one-of wheelchairs-here [tie]
  ]
end

to go
  ask patients [transport]
  tick
end

to transport
  if transported? = false [
    ask one-of patients-here [patientcontaminatechair]
    if location = "Acute"[
      let prob random-float 1
      if prob <= 1 / 101
        [move-to one-of patches with [not any? patients-here and zone = "Domicilliary"]
        set transported? true]
      if prob > 1 / 101 and prob <= 24 / 101
        [move-to one-of patches with [not any? patients-here and zone = "Acute"]
        set transported? true]
      if prob > 24 / 101 and prob <= 37 / 101
        [move-to one-of patches with [not any? patients-here and zone = "Common Spaces"]
        set transported? true]
      if prob > 37 / 101 and prob <= 40 / 101
        [move-to one-of patches with [not any? patients-here and zone = "Long Term Care"]
        set transported? true]
      if prob > 40 / 101 and prob <= 45 / 101
        [move-to one-of patches with [not any? patients-here and zone = "Out Patient Clinics"]
        set transported? true]
      if prob > 45 / 101 and prob <= 86 / 101
        [move-to one-of patches with [not any? patients-here and zone = "Radiology"]
        set transported? true]
      if prob > 86 / 101
        [move-to one-of patches with [not any? patients-here and zone = "Specialty Care Services"]
        set transported? true]
  ]

    if location = "Common Spaces"[
      let prob.2 random-float 1
      if prob.2 <= 32 / 253
        [move-to one-of patches with [not any? patients-here and zone = "Acute"]
        set transported? true]
      if prob.2 > 32 / 253 and prob.2 <= 56 / 253
        [move-to one-of patches with [not any? patients-here and zone = "Common Spaces"]
        set transported? true]
      if prob.2 > 56 / 253 and prob.2 <= 59 / 253
        [move-to one-of patches with [not any? patients-here and zone = "Domicilliary"]
        set transported? true]
      if prob.2 > 59 / 253 and prob.2 <= 100 / 253
        [move-to one-of patches with [not any? patients-here and zone = "Long Term Care"]
        set transported? true]
      if prob.2 > 100 / 253 and prob.2 <= 176 / 253
        [move-to one-of patches with [not any? patients-here and zone = "Out Patient Clinics"]
        set transported? true]
      if prob.2 > 176 / 253 and prob.2 <= 198 / 253
        [move-to one-of patches with [not any? patients-here and zone = "Radiology"]
        set transported? true]
      if prob.2 > 198 / 253
        [move-to one-of patches with [not any? patients-here and zone = "Specialty Care Services"]
        set transported? true]
    ]

  if location = "Domicilliary"[
     let prob.3 random-float 1
     if prob.3 <= 0.5
       [move-to one-of patches with [not any? patients-here and zone = "Long Term Care"]
       set transported? true]
     if prob.3 > 0.5
       [move-to one-of patches with [not any? patients-here and zone = "Out Patient Clinics"]
       set transported? true]
    ]

  if location = "Long Term Care" [
      let prob.4 random-float 1
      if prob.4 <= 7 / 175
        [move-to one-of patches with [not any? patients-here and zone = "Acute"]
        set transported? true]
      if prob.4 > 7 / 175 and prob.4 <= 15 / 175
        [move-to one-of patches with [not any? patients-here and zone = "Common Spaces"]
        set transported? true]
      if prob.4 > 15 / 175 and prob.4 <= 18 / 175
        [move-to one-of patches with [not any? patients-here and zone = "Domicilliary"]
        set transported? true]
      if prob.4 > 18 / 175 and prob.4 <= 40 / 175
        [move-to one-of patches with [not any? patients-here and zone = "Long Term Care"]
        set transported? true]
      if prob.4 > 40 / 175 and prob.4 <= 56 / 175
        [move-to one-of patches with [not any? patients-here and zone = "Out Patient Clinics"]
        set transported? true]
      if prob.4 > 56 / 175 and prob.4 <= 63 / 175
        [move-to one-of patches with [not any? patients-here and zone = "Radiology"]
        set transported? true]
      if prob.4 > 63 / 175
        [move-to one-of patches with [not any? patients-here and zone = "Specialty Care Services"]
        set transported? true]
    ]

  if location = "Out Patient Clinics" [
      let prob.5 random-float 1
      if prob.5 <= 37 / 125
        [move-to one-of patches with [not any? patients-here and zone = "Acute"]
         set transported? true]
      if prob.5 > 37 / 125 and prob.5 <= 70 / 125
        [move-to one-of patches with [not any? patients-here and zone = "Common Spaces"]
        set transported? true]
      if prob.5 > 70 / 125 and prob.5 <= 72 / 125
        [move-to one-of patches with [not any? patients-here and zone = "Domicilliary"]
        set transported? true]
      if prob.5 > 72 / 125 and prob.5 <= 92 / 125
        [move-to one-of patches with [not any? patients-here and zone = "Long Term Care"]
        set transported? true]
      if prob.5 > 92 / 125 and prob.5 <= 101 / 125
        [move-to one-of patches with [not any? patients-here and zone = "Out Patient Clinics"]
        set transported? true]
      if prob.5 > 101 / 125 and prob.5 <= 108 / 125
        [move-to one-of patches with [not any? patients-here and zone = "Radiology"]
        set transported? true]
      if prob.5 > 108 / 125
        [move-to one-of patches with [not any? patients-here and zone = "Specialty Care Services"]
        set transported? true]
    ]

  if location = "Radiology"[
      let prob.6 random-float 1
      if prob.6 <= 22 / 33
        [move-to one-of patches with [not any? patients-here and zone = "Acute"]
        set transported? true]
      if prob.6 > 22 / 33 and prob.6 <= 27 / 33
        [move-to one-of patches with [not any? patients-here and zone = "Common Spaces"]
        set transported? true]
      if prob.6 > 27 / 33 and prob.6 <= 29 / 33
        [move-to one-of patches with [not any? patients-here and zone = "Long Term Care"]
        set transported? true]
      if prob.6 > 29 / 33 and prob.6 <= 32 / 33
        [move-to one-of patches with [not any? patients-here and zone = "Out Patient Clinics"]
        set transported? true]
      if prob.6 > 32 / 33
        [move-to one-of patches with [not any? patients-here and zone = "Specialty Care Services"]
        set transported? true]
    ]

  if location = "Specialty Care Services" [
      let prob.7 random-float 1
      if prob.7 <= 26 / 164
        [move-to one-of patches with [not any? patients-here and zone ="Acute"]
        set transported? true]
      if prob.7 > 26 / 164 and prob.7 <= 57 / 164
        [move-to one-of patches with [not any? patients-here and zone = "Common Spaces"]
        set transported? true]
      if prob.7 > 57 / 164 and prob.7 <= 58 / 164
        [move-to one-of patches with [not any? patients-here and zone = "Domicilliary"]
        set transported? true]
      if prob.7 > 58 / 164 and prob.7 <= 141 / 164
        [move-to one-of patches with [not any? patients-here and zone = "Long Term Care"]
        set transported? true]
      if prob.7 > 141 / 164 and prob.7 <= 152 / 164
        [move-to one-of patches with [not any? patients-here and zone = "Out Patient Clinics"]
        set transported? true]
      if prob.7 > 152 / 164 and prob.7 <= 153 / 164
        [move-to one-of patches with [not any? patients-here and zone = "Radiology"]
        set transported? true]
      if prob.7 > 153 / 164
        [move-to one-of patches with [not any? patients-here and zone = "Specialty Care Services"]
        set transported? true]
  ]]

    if transported? = true[
    ask one-of patients-here[
     patientcontaminatechair
     set finalcontamCdiff contamCdiff
     set finalcontammrsa contamMRSA
     patientcontaminatesurf
     set AH random-float 90 + 445
     set contamCdiff 0
     set contamMRSA  0
     set location zone
     set transported?  false
     ask one-of nurses-here [
        clean]]]
end

to clean
  if cleaning = true[
    ask one-of wheelchairs-here [
      set contamMRSA2 contamMRSA2 * (1 - (efficacy / 100))
      set contamMRSA1 contamMRSA1 * (1 - (efficacy / 100))

      set contamCdiff2 contamCdiff2 * (1 - (efficacy / 100))
      set contamCdiff1 contamCdiff1 * (1 - (efficacy / 100))]]
end

to patientcontaminatechair
  let TCdiffwheels (random-float 1.5 + 5.4) / 100
  let TMRSAwheels (random-float 0.1 + 3.9) / 100
  let SHwheels random-float 0.11 + 0.10
  ask one-of wheelchairs-here [
    ;temporary i-1 concentrations
    set contamCdifftemp contamCdiff1
    set contamMRSAtemp  contamMRSA1

    ; calculate change in arm chair conc for c diff
    set contamCdiff1 contamCdiff1 - (TCdiffwheels * SHwheels * (contamCdiff1 - [contamCdiff] of myself)) * ([AH] of myself / AWwheel)

    ;calculate change in arm chair conc for MRSA
    set contamMRSA1 contamMRSA1 - (TMRSAwheels * SHwheels * (contamMRSA1 - [contamMRSA] of myself)) * ([AH] of myself / AWwheel)

      ask one-of patients-here[
      ; calculate change in C diff conc on patient hands
      set contamCdiff contamCdiff - (TCdiffwheels * SHwheels * (contamCdiff - [contamCdifftemp] of myself))
      ; calculate change in MRSA conc on patient hands
      set contamMRSA contamMRSA - (TMRSAwheels * SHwheels * (contamMRSA - [contamMRSAtemp] of myself))
  ]]
end

to patientcontaminatesurf
  let SHsurf random-float 0.245 + 0.005
  let TCdiffsurf  (random-float 21.67 + 0.03) / 100
  let TMRSAsurf  (random-float 20.29 + 0.01) / 100

  ask one-of patients-here[
    ; temporary conc for i-1 for later calc
    set contamCdiffhandtemp contamCdiff
    set contamMRSAhandtemp contamMRSA

    ; change in hand c diff concentration of patient
    set contamCdiff contamCdiff - (TCdiffsurf * SHsurf * (contamCdiff - [contamCdiff3] of patch-here))
    ; change in surface concentration for C diff
    set contamCdiff3 contamCdiff3 - (TCdiffsurf * SHsurf * ([contamCdiff3] of patch-here - contamCdiffhandtemp)) * (AH / [AW] of patch-here)

    ; change in hand mrsa concentration of patient
    set contamMRSA contamMRSA - (TMRSAsurf * SHsurf * (contamMRSA - [contamMRSA3] of patch-here))
    ; change in surface concentration for MRSA
    set contamMRSA3 contamMRSA3 - (TMRSAsurf * SHsurf * ([contamMRSA3] of patch-here - contamMRSAhandtemp)) * (AH / [AW] of patch-here)

    ; setting "final" conc on patient hands after they have touched env surface
    set finalcontamMRSA2 contamMRSA
    set finalcontamCdiff2 contamCdiff
  ]
  ifelse pcolor = black
      []
      [ifelse contamCdiff3 > 0
      [set pcolor scale-color red contamCdiff3 .000001 0]
      [set pcolor white]]

end
@#$#@#$#@
GRAPHICS-WINDOW
203
13
1222
1033
-1
-1
3.0
1
10
1
1
1
0
0
0
1
-168
168
-168
168
0
0
1
ticks
30.0

BUTTON
45
96
108
129
NIL
setup
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
46
152
109
185
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
43
212
152
245
cleaning
cleaning
0
1
-1000

CHOOSER
43
272
181
317
efficacy
efficacy
0 50 70 90 99
3

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

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
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

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
false
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
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
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
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

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
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

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

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1000" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>mean [contamMRSA] of patients</metric>
    <metric>mean [contamCdiff] of patients</metric>
    <metric>mean[finalcontammrsa] of patients</metric>
    <metric>mean[finalcontamcdiff2] of patients</metric>
    <metric>mean[finalcontammrsa2] of patients</metric>
    <metric>mean[finalcontamcdiff] of patients</metric>
    <metric>mean [contamCdiff1] of wheelchairs</metric>
    <metric>mean [contamMRSA1] of wheelchairs</metric>
    <metric>count patches with [Zone = "Acute" and contamMRSA3 &gt; 0]</metric>
    <metric>count patches with [zone = "Domicilliary" and contamMRSA3 &gt; 0]</metric>
    <metric>count patches with [zone = "Long Term Care" and contamMRSA3 &gt; 0]</metric>
    <metric>count patches with [zone = "Common Spaces" and contamMRSA3 &gt; 0]</metric>
    <metric>count patches with [zone = "Out Patient Clinics" and contamMRSA3 &gt; 0]</metric>
    <metric>count patches with [zone = "Radiology" and contamMRSA3 &gt; 0]</metric>
    <metric>count patches with [zone = "Specialty Care Services" and contamMRSA3 &gt; 0]</metric>
    <metric>count patches with [Zone = "Acute" and contamCdiff3 &gt; 0]</metric>
    <metric>count patches with [zone = "Domicilliary" and contamCdiff3 &gt; 0]</metric>
    <metric>count patches with [zone = "Long Term Care" and contamCdiff3 &gt; 0]</metric>
    <metric>count patches with [zone = "Common Spaces" and contamCdiff3 &gt; 0]</metric>
    <metric>count patches with [zone = "Out Patient Clinics" and contamCdiff3 &gt; 0]</metric>
    <metric>count patches with [zone = "Radiology" and contamCdiff3 &gt; 0]</metric>
    <metric>count patches with [zone = "Specialty Care Services" and contamCdiff3 &gt; 0]</metric>
    <enumeratedValueSet variable="cleaning">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="efficacy">
      <value value="0"/>
      <value value="50"/>
      <value value="70"/>
      <value value="90"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="20"/>
    <metric>mean [finalcontammrsa] of patients</metric>
    <metric>mean [finalcontamcdiff] of patients</metric>
    <metric>mean [contamCdiff1] of wheelchairs</metric>
    <metric>mean [contamMRSA1] of wheelchairs</metric>
    <enumeratedValueSet variable="cleaning">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="efficacy">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
