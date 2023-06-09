
program ScreenSaver1;
{ paralax screensaver, run a few times, by Bas van Gaalen, Holland, PD }
uses
  crt,dos;

const
  Xspeed = 1;
  Yspeed = 1;
  NofTab = 6;
  TxtCol = 31;
  ColLen = 17;
  ColTab : array[0..NofTab,0..ColLen] of byte = (
  (3,3,11,3,11,11,15,11,15,15,7,15,7,7,8,7,8,8),
  (8,8,7,8,7,7,15,7,15,15,7,15,7,7,8,7,8,8),
  (1,1,9,1,9,9,11,9,11,11,9,11,9,9,1,9,1,1),
  (4,4,12,4,12,12,15,12,15,15,12,15,12,12,4,12,4,4),
  (3,3,11,3,11,11,15,11,15,15,11,15,11,11,3,11,3,3),
  (3,3,11,3,11,11,15,11,15,15,10,15,10,10,2,10,2,2),
  (4,4,12,4,12,12,15,12,15,15,11,15,11,11,3,11,3,3));

  SinTab : array[0..1000] of byte = (
  100,100,100,100,100,100, 99, 99, 99, 99, 98, 98, 98, 97, 97,
   96, 96, 95, 95, 94, 94, 93, 92, 92, 91, 90, 89, 88, 88, 87,
   86, 85, 84, 83, 82, 81, 80, 79, 78, 77, 76, 75, 74, 73, 72,
   71, 69, 68, 67, 66, 65, 64, 63, 61, 60, 59, 58, 57, 55, 54,
   53, 52, 51, 50, 48, 47, 46, 45, 44, 43, 42, 41, 39, 38, 37,
   36, 35, 34, 33, 32, 32, 31, 30, 29, 28, 27, 26, 26, 25, 24,
   23, 23, 22, 22, 21, 20, 20, 19, 19, 19, 18, 18, 17, 17, 17,
   17, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17,
   17, 17, 18, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23, 24,
   24, 25, 26, 27, 27, 28, 29, 30, 31, 32, 33, 33, 34, 35, 36,
   37, 38, 39, 40, 41, 42, 43, 45, 46, 47, 48, 49, 50, 51, 52,
   53, 54, 55, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68,
   69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 81, 82,
   83, 84, 85, 85, 86, 87, 88, 88, 89, 90, 90, 91, 91, 92, 92,
   93, 93, 94, 94, 95, 95, 95, 96, 96, 97, 97, 97, 97, 98, 98,
   98, 98, 99, 99, 99, 99, 99, 99, 99,100,100,100,100,100,100,
  100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,
  100,100,100,100,100,100,100,100,100,100,100,100,101,101,101,
  101,101,101,101,102,102,102,102,103,103,103,103,104,104,105,
  105,105,106,106,107,107,108,108,109,109,110,110,111,112,112,
  113,114,115,115,116,117,118,119,119,120,121,122,123,124,125,
  126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,
  141,142,143,145,146,147,148,149,150,151,152,153,154,155,157,
  158,159,160,161,162,163,164,165,166,167,167,168,169,170,171,
  172,173,173,174,175,176,176,177,178,178,179,179,180,180,181,
  181,182,182,182,183,183,183,183,184,184,184,184,184,184,184,
  184,184,184,184,184,183,183,183,183,182,182,181,181,181,180,
  180,179,178,178,177,177,176,175,174,174,173,172,171,170,169,
  168,168,167,166,165,164,163,162,161,159,158,157,156,155,154,
  153,152,150,149,148,147,146,145,143,142,141,140,139,137,136,
  135,134,133,132,131,129,128,127,126,125,124,123,122,121,120,
  119,118,117,116,115,114,113,112,112,111,110,109,108,108,107,
  106,106,105,105,104,104,103,103,102,102,102,101,101,101,101,
  100,100,100,100,100,100,100,100,100,100,100,101,101,101,101,
  102,102,102,103,103,104,104,105,105,106,106,107,108,108,109,
  110,111,112,112,113,114,115,116,117,118,119,120,121,122,123,
  124,125,126,127,128,129,131,132,133,134,135,136,137,139,140,
  141,142,143,145,146,147,148,149,150,152,153,154,155,156,157,
  158,159,161,162,163,164,165,166,167,168,168,169,170,171,172,
  173,174,174,175,176,177,177,178,178,179,180,180,181,181,181,
  182,182,183,183,183,183,184,184,184,184,184,184,184,184,184,
  184,184,184,183,183,183,183,182,182,182,181,181,180,180,179,
  179,178,178,177,176,176,175,174,173,173,172,171,170,169,168,
  167,167,166,165,164,163,162,161,160,159,158,157,155,154,153,
  152,151,150,149,148,147,146,145,143,142,141,140,139,138,137,
  136,135,134,133,132,131,130,129,128,127,126,125,124,123,122,
  121,120,119,119,118,117,116,115,115,114,113,112,112,111,110,
  110,109,109,108,108,107,107,106,106,105,105,105,104,104,103,
  103,103,103,102,102,102,102,101,101,101,101,101,101,101,100,
  100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,
  100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,
  100,100, 99, 99, 99, 99, 99, 99, 99, 98, 98, 98, 98, 97, 97,
   97, 97, 96, 96, 95, 95, 95, 94, 94, 93, 93, 92, 92, 91, 91,
   90, 90, 89, 88, 88, 87, 86, 85, 85, 84, 83, 82, 81, 81, 80,
   79, 78, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68, 67, 66, 65,
   64, 63, 62, 61, 60, 59, 58, 57, 55, 54, 53, 52, 51, 50, 49,
   48, 47, 46, 45, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33,
   33, 32, 31, 30, 29, 28, 27, 27, 26, 25, 24, 24, 23, 22, 22,
   21, 21, 20, 20, 19, 19, 18, 18, 18, 17, 17, 17, 17, 16, 16,
   16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 17, 17, 18,
   18, 19, 19, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 26, 26,
   27, 28, 29, 30, 31, 32, 32, 33, 34, 35, 36, 37, 38, 39, 41,
   42, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 54, 55, 57, 58,
   59, 60, 61, 63, 64, 65, 66, 67, 68, 69, 71, 72, 73, 74, 75,
   76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 88, 89,
   90, 91, 92, 92, 93, 94, 94, 95, 95, 96, 96, 97, 97, 98, 98,
   98, 99, 99, 99, 99,100,100,100,100,100,100);

