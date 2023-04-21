CLS
DEFDBL A-Z
A = 1: B = 1: C = 1
DO
   C = C + 1
   OLDRATIO = RATIO
   RATIO = A / B
   PRINT USING "     ########################  -  #.######################"; B; RATIO
   NEWVAL = A + B
   A = B
   B = NEWVAL
LOOP UNTIL ABS(OLDRATIO - RATIO) < .000001

