DEFINT A-Z
SCREEN 13
x = 160: y = 100: col = 0
DO
   a$ = INKEY$
   IF a$ = "4" THEN x = x - 1
   IF a$ = "6" THEN x = x + 1
   IF a$ = "8" THEN y = y - 1
   IF a$ = "2" THEN y = y + 1
   IF a$ = "7" THEN x = x - 1: y = y - 1
   IF a$ = "9" THEN x = x + 1: y = y - 1
   IF a$ = "1" THEN x = x - 1: y = y + 1
   IF a$ = "3" THEN x = x + 1: y = y + 1
   CIRCLE (x, y), 50, x
   CIRCLE (x + 1, y), 50, x
   FOR red = 0 TO 63
      OUT &H3C8, col
      OUT &H3C9, red
      OUT &H3C9, -red - 1
      OUT &H3C9, red
      col = col + 1
      IF col > 255 THEN col = 0
   NEXT red
   FOR red = 63 TO 1 STEP -1
      OUT &H3C8, col
      OUT &H3C9, red
      OUT &H3C9, -red - 1
      OUT &H3C9, red
      col = col + 1
      IF col > 255 THEN col = 0
   NEXT red
LOOP UNTIL a$ = CHR$(27)

