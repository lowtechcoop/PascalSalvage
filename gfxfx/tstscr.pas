
program tweaked_tweaked_textscroll;
{ scroll test, type some stuff! By Bas van Gaalen, Holland, PD }
uses crt;
const
  tseg : word = $b800; hi = 45;
  txt : string = 'howdy world...      ';
  cpos : array[0..46] of word = (
    0,5,12,19,26,33,40,47,54,61,65,72,80,87,97,104,111,118,125,132,139,146,
    153,160,170,177,184,191,195,200,205,211,215,222,227,232,240,247,252,259,
    266,273,280,287,294,301,308);
  clen : array[0..46] of byte = (
    2,7,7,7,7,7,7,7,7,4,7,7,7,10,7,7,7,7,7,7,7,7,7,10,7,7,7,4,5,5,6,4,7,5,
    5,4,7,5,7,7,7,7,7,7,7,7,6);
  {$i chars.inc} { make this with makeset.pas and follow instructions. ;-) }

var
  pos : word; i,cur,idx,len,line : byte;

procedure retrace; assembler; asm
  mov dx,3dah;
  @l1: in al,dx; test al,8; jnz @l1;
  @l2: in al,dx; test al,8; jz @l2; end;

begin
  textmode(co80+font8x8);
  idx := 1;
  repeat
    cur := ord(readkey);
    if cur = 27 then halt;
    case cur of
      32 : cur := 0;
      33 : cur := 31;
      39 : cur := 29;
      40,41 : dec(cur,7);
      44 : cur := 28;
      45 : cur := 30;
      46 : cur := 27;
      47 : cur := 46;
      48..57 : dec(cur,12);
      58 : cur := 35;
      63 : cur := 32;
      65..90 : dec(cur,64);
      97..122 : dec(cur,96);
    end;
    pos := cpos[cur];
    len := clen[cur];

    for i := 0 to len-1 do begin
      retrace;
      for line := 0 to 4 do begin
        move(mem[tseg:(hi+line)*160+2],mem[tseg:(hi+line)*160],158);
        memw[tseg:158+(hi+line)*160] := chars[line,pos+i];
      end;
    end;

    idx := 1+idx mod length(txt);
  until false;
end.
