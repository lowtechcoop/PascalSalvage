
program midiplayer_version2;
{ Improved version of random-midi-player, by Bas van Gaalen, Holland, PD }
{ Play with this if you have midiplay from ultrasound or whatever... }
uses
  memory,crt,dos;

const
  maxnames=99;

type
  str12=string[12];
  namesarray=array[0..maxnames] of str12;
  numsarray=array[0..maxnames] of byte;

var
  names:namesarray;
  nums:numsarray;
  dirinfo:searchrec;
  time:longint;
  hr,mn,sc,hs:word;
  i,max,cur:byte;

function lz(w:word):str12;
var s:str12;
begin
  str(w:0,s); while length(s)<2 do s:='0'+s;
  lz:=s;
end;

function convtotime(tm:longint):str12;
var tmpstr1:str12;
begin
  tmpstr1:=lz(tm div 3600)+':';
  tm:=tm-3600*(tm div 3600);
  tmpstr1:=tmpstr1+lz(tm div 60)+':';
  tm:=tm-60*(tm div 60);
  tmpstr1:=tmpstr1+lz(tm);
  convtotime:=tmpstr1;
end;

begin
  checkbreak:=true;
  randomize;
  i:=0;
  findfirst('*.MID',archive,dirinfo);
  while (doserror=0) and (i<=maxnames) do begin
    names[i]:=dirinfo.name;
    inc(i);
    findnext(dirinfo);
  end;
  if i=0 then begin
    writeln('No midi-files found in current directory...');
    halt;
  end;
  max:=i;
  fillchar(nums,sizeof(nums),0);
  for i:=0 to max-1 do begin
    cur:=random(max);
    while nums[cur]<>0 do cur:=(1+cur) mod max;
    nums[cur]:=i+1;
  end;
  i:=0;
  repeat
    cur:=nums[i]-1;
    writeln('Loading: (',i+1,'/',max,') ',names[cur],' (',cur+1,')');
    gettime(hr,mn,sc,hs);
    time:=sc+60*mn+3600*hr;
    setmemtop(heapptr);
    swapvectors;
    exec(getenv('comspec'),'/c C:\ULTRASND\PLAYMIDI.EXE '+names[cur]);
    swapvectors;
    setmemtop(heapend);
    gettime(hr,mn,sc,hs);
    time:=(sc+60*mn+3600*hr)-time;
    writeln('Played: ',names[cur],' (',cur+1,')  Playing time: ',convtotime(time));
    inc(i);
  until (i=max) or keypressed;
end.
