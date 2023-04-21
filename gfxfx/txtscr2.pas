
program tweaked_tweaked_textscroll;
{ Textscroll (see txt itself), uncomment asm, by Bas van Gaalen, Holland, PD }
uses
  crt;

const
  tseg : word = $b800; hi = 1;
  txt : string =
    'howdy world...     this is a multicolored-bigchar-'+
    'proportional-smoothscrolling-textscroll.       of '+
    'course made by bas van gaalen!     it contains an '+
    'extensive number of characters: 0 1 2 3 4 5 6 7 8 '+
    '9 :-) ( / ? ! , . etc...       ';
  cpos : array[0..46] of word = (
    0,5,12,19,26,33,40,47,54,61,65,72,80,87,97,104,111,118,125,132,139,146,
    153,160,170,177,184,191,195,200,205,211,215,222,227,232,240,247,252,259,
    266,273,280,287,294,301,308);
  clen : array[0..46] of byte = (
    3,7,7,7,7,7,7,7,7,4,7,7,7,10,7,7,7,7,7,7,7,7,7,10,7,7,7,4,5,5,6,4,7,5,
    5,4,7,5,7,7,7,7,7,7,7,7,6);
  {$i chars.inc}

var
  pos : word; i,cur,idx,len,line : byte;

procedure retrace; assembler; asm
  mov dx,3dah; @l1: in al,dx; test al,8; jnz @l1;
  @l2: in al,dx; test al,8; jz @l2; end;

procedure cursoroff; assembler; asm
  mov ah,3; mov bh,0; int 10h; or ch,20h; mov ah,1; int 10h; end;

procedure cursoron; assembler; asm
  mov ah,3; mov bh,0; int 10h; and ch,not 20h; mov ah,1; int 10h; end;

begin
  textmode(co80+font8x8);
  cursoroff;
  gotoxy(12,7); writeln('As you can see, not the complete screen is scrolling...');
  idx := 1;
  repeat
    cur := ord(txt[idx]); { get char }
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
    end; { conv ascii to table }
    pos := cpos[cur];
    len := clen[cur];
    for i := 0 to len-1 do begin
      retrace;

      {
      asm
        mov cx,200

       @l3:
        mov dx,03c8h
        mov al,59
        out dx,al
        inc dx
        mov al,cl
        and al,35
        out dx,al
        and al,20
        out dx,al
        push dx

        mov dx,03dah
       @l4:
        in al,dx
        test al,1
        jnz @l4
       @l5:
        in al,dx
        test al,1
        jz @l5

        pop dx
        mov al,cl
        and al,10
        out dx,al
        loop @l3
      end;
      }

      for line := 0 to 4 do begin
        move(mem[tseg:(hi+line)*160+2],mem[tseg:(hi+line)*160],158);
        memw[tseg:158+(hi+line)*160] := chars[line,pos+i];
      end;
    end;
    idx := 1+idx mod length(txt);
  until keypressed;
  cursoron;
  gotoxy(1,7);
end.
