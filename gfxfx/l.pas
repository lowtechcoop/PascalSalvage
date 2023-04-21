{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V-,X+}
{$M 32768,0,655360}

program L;
{ Simple (unfinished) list-program, by Bas van Gaalen, Holland, PD
  Needs a personal unit bcrt, tpfast is available... }
uses
  tpfast,bcrt,dos,crt;

type
  LinePtr = ^LineRec;
  LineRec = record
              Line : string;
              Next : LinePtr;
            end;

var
  TextFile  : text;
  FirstLine,
  CurLine,
  LastLine  : LinePtr;
  Search    : string[50];
  NofLines  : word;
  ScrHi     : byte;
  Ascii,
  Clear     : boolean;

{----------------------------------------------------------------------------}

procedure Initialize;

var
  FileName : pathstr;

begin
  if paramcount = 0 then begin
    writeln('Enter filename on commandline');
    halt;
  end;
  FileName := paramstr(1);

  assign(TextFile,FileName);
  {$I-} reset(TextFile); {$I+}
  if ioresult <> 0 then begin
    writeln('File not found...');
    halt;
  end;

  NofLines := 0;
  new(FirstLine);
  FirstLine^.Next := nil;
  CurLine := FirstLine;
  repeat
    readln(TextFile,CurLine^.Line);
    new(CurLine^.Next);
    CurLine := CurLine^.Next;
    inc(NofLines);
  until eof(TextFile);
  CurLine^.Next := nil;
  LastLine := CurLine^.Next;

  ScrHi := hi(windmax);
  cursoroff;

end;

{----------------------------------------------------------------------------}

procedure List;

var
  Key    : char;
  Escape : boolean;
  ScrPos : longint;
  StPos  : integer;
  I      : byte;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure DumpScreen(LineNum : longint; Start : integer);

var
  Tmp : string[80];
  I   : word;
  Len : byte;

begin
  I := 0;
  CurLine := FirstLine;
  while (I <> LineNum) and (CurLine <> LastLine) do begin
    CurLine := CurLine^.Next;
    inc(I);
  end;
  I := 2;
  while (I <= ScrHi) and (CurLine^.Next <> LastLine) do begin
    fillchar(Tmp,sizeof(Tmp),#0);
    if length(CurLine^.Line) < Start then Len := 0
    else if integer(length(CurLine^.Line))-Start > 80 then Len := 80
    else Len := length(CurLine^.Line)-Start;
    move(CurLine^.Line[Start+1],Tmp[1],Len);
    Tmp[0] := #80;
    dspat(Tmp,1,I,lightgray);
    CurLine := CurLine^.Next;
    inc(I);
  end;
  if I < ScrHi then fillscreen(' ',1,I,80,ScrHi-I+1,lightgray);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure Find(var LineNum : longint; var Start : integer; SearchStart : word);

var
  Found  : boolean;
  I      : word;

function StrUp(CnvStr : string) : string;

var
  I : byte;

begin
  for I := 1 to length(CnvStr) do CnvStr[I] := upcase(CnvStr[I]);
  StrUp := CnvStr;
end;

begin
  if SearchStart = 0 then begin
    fillscreen(' ',1,1,80,1,_lightgray);
    gotoxy(2,1);
    textattr := _lightgray;
    write('Search: ');
    cursoron; readln(Search); cursoroff;
  end;
  CurLine := FirstLine; I := 0;
  while (I <> SearchStart) and (CurLine <> LastLine) do begin
    CurLine := CurLine^.Next;
    inc(I);
  end;
  Found := false;
  while (not Found) and (CurLine <> LastLine) do begin
    Found := pos(StrUp(Search),StrUp(CurLine^.Line)) <> 0;
    if not Found then begin
      CurLine := CurLine^.Next;
      inc(I);
    end;
  end;
  if Found then begin
    LineNum := I;
    Start := 0;
  end
  else begin
    fillscreen(' ',1,1,80,1,_lightgray);
    dspat('* Not Found *',2,1,_lightgray+white);
    Clear := false;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

begin
  textattr := 0;
  clrscr;
  ScrPos := 0; StPos := 0;
  Escape := false;
  Clear := true;
  repeat
    DumpScreen(ScrPos,StPos);
    if Clear then begin
      fillscreen(' ',1,1,80,1,_lightgray);
      textattr := _lightgray;
      if Ascii then dspat('ASCII',60,1,_lightgray)
      else dspat('HEX  ',60,1,_lightgray);
      gotoxy(67,1); write(ScrPos+1:3,'/',NofLines+1:3);
      gotoxy(75,1); write(StPos:3);
    end;
    Clear := true;
    Key := readkey;
    if Key = #0 then begin
      Key := readkey;
      case ord(Key) of
         72 : if ScrPos > 0 then dec(ScrPos); { Up }
         80 : if ScrPos < NofLines then inc(ScrPos); { Down }
         73 : if ScrPos-ScrHi >= 0 then dec(ScrPos,ScrHi)
              else ScrPos := 0; { PageUp }
         81 : if ScrPos <= NofLines-ScrHi+1 then inc(ScrPos,ScrHi); { PageDn }
         71 : ScrPos := 0; { Home }
         79 : ScrPos := NofLines-ScrHi+1; { End }
         77 : if StPos+10 <= 210 then inc(StPos,10); { Right }
         75 : if StPos-10 >= 0 then dec(StPos,10); { Left }
        117 : StPos := 210; { CtrlEnd }
        119 : StPos := 0; { CtrlHome }
      end;
    end
    else case upcase(Key) of
      #27 : Escape := true; { Escape }
      'F' : Find(ScrPos,StPos,0); { Find }
      'N' : Find(ScrPos,StPos,ScrPos+1); { Find Next }
    end;
  until Escape;
  textattr := lightgray; clrscr; cursoron;
end;

{----------------------------------------------------------------------------}

begin
  Initialize;
  List;
end.
