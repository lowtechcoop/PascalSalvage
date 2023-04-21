Program Demo7;

{ SPX library - Sound demo 7  Copyright 1993 Scott D. Ramsay  }

Uses Crt,Dos,SPX_SND,SPX_KEY,SPX_FNC,LimEms;

type
  sndmode = (CHKsnd,PCsnd,LPT1snd,SBsnd);

const
  path    = '';
  uems    : boolean = false;
  sound   : array[0..2] of Psound = (nil,nil,nil);
  sndport : word = $42;         { default device = PC speaker }
  _sb     : boolean = false;
  defsnd  : sndmode = CHKsnd;

procedure setup;
var
  d : integer;
begin
  setrate(8192);  { Sample rate for files is 8192 }
  for d := 0 to 2 do
    if uems
      then sound[d]  := new(PEMSsound,init(path+'sound'+st(d+1)+'.sfx',sndport,_sb))
      else sound[d]  := new(Psound,init(path+'sound'+st(d+1)+'.sfx',sndport,_sb));
end;


procedure showit;
begin
  writeln('Command line:');
  writeln(' DEMO7  [PC][SB][LPT1]');
  writeln('     PC    - use pc speaker');
  writeln('     SB    - use sound blaster or compatible');
  writeln('     LPT1  - use DAC device on LPT1');
  writeln('Keys:');
  writeln(' ESC          - quit demo');
  writeln(' 1..3         - play sounds');
  writeln;
  write('Press any key.');
  clearbuffer;
  repeat until anykey;
end;


function getvst(s:string;b:byte):string;
var
  v : string;
begin
  inc(b); v := '';
  while (b<=length(s)) and (s[b]<>#32) do
    begin
      v := v+s[b];
      inc(b);
    end;
  getvst := v;
end;


{ convert a hex number to a decimal }
function hex2dec(what:string) : integer;
var
  i,rslt : integer;
begin
  rslt := 0;
  for i := 1 to length(what) do
    begin
      rslt := rslt shl 4;
      if what[i]<'A'
        then rslt := rslt+(ord(what[i])-$30)
        else rslt := rslt+(ord(what[i])-55);
    end;
  hex2dec := rslt;
end;


function blastercheck:boolean;
var
  s : string;
begin
  s := ups(getenv('BLASTER'));
  if pos('A',s)<>0
    then
      begin
        sndport := hex2dec(getvst(s,pos('A',s)));
        _sb := SBReset(sndport);
        if not _sb
          then
            begin
              sndport := SBfindBase; _sb := (sndport<>0);
              if not _sb
                then sndport := $42;
            end;
      end;
  blastercheck := _sb;
end;


procedure checkparms;
var
  tp,pa : word;
  s     : string;
  d     : integer;
begin
  writeln('SPX library - Sound demo 7');
  writeln('Copyright 1993 Scott D. Ramsay');
  writeln;
  s := '';
  for d := 1 to paramcount do
    s := s+ups(paramstr(1));
  if pos('LPT1',s)<>0
    then defsnd := LPT1snd
    else
  if pos('SB',s)<>0
    then defsnd := SBsnd
    else
  if pos('PC',s)<>0
    then defsnd := PCsnd;
  if not EMSinstalled or not emsSTATUS
    then uems := false
    else
      begin
        EMSpages(tp,pa);
        if pa>=5
          then
            begin
              uems := true;
              writeln('Expanded memory detected and used')
            end
          else writeln('Expanded memory detected, but not enough available');
      end;
  case defsnd of
    CHKsnd,
    SBsnd   : blastercheck;
    LPT1snd : sndport := $378;
  end;
  if _sb
    then writeln('Sound card detected')
    else
      if defsnd<>LPT1snd
        then writeln('Using PC speaker')
        else writeln('Using DAC on LPT1');
  writeln;
end;


procedure animate;
begin
  clrscr;
  writeln('ESC - quit    1..3 - sounds ');
  repeat
    if vl(ch) in [1..3]
      then sound[vl(ch)-1]^.play(true);
    delay(100);  { kill some cycles }
  until esc;
end;


begin
  checkparms;
  showit;
  setup;
  animate;
end.