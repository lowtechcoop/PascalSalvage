{Special thanx to mark@mbaldwin.demon.co.uk for writing this program.
 Slight modifications by TCA of NewOrder}
program vesainfo;

uses vesaunit;

const
  Digits : array[0..$F] of Char = '0123456789ABCDEF';

function HexW(W : Word) : string;
    {-Return hex string for word}
begin
 HexW[0] := #4;
 HexW[1] := Digits[hi(W) shr 4];
 HexW[2] := Digits[hi(W) and $F];
 HexW[3] := Digits[lo(W) shr 4];
 HexW[4] := Digits[lo(W) and $F];
end;

{The CRT unit has been known to cause problems on very fast PCs, therefore
I decided to write the only procedure in this program that was in the CRT
unit.}
procedure clrscr; assembler;
asm
        mov     es,segb000
        xor     di,di
        mov     cx,32000
        mov     ax,0720h
        rep     stosw   {Clear screen}
        mov     ah,2
        xor     dx,dx
        xor     bh,bh
        int     10h     {reset to upper-left corner}
end;

function Trim(S : string) : string;
    {-Return a string with leading and trailing white space removed}
var
 I : Word;
 SLen : Byte absolute S;
begin
 while (SLen > 0) and (S[SLen] <= ' ') do
  Dec(SLen);
 I := 1;
 while (I <= SLen) and (S[I] <= ' ') do
  Inc(I);
 Dec(I);
 if I > 0 then Delete(S, 1, I);
 Trim := S;
end;

function LeftPadCh(S : string; Ch : Char; Len : Byte) : string;
    {-Return a string left-padded to length len with ch}
var
 o : string;
 SLen : Byte absolute S;
begin
 if Length(S) >= Len then
  LeftPadCh := S
 else if SLen < 255 then begin
  o[0] := Chr(Len);
  Move(S[1], o[Succ(Word(Len))-SLen], SLen);
  FillChar(o[1], Len-SLen, ord(Ch));
  LeftPadCh := o;
 end;
end;

function LeftPad(S : string; Len : Byte) : string;
   {-Return a string left-padded to length len with blanks}
begin
  LeftPad := LeftPadCh(S, ' ', Len);
end;

function PadCh(S : string; Ch : Char; Len : Byte) : string;
    {-Return a string right-padded to length len with ch}
var
  o : string;
  SLen : Byte absolute S;
begin
  if Length(S) >= Len then
    PadCh := S
  else begin
    o[0] := Chr(Len);
    Move(S[1], o[1], SLen);
    if SLen < 255 then
      FillChar(o[Succ(SLen)], Len-SLen, ord(Ch));
    PadCh := o;
  end;
end;

function Pad(S : string; Len : Byte) : string;
    {-Return a string right-padded to length len with blanks}
begin
 Pad := PadCh(S, ' ', Len);
end;

function Long2Str(L : LongInt) : string;
    {-Convert a long/word/integer/byte/shortint to a string}
var
    S : string;
begin
 Str(L, S);
 Long2Str := S;
end;

var
  i: Integer;
  num: Word;
  ii: Byte;
  mode: String;

begin
 if IsVESAInstalled (VESARec^)=$4f then
  begin
   repeat
    ClrScr;
    i:=0;
    writeln('Mode # (hex) | Resolution | Bits Per Pixel | Memory Model | Granularity');
    while VESARec^.VideoModePtr^ [i] <> $FFFF do
     begin
      Write (Pad (HexW (VESARec^.VideoModePtr^ [i]),8));
      GetModeInfo (VESARec^.VideoModePtr^ [i], ModeRec^);
      with ModeRec^ do
       Writeln (LeftPad (Long2Str (XRes)+'x'+Long2Str (YRes),15),'          ',
                BitsPerPixel:2,'              ',
                MemoryModel:2,'            ',
                Granularity);
      Inc (i);
     end;
    Writeln;
    Write('Enter video mode, or hit enter to exit: ');
    Readln(mode);
    mode:=Trim(mode);
    if mode<>'' then
     begin
      num:=0;
      ii:=0;
      for i:=Length(mode) downto 1 do
       begin
        if mode[i] in ['0'..'9'] then
         inc(num, ((Ord (mode [i]) - Ord ('0')) shl ii))
        else inc(num,ord(upcase(mode[i]))-ord('A')+10);
        Inc (ii,4);
       end;
      if GetModeInfo (num, ModeRec^)=$4f then
       begin
        ClrScr;
        with ModeRec^ do
         begin
          Writeln ('Information for mode ',HexW (num),'h - ',XRes,'x',YRes,' ',BitsPerPixel,'bit color');
          Writeln;
          Write ('Can this mode be used with the attached monitor?    ');
          if ModeAttributes and 1 = 1 then Writeln ('Yes') else Writeln ('No');
          Write ('Are the BIOS text functions supported in this mode? ');
          if ModeAttributes and 4 = 4 then Writeln ('Yes') else Writeln ('No');
          Write ('Monochrome or colour?                               ');
          if ModeAttributes and 8 = 8 then Writeln ('Colour') else Writeln ('Monochrome');
          Write ('Mode type                                           ');
          if ModeAttributes and 16 = 16 then Writeln ('Graphic') else Writeln ('Text');
          Writeln;
          Writeln ('Access window information:');
          Write ('  A ');
          if WindowAFlags and 1 = 1 then Write ('Available') else Write ('Not Available');
          Write (',');
          if WindowAFlags and 2 = 2 then Write ('Read Access') else Write ('No Read Access');
          Write (',');
          if WindowAFlags and 4 = 4 then Writeln ('Write Access') else Writeln ('No Write Access');
          Write ('  B ');
          if WindowBFlags and 1 = 1 then Write ('Available') else Write ('Not Available');
          Write (',');
          if WindowBFlags and 2 = 2 then Write ('Read Access') else Write ('No Read Access');
          Write (',');
          if WindowBFlags and 4 = 4 then Writeln('Write Access') else Writeln('No Write Access');
          Writeln;
          Writeln('Granularity                                         ',Granularity,'k');
          Writeln('Size of the two access windows                      ',WindowSize,'k');
          Writeln('Segment address of first access window              ',HexW(WindowASeg),'h');
          Writeln('Segment address of second access window             ',HexW(WindowBSeg),'h');
          Writeln('Number of bytes required for each pixel line        ',BytesPerLine);
          Writeln('Width of character matrix in pixels                 ',CharWidth);
          Writeln('Height of character matrix in pixels                ',CharHeight);
          Writeln('Number of bitplanes                                 ',NumBitPlanes);
          Writeln('Number of bits per screen pixel                     ',BitsPerPixel);
          Writeln('Number of memory blocks                             ',NumberOfBanks);
          Writeln('Memory model                                        ',MemoryModel);
          Writeln('Size of memory blocks                               ',BankSize);
         end;
       end
        else Writeln ('Invalid mode');
      Writeln;
      Write ('Press any key...');
      Readln;
     end;
    until Trim (mode) = '';
  end
  else Writeln ('VESA is not installed.');
end.



