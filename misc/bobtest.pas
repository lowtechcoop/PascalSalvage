Program ShadebobTest;
uses crt,gfx3;
var
   bob:array[1..1000] of byte;
   a,b,c,f,r1,r2,x,y:integer;
   x,y,xfactor,yfactor,x1,y1;

const
pi=3.14159;

procedure initbobs;
begin;
end;
procedure drawbobs;


clrscr;
col:= 15;
{  r1 = INT(RND * 10) + 1}
{  r2 = INT(RND * 9) + 1}
    r1: = 3;
    r2: = 5;
{  IF r2 = r1 THEN
  r2 = r2 - (r1 / 5)
  END IF}
FOR a% = 1 TO 361
    xfactor: = 100 * COS(r1 * a * Pi div 180)
    yfactor: = 50 * SIN(r2 * a * Pi div 180)
    x1: = xfactor + 160;
    y1: = yfactor + 100;
    n: = 1;
    f: = f + 1;

    IF f = 1 THEN
       GET (x1, y1)-(x1 - 15, y1 - 15), bob%
       PUT (x1 + n, y1 + 1), bob%, XOR
    ELSE
       GET (x1, y1)-(x1 - 15, y1 - 15), bob%
       PUT (x1 + n, y1 + 1), bob%, XOR
    END IF

    FOR w = 1 TO 1000: NEXT w
    NEXT a%
    FOR w = 0 TO 2000: NEXT w


begin

end;



begin;


end.