var
  FontSegment,FontOfset : word;

{----------------------------------------------------------------------------}

procedure SetGraphics(Mode : byte); assembler;

asm
  mov AH,0
  mov AL,Mode
  int 10h
end;

{----------------------------------------------------------------------------}

procedure GetFont(var FontSeg,FontOfs : word);

var
  Regs : registers;

begin
  with Regs do begin
    AX := $1130;
    BH := 1;
    intr($10,Regs);
    FontSeg := ES;
    FontOfs := BP;
  end;
end;

{----------------------------------------------------------------------------}

procedure WriteText(Xpos,Ypos : word; Color : byte; ScrTxt : string);

var
  I,J,K : byte;

begin
  for I := 1 to length(ScrTxt) do
    for J := 0 to 7 do
      for K := 0 to 7 do
        if ((mem[FontSegment:FontOfset+ord(ScrTxt[I])*8+J] shl K) and 128) <> 0 then
          mem[$a000:(Ypos+J)*320+(I*8)+Xpos+K] := Color;
end;

{----------------------------------------------------------------------------}

procedure Plotter;

const
  StartCount = 150;

var
  Xst,Yst,I,Dots,OffSet,OnSet,Countdown,TxtX,TxtY : word;
  ColStart,Xstep,Ystep : byte;

begin
  randomize;
  Dots := (20+random(20))*(ColLen+1);
  ColStart := random(NofTab+1);
  Xstep := succ(random(8));
  YStep := succ(random(8)); if Ystep = Xstep then inc(Ystep);
  Xst := 0; Yst := 0; Countdown := 1; TxtX := 0; TxtY := 0;
  repeat
    while (port[$3da] and 8) <> 0 do;
    while (port[$3da] and 8) = 0 do;
    for I := 0 to Dots do begin
      OffSet := (SinTab[(Yst+I*Ystep) mod 1000]*320)+(SinTab[(Xst+I*Xstep) mod 1000])+50;
      OnSet := (SinTab[(Yst+Yspeed+I*Ystep) mod 1000]*320)+(SinTab[(Xst+Xspeed+I*Xstep) mod 1000])+50;
      if mem[$a000:OffSet] <> TxtCol then mem[$a000:OffSet] := 0;
      if mem[$a000:OnSet] <> TxtCol then mem[$a000:OnSet] := ColTab[ColStart,I mod (ColLen+1)];
    end;
    Xst := (Xst+Xspeed) mod 1000;
    Yst := (Yst+Yspeed) mod 1000;
    dec(Countdown); if Countdown = 0 then begin
      WriteText(TxtX,TxtY,0,' press a key ');
      TxtX := 50+random(132); TxtY := 50+random(100);
      WriteText(TxtX,TxtY,TxtCol,' press a key ');
      Countdown := StartCount;
    end;
  until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  GetFont(FontSegment,FontOfset);
  SetGraphics($13);
  Plotter;
  textmode(lastmode);
end.
