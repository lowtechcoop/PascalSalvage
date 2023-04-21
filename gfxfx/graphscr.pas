{$G+}

{ Partialy Assembler written graphics scroll.
  G+ : 80x86+ only!
  Btw: text by Aerosmith (Livin' on the Edge) ;-))
  Still very backward. First assembler try-outs! }

program GraphicScroll;

uses
  crt,dos;

const
  ScrSeg : word = $a000;
  ScrTxt : string = 'Tell me what you think about your situation... Complication... Aggravation... Is getting to you!      ';
  Color  : array[0..15] of byte = (
    blue,lightblue,blue,lightblue,lightblue,cyan,lightblue,cyan,
    cyan,lightblue,cyan,lightblue,lightblue,blue,lightblue,blue);

var
  F8x8Seg,F8x8Ofs  : word;

{----------------------------------------------------------------------------}

procedure GetFont8x8; assembler; asm
  mov ax,01130h; mov bh,3; int 10h; mov F8x8Seg,es; mov F8x8Ofs,bp; end;

{----------------------------------------------------------------------------}

procedure VideoMode(Mode : word); assembler; asm
  mov ax,Mode; int 10h end;

{----------------------------------------------------------------------------}

procedure setRGB (register, red, green, blue : byte);
begin
  port[$3C8] := register;       { register in video DAC kiezen }
  port[$3C9] := red;               { kleurwaarden laden }
  port[$3C9] := green;
  port[$3C9] := blue;
end;

{----------------------------------------------------------------------------}

procedure Scroll;

var
  TxtPos : word;
  J,CharPos,Character : byte;
  I : shortint;

begin
  TxtPos := 1;
  repeat
    CharPos := 0;
    Character := ord(ScrTxt[TxtPos]);
    for CharPos := 0 to 7 do begin
      {setrgb(0,0,20,30);}

      I := 15;
      while I >= 0 do begin
        if (mem[F8x8Seg:F8x8Ofs+(8*Character)+(I div 2)] shl CharPos) and 128 <> 0 then begin
          memw[$A000:318+((23*8+I)*320)] := Color[I]+Color[I]*256;
         memw[$A000:638+((23*8+I)*320)] := Color[I]+Color[I]*256;
        end
        else begin
          memw[$A000:318+((23*8+I)*320)] := black;
          memw[$A000:638+((23*8+I)*320)] := black;
        end;
        dec(I);
      end;

      asm
        push ds
        mov dx,$3da
       @Wait:
        in al,dx
        test al,8
        jz @Wait
       @Retr:
        in al,dx
        test al,8
        jnz @Retr
        mov si,2+(23*8*320)
        mov di,0+(23*8*320)
        mov es,ScrSeg
        mov ds,ScrSeg
        mov cx,320*16
        rep movsw
        pop ds
      end;
      {setrgb(0,0,0,0);}
    end;
    inc(TxtPos);
    if TxtPos = length(ScrTxt) then TxtPos := 1;
  until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  Videomode($13);
  GetFont8x8;
  Scroll;
  textmode(lastmode);
end.
