DECLARE SUB oop ()
DECLARE SUB RegstDelay ()
DECLARE SUB DataDelay ()

SCREEN 12
CIRCLE (320, 240), 201, 15


'FOR angle = 0 TO 6 STEP .1
'   LINE (320, 240)-(320 + 200 * SIN(angle), 240 - 200 * COS(angle))
'
'   FOR w = 1 TO 100: NEXT w
'   LINE (320, 240)-(320 + 200 * SIN(angle), 240 - 200 * COS(angle)), 0
'
'NEXT angle

DO
   sec = VAL(RIGHT$(TIME$, 2))
   min = VAL(LEFT$((RIGHT$(TIME$, 5)), 2))
   hour = VAL(LEFT$(TIME$, 2))
   
   minline = (min / 60) * (3.14 * 2)
   secline = (sec / 60) * (3.14 * 2)
   hourline = (hour / 12) * (3.14 * 2)
  
   LINE (320, 240)-(320 + 200 * SIN(secline), 240 - 200 * COS(secline)), 3
   LINE (320, 240)-(320 + 190 * SIN(minline), 240 - 190 * COS(minline)), 4
   LINE (320, 240)-(320 + 150 * SIN(hourline), 240 - 150 * COS(hourline)), 5

t$ = TIME$
WHILE t$ = TIME$
WEND
   LINE (320, 240)-(320 + 200 * SIN(secline), 240 - 200 * COS(secline)), 0
   LINE (320, 240)-(320 + 190 * SIN(minline), 240 - 190 * COS(minline)), 0
   LINE (320, 240)-(320 + 150 * SIN(hourline), 240 - 150 * COS(hourline)), 0
   'SOUND 5000, .1
   oop
   IF NOT min = VAL(LEFT$((RIGHT$(TIME$, 5)), 2)) THEN
   SOUND 1000, 1
   SOUND 2000, 1
   SOUND 3000, 1
   END IF

LOOP

SUB DataDelay
DEFINT A-Z
   FOR a = 1 TO 35
      b = INP(&H388)
   NEXT a
END SUB

SUB oop
DEFINT A-Z
OUT &H388, &H20
OUT &H389, &H10
OUT &H388, &H400
OUT &H389, &H10
OUT &H388, &H60
OUT &H389, &HF0
OUT &H388, &H80
OUT &H389, &H77
OUT &H389, &H98
OUT &H388, &H23
OUT &H389, &H1
OUT &H388, &H43
OUT &H389, &H0
OUT &H388, &H63
OUT &H389, &HF0
OUT &H388, &H83
OUT &H389, &H77
OUT &H388, &HB0
'OUT &H389, &H31
FOR counter = 0 TO 255
   OUT &H388, &HA0
   RegstDelay
   OUT &H389, counter
   DataDelay
NEXT counter
OUT &H388, &HB0
OUT &H389, &H11

END SUB

DEFSNG A-Z
SUB RegstDelay
DEFINT A-Z
   FOR a = 1 TO 6
      b = INP(&H388)
   NEXT
END SUB

