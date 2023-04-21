
program Oldy;
{ the same as scroll.pas, but smaller, by Bas van Gaalen, Holland, PD }
uses
  crt, tpfast;

procedure Scroll;

const
  UpperLine  : string = ('   млллм ллллм млллл ллллм ллллл ллллл'+
                         ' млллм лл лл лл ллллл лл лл лл    л'+
                         'лм млл ллллм млллм ллллм млллм лллл'+
                         'м млллл ллллм лл лл лл лл лл   лл л'+
                         'л лл лл лл ллллл млллм ллл  ллллм л'+
                         'лллм лл лл ллллл млллл ллллл млллм '+
                         'млллм        млп млпмлп лл млллм');

  MiddleLine : string = ('   ллмлл ллмлп лл    лл лл ллмм  ллмм '+
                         ' лл мм ллмлл лл    лл ллмлп лл    л'+
                         'лплплл лл лл лл лл ллмлп лл лл ллмл'+
                         'п плмм     лл лл лл лл лл ллмлмлл п'+
                         'лмлп плмлл  ммлп лл лл  лл   ммлп  '+
                         'ммлп ллмлл ллмм  ллмм     лл плмлп '+
                         'плмлл                   лл  ммлп');

  LowerLine  : string = ('   лл лл ллмлл плммм ллмлп ллммм лл   '+
                         ' плмлп лл лл лл мммлп лл лл ллммм л'+
                         'л   лл лл лл плмлп лл    плмлл лл лл'+
                         ' мммлп    лл плмлп  плп  ллп плл лл'+
                         ' лл мммлп ллммм плмлп мллм ллммм мм'+
                         'млп    лл мммлп плмлп    лл плмлп м'+
                         'ммлп лл млп            мм  мм');

  PosTable : array[1..90] of byte = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

                     1,238,231,0,0,0,0,227,0,0,0,0,223,0,220,0,161,167,172,
                   { 32 !   "           '           ,     .     0   1   2 }

                     178,184,190,196,202,208,214,0,0,0,0,0,241,0,
                   {  3   4   5   6   7   8   9             ?   }

                     4,10,16,22,28,34,40,46,52,55,61,67,73,81,87,93,99,105,
                   { A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R }

                     111,117,123,129,135,143,149,155);
                   {  S   T   U   V   W   X   Y   Z }

  LenTable : array[1..90] of byte = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

                     3,3,7,0,0,0,0,4,0,0,0,0,4,0,3,0,6,5,6,
                   {[ ]! "         '         ,   .   0 1 2 }

                     6,6,6,6,6,6,6,0,0,0,0,0,6,0,
                   { 3 4 5 6 7 8 9           ?   }

                     6,6,6,6,6,6,6,6,3,6,6,6,8,6,6,6,6,6,
                   { A B C D E F G H I J K L M N O P Q R }

                     6,6,6,6,8,6,6,6);
                   { S T U V W X Y Z }

  Texts    : string = ('   brain made productions proudly presents...   caller maintenance v1.3...   '+
                       'hi to the beta and supportteam, sven van heel, mischa van schaijk and other '+
                       'people who know me...   now, press a key to enter the world of users...    ');

var
  I,
  PosCounter : word;
  CurChar,
  CharCounter,
  ScrHigh,
  Pos,
  Len        : byte;

begin
  cursoroff;
  ScrHigh := (hi(windmax)+1) div 2;
  fillscreen(' ',1,ScrHigh-2,80,5,black);
  repeat
    PosCounter := 1;
    repeat
      CurChar := ord(Texts[PosCounter]);
      if CurChar > 90 then CurChar := CurChar-32;
      Pos := PosTable[CurChar];
      Len := LenTable[CurChar];
      CharCounter := Len;
      repeat
        while (port[$3da] and 8) <> 0 do;
        while (port[$3da] and 8) = 0 do;
        scrollx('l',1,ScrHigh-1,80,3,1,white);
        dspat(UpperLine[Pos+CharCounter-Len],80,ScrHigh-1,lightcyan);
        dspat(MiddleLine[Pos+CharCounter-Len],80,ScrHigh,lightcyan);
        dspat(LowerLine[Pos+CharCounter-Len],80,ScrHigh+1,lightcyan);
        dec(Len);
      until Len = 0;
      inc(PosCounter);
    until (PosCounter = length(Texts)) or keypressed;
  until keypressed;
  cursoron;
end;

begin
  Scroll;
end.
