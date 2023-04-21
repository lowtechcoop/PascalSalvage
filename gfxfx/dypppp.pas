
program Different_Y_Pixel_Position_Per_Pixel;
{ Failed-backward-old and slow DYPP, not worth looking at... }
{ The posebilities of BGI. ;-) }
uses
  crt,graph;

const
  SinTabLen   = 200;
  Amplitude   = 50;

type
  SinTableArr = array[0..SinTabLen] of word;

var
  SinTable    : SinTableArr;

{----------------------------------------------------------------------------}

procedure InitGraphics;

var
  grDriver,
  grMode    : integer;

begin
  grDriver := CGA;
  grMode := CGAHi;
  initgraph(grDriver,grMode,'I:\BGI');
end;

{----------------------------------------------------------------------------}

procedure CalcSinTable(var SinTab : SinTableArr; SinLen,Amp : word);

var
  X,
  Step : real;
  I    : word;

begin
  Step := (2*pi)/SinLen;
  for I := 0 to SinLen do begin
    X := I*Step;
    SinTab[I] := round(sqr(sin(X))*cos(sin(X))*Amp);
  end;
end;

{----------------------------------------------------------------------------}

procedure DoDypp(SinTab : SinTableArr; SinLen,Amp : word);

const
  Sentence  = 'Explorer was here';
  Len       = length(Sentence)*8;

type
  BitMapArr = array[0..Len] of pointer;
  YPosArr   = array[0..Len] of word;

var
  BitMap    : BitMapArr;
  YPos      : YPosArr;
  I,J,Size,
  Tabpos    : word;

begin
  settextstyle(defaultfont,horizdir,1);
  outtextxy(1,10,Sentence);
  for I := 0 to Len do begin
    Size := imagesize(I,5,I,25);
    getmem(BitMap[I],Size);
    getimage(I,5,I,25,BitMap[I]^);
    YPos[I] := 0;
  end;
  cleardevice;
  TabPos := 0;
  while not keypressed do begin
    for I := Len downto 0 do YPos[I] := YPos[I-1];
    YPos[0] := SinTab[TabPos];
    TabPos := (TabPos+1) mod SinLen;
    for I := 0 to Len do putimage(I,Amp+YPos[I],BitMap[I]^,andput);
  end;
end;

{----------------------------------------------------------------------------}

begin
  InitGraphics;
  CalcSinTable(SinTable,SinTabLen,Amplitude);
  DoDypp(SinTable,SinTabLen,Amplitude);
  closegraph;
end.
