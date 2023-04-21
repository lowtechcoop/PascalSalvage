
program VgaScroll;
{ Neat and simple, one of the first! By Bas van Gaalen, Holland, PD }
uses
  crt,dos;

const
  GSeg   = $A000;
  Bits   : array[0..7] of byte = (128,64,32,16,8,4,2,1);
  ColTab : array[0..7] of byte = (blue,lightblue,cyan,lightcyan,lightcyan,cyan,lightblue,blue);
  ScrT   : string = 'Hai, this is a scroller...      ';

var
  Fseg,Fofs : word;

{----------------------------------------------------------------------------}

procedure Getfont; assembler; asm
  mov ax,1130h; mov bh,1; int 10h; mov Fseg,es; mov Fofs,bp; end;

{----------------------------------------------------------------------------}

procedure SetGraphics(Mode : word); assembler; asm
  mov ax,Mode; int 10h; end;

{----------------------------------------------------------------------------}

procedure Scroll;

var
  I,J : word;
  CharPos,Pos,Color,Character : byte;

begin
  Pos := 1;
  repeat
    Character := ord(ScrT[Pos]);
    for CharPos := 0 to 7 do begin
      for I := 0 to 7 do begin
        if mem[Fseg:Fofs+(Character*8)+I] and Bits[CharPos] <> 0 then Color := ColTab[I]
        else Color := black;
        mem[GSeg:(((24*8)+I)*320)+319] := Color;
      end;
      while (port[$3DA] and 8) <> 0 do;
      while (port[$3DA] and 8) = 0 do;
      for J := 0 to 7 do for I := 0 to 318 do
        mem[GSeg:(((24*8)+J)*320)+I] := mem[GSeg:(((24*8)+J)*320)+1+I];
    end;
    inc(Pos); if Pos = length(ScrT) then Pos := 1;
  until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  clrscr;
  GetFont;
  SetGraphics($13);
  Scroll;
end.
