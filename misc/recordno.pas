program record_attempt1;

uses crt,dos;

type bfile=record
         name:string[10];
         age:byte;
     end;
     brec=array[1..10] of bfile;
     pbrec=^brec;

var gex:pbrec;

    temp1:file;
    nme:string[10];
    ag:byte;
  FromF, ToF: file;
  NumRead, NumWritten: Word;
  Buf: array[1..2048] of Char;
begin;
assign(ToF, 'Blair.rec'); { Open output file }
Rewrite(ToF, 21);  { Record size = 1 }
repeat
write('What is your name?');
readln(nme);
write('how old are you?');
readln(ag);
gex[1]:=bfile(nme);
blockwrite(tof,gex