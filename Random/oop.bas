DECLARE SUB RegstDelay ()
DECLARE SUB DataDelay ()
DEFINT A-Z

OUT &H388, &H20
RegstDelay
OUT &H389, &H1
DataDelay
OUT &H388, &H40
RegstDelay
OUT &H389, &H10
DataDelay
OUT &H388, &H60
RegstDelay
OUT &H389, &HF0
DataDelay
OUT &H388, &H80
RegstDelay
OUT &H389, &H77
DataDelay
OUT &H389, &H98
DataDelay
OUT &H388, &H23
RegstDelay
OUT &H389, &H1
DataDelay
OUT &H388, &H43
RegstDelay
OUT &H389, &H0
DataDelay
OUT &H388, &H63
RegstDelay
OUT &H389, &HF0
DataDelay
OUT &H388, &H83
RegstDelay
OUT &H389, &H77
DataDelay
OUT &H388, &HB0
RegstDelay
OUT &H389, &H31
DataDelay
FOR counter = 0 TO 255
   OUT &H388, &HA0
   RegstDelay
   OUT &H389, counter
   DataDelay
NEXT counter
OUT &H388, &HB0
RegstDelay
OUT &H389, &H11
DataDelay


DEFSNG A-Z
SUB DataDelay
DEFINT A-Z
   FOR a = 1 TO 35
      b = INP(&H388)
   NEXT a
END SUB

DEFSNG A-Z
SUB RegstDelay
DEFINT A-Z
   FOR a = 1 TO 6
      b = INP(&H388)
   NEXT
END SUB

