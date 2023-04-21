Program Blair ;{ Generates Lotto Numbers...
                 Really Fast, Checked and all
                 Working on Bubblesort Routine
                 Right now.. now finished... works! }

uses CRT;
var lottoa:byte;
    lottob:Byte;
    lottoc:Byte;
    lottod:Byte;
    lottoe:Byte;
    lottof:Byte;



    strikea:byte;
    strikeb:byte;
    strikec:byte;
    striked:byte;

    count:Integer;
    countx:Integer;
    curpos:Integer;

    lottoarray: array[1..6] of byte;
    temp: integer;
    i, j: integer;



procedure WriteXY(x, y : integer; s : string);
begin
  if (x in [1..80]) and (y in [1..25]) then
  begin
    GoToXY(x, y);
    Write(s);
  end ;
  end;

procedure WriteS(x, y, l : integer);
begin
  if (x in [1..80]) and (y in [1..25]) then
  begin
    GoToXY(x, y);
    Write(l);

  end
 end;

procedure Writetoarray;

 begin
    lottoarray[1] := lottoa;   { write variables into array }
    lottoarray[2] := lottob;
    lottoarray[3] := lottoc;
    lottoarray[4] := lottod;
    lottoarray[5] := lottoe;
    lottoarray[6] := lottof;

end;


procedure SortArray;
begin
  for i:= 1 to 6 do
    for j:= i+1 to 6 do
    if lottoarray[i] > lottoarray[j] then
      begin
        temp:= lottoarray[i];
        lottoarray[i]:= lottoarray[j];
        lottoarray[j]:=temp;
      end;


    lottoa:=lottoarray[1] ; { write lotto numbers from }
    lottob:=lottoarray[2] ; { array into variables }
    lottoc:=lottoarray[3] ;
    lottod:=lottoarray[4] ;
    lottoe:=lottoarray[5] ;
    lottof:=lottoarray[6] ;

end;

procedure CheckNumbers;


begin
     {check lotto number a}
     if lottoa=lottob then lottoa:=random(40)+1;
     if lottoa=lottoc then lottoa:=random(40)+1;
     if lottoa=lottod then lottoa:=random(40)+1;
     if lottoa=lottoe then lottoa:=random(40)+1;
     if lottoa=lottof then lottoa:=random(40)+1;
     {check lotto number b}
     if lottob=lottoc then lottob:=random(40)+1;
     if lottob=lottod then lottob:=random(40)+1;
     if lottob=lottoe then lottob:=random(40)+1;
     if lottob=lottof then lottob:=random(40)+1;
     {check lotto number c}
     if lottoc=lottod then lottoc:=random(40)+1;
     if lottoc=lottoe then lottoc:=random(40)+1;
     if lottoc=lottof then lottoc:=random(40)+1;
     {check lotto number d}
     if lottod=lottoe then lottod:=random(40)+1;
     if lottod=lottof then lottod:=random(40)+1;
     {check lotto number e}
     if lottoe=lottof then lottoe:=random(40)+1;

     {Check strike numbers}
     {check strike number a}
     if strikea=strikeb then strikea:=random(40)+1;
     if strikea=strikec then strikea:=random(40)+1;
     if strikea=striked then strikea:=random(40)+1;
     {check strike number b}
     if strikeb=strikec then strikeb:=random(40)+1;
     if strikeb=striked then strikeb:=random(40)+1;
     {check strike number c}
     if strikec=striked then strikec:=random(40)+1;


 end;

Procedure Gennumbers;
begin;
         lottoa:=random(40)+1;  {Create Lotto Numbers}
         lottob:=random(40)+1;
         lottoc:=random(40)+1;
         lottod:=random(40)+1;
         lottoe:=random(40)+1;
         lottof:=random(40)+1;

         strikea:=random(40)+1; {Create Strike Numbers}
         strikeb:=random(40)+1;
         strikec:=random(40)+1;
         striked:=random(40)+1;

end;
Procedure Writenumbers;

begin;
      WriteS(1,countx,lottoa) ;
      WriteS(5,countx,lottob);
      WriteS(9,countx,lottoc);
      WriteS(13,countx,lottod);
      WriteS(17,countx,lottoe);
      WriteS(21,countx,lottof);


end;

Procedure WriteStrike;
begin
if countx=(3) then
begin
     WriteS(28,countx,strikea) ;
     WriteS(32,countx,Strikeb) ;
     writes(36,countx,strikec) ;
     writes(40,countx,striked) ;
end  ;
if countx=(4) then
begin
     WriteS(28,countx,strikea) ;
     WriteS(32,countx,Strikeb) ;
     writes(36,countx,strikec) ;
     writes(40,countx,striked) ;
end

end;

Begin

    randomize;
    clrscr;
     writeln ('     Lotto Numbers         Strike Numbers ')     ;
     writeln;
     count:=0;
     countx:=2;

     repeat;
         count:=(count +1);
         countx:=(countx +1);

         GenNumbers;

         CheckNumbers;
         Writetoarray;
         SortArray;
         Writestrike;
         Writenumbers;
         if count=(1) then writeln(' ');

      count:=(0);
     until countx=(12);
     textcolor(6);
     Writexy(30,8,'/-------------------------\');
     Writexy(30,9,'| Lotto Numbers Generator |');
     Writexy(30,10,'| Version 1.9             |');
     writexy(30,11,'| Blair Harrison 1997     |');
     writexy(30,12,'\-------------------------/');


repeat;

until keypressed=true;

writeln (' ');

end.