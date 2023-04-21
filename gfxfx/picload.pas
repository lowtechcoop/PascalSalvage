{$I-,V-}

program PictureLoader;
{ Displays raw pictures (same as datload, but now with pal at $20 and
  data at $320), by Bas van Gaalen, Holland, PD }
uses
  crt,dos;

const
  Gseg = $A000;

type
  Str80 = string[80];
  BufTp = array[0..4095] of byte;
  PalBuf = array[0..$2ff] of byte;

var
  PicFile  : file;
  Palette  : PalBuf;
  Buffer   : BufTp;
  FileName : pathstr;
  I,BufCt  : word;
  NofRead  : integer;

{----------------------------------------------------------------------------}

procedure Error(Err : Str80);

begin
  writeln;
  writeln(Err);
  halt(1);
end;

{----------------------------------------------------------------------------}

procedure SetGraphics(Mode : byte); assembler;

asm
  mov AH,0
  mov AL,Mode
  int 10h
end;

{----------------------------------------------------------------------------}

procedure InstallColors(Buf : PalBuf);

  procedure SetColor(Color,Red,Green,Blue : byte);

  begin
    port[$3C8] := Color;
    port[$3C9] := Red;
    port[$3C9] := Green;
    port[$3C9] := Blue;
  end;

var
  I : byte;
  C : word;

begin
  C := 0;
  for I := 0 to 255 do begin
    SetColor(I,Buf[C],Buf[C+1],Buf[C+2]);
    inc(C,3);
  end;
end;

{----------------------------------------------------------------------------}

begin
  FileName := paramstr(1);
  if FileName = '' then begin
    writeln('Load raw picture. Please enter filename on commandline.');
    halt;
  end;
  assign(PicFile,FileName);
  reset(PicFile,1); if ioresult <> 0 then Error(FileName+' not found in current dir');

  seek(PicFile,$20);
  blockread(PicFile,Palette,$300);
  SetGraphics($13);
  InstallColors(Palette);

  seek(PicFile,$320);
  BufCt := 0;
  repeat
    blockread(PicFile,Buffer,4096,NofRead);
    for I := 0 to NofRead-1 do mem[Gseg:BufCt+I] := Buffer[I];
    inc(BufCt,NofRead);
  until NofRead < 4096;
  close(PicFile);

  repeat until keypressed;
  SetGraphics(3);
end.
