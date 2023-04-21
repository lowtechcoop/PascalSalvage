DECLARE SUB PALENDROMIC (Year)

CLS
FOR Yr = 1900 TO 1999
   PRINT "-----------------"; Yr; "-----------------"
   PALENDROMIC (Yr)
NEXT Yr

SUB PALENDROMIC (Year)
   Year$ = RIGHT$(LTRIM$(RTRIM$(STR$(Year))), 2)
   Year = VAL(Year$)
   PalYear = VAL(RIGHT$(Year$, 1) + LEFT$(Year$, 1))
   IF PalYear > 31 THEN EXIT SUB
   FOR Month = 1 TO 12
      FOR Day = 1 TO 31
         IF Month > 9 THEN
            Month$ = LTRIM$(RTRIM$(STR$(Month)))
         ELSE
            Month$ = "0" + LTRIM$(RTRIM$(STR$(Month)))
         END IF
         IF Day > 9 THEN
            Day$ = LTRIM$(RTRIM$(STR$(Day)))
         ELSE
            Day$ = "0" + LTRIM$(RTRIM$(STR$(Day)))
         END IF
         PalMonth$ = RIGHT$(Month$, 1) + LEFT$(Month$, 1)
         Palday$ = RIGHT$(Day$, 1) + LEFT$(Day$, 1)
         IF Palday$ = Year$ AND Month$ = PalMonth$ OR Palday$ = Year$ AND LEFT$(Month$, 1) = "0" THEN
            PRINT "     "; Day$; "/"; Month$; "/"; Year$
         END IF
      NEXT Day
   NEXT Month
END SUB

