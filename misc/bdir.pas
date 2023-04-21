 uses winDos,Crt;

var
  DirInfo: TSearchRec;
  c,t:integer;
  curdir:pchar;
procedure WriteXY(x, y : integer);
begin
  if (x in [1..80]) and (y in [1..25]) then
  begin
    GoToXY(x, y);
    Write(dirinfo.name);
  end ;
  end;

begin               { Change Archive to faArchive }
GetMem(CurDir, 80);
 clrscr;
 gotoxy(1,1);
 GetCurDir(CurDir, 4);
 write('BlairList V.01  : ',curdir);
 FindFirst('*.pas', faArchive, DirInfo);               {Same as DIR *.PAS }
t:=1;
c:=1;
  while DosError = 0 do
  begin
    c:=c+1;
    if c>24 then begin;
    c:=2;
    t:=t+13;
    end;

    Writexy(t,c);
    FindNext(DirInfo);
  end;
end.
