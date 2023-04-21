
{ Try to make smoothscrolling textscroll }
{ whoops, one of the very firsts. ;-) }

program CharTest;

uses
  crt,dos,tpfast;

const
  Bits   : array[0..7] of byte = (128,64,32,16,8,4,2,1);
  ScrTxt : string = 'Howdy folks, this is a scrolltext...           ';

var
  Font8x8Seg,
  Font8x8Ofs  : word;

procedure GetFont8x8(var Segment,Offset : word);

var
  Reg : Registers;

begin
  Reg.AX := $1130;
  Reg.BH := $3;
  Intr($10,Reg);
  Segment := Reg.ES;
  Offset := Reg.BP;
end;

procedure Scroll(Segment,Offset : word);

var
  TxtPos    : word;
  CharPos,
  I,J,
  Character : byte;

begin
  TxtPos := 1;
  repeat
    CharPos := 0;
    Character := ord(ScrTxt[TxtPos]);
    for CharPos := 0 to 7 do begin

      {I := 0;
      while I < 159 do begin
        for J := 0 to 15 do mem[$B800:I+(J*160)] := mem[$B800:2+I+(J*160)];
        inc(I,2);
      end;}

      {scrollx('l',1,1,80,16,1,white);}

      I := 0;
      while I < 15 do begin
        if mem[Font8x8Seg:Font8x8Ofs+(8*Character)+(I div 2)] and Bits[CharPos] <> 0 then begin
          mem[$B800:158+(I*160)] := ord('Û');
          mem[$B800:318+(I*160)] := ord('Û');
        end
        else begin
          mem[$B800:158+(I*160)] := ord(' ');
          mem[$B800:318+(I*160)] := ord(' ');
        end;
        inc(I,2);
      end;

      asm

          push ES
          push DS
{
          mov  CX,7
        @Lus1:
          push CX
          mov  BX,CX
}
          mov  DX,$3DA
        @Wait:
          in   AL,DX
          test AL,08h
          jz   @Wait
        @Retr:
          in   AL,DX
          test AL,$08
          jnz  @Retr

          mov  SI,2
          mov  DI,0
          mov  CX,16
        @Lus2:
          push CX
          mov  AX,$B800
          mov  ES,AX
          mov  DS,AX
          mov  CX,79
          rep  movsw

          {mov  BX,@ScrTxt}

          inc  DI
          inc  DI
          inc  SI
          inc  SI
          pop  CX
          loop @Lus2
{          pop  CX
          loop @Lus1
}
          pop DS
          pop ES
      end;

    end;
    inc(TxtPos);
    if TxtPos = length(ScrTxt) then TxtPos := 1;
  until keypressed;
end;

begin
  textcolor(white); textbackground(black);
  clrscr;
  cursoroff;
  GetFont8x8(Font8x8Seg,Font8x8Ofs);
  Scroll(Font8x8Seg,Font8x8Ofs);
  cursoron;
end.
