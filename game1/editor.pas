program editor;
uses crt,miss,ddplus;
var
real_name:string;
ch,
choice:char;
gender:string;
account:integer;
type
player_info = record
   names: string[20]; {player handle in the game}
   real_names: string[50] {real name/or handle from BBS} ;
   hit_points  {player hit points}
  ,bad  {don't know - might not be used at all}
  ,rate: integer; {again, couldn't find this one in the source}
  hit_max: integer; {hit_point max}
  weapon_num: integer; {weapon number}
  weapon: string[20]; {name of weapon}
  seen_master: integer; {equals 5 if seen master, else 0}
  fights_left: integer; {forest fights left}
  human_left: integer; {human fights left}
  gold: longint; {gold in hand}
  bank: longint; {gold in bank}
  def: integer;  {total defense points }
  strength: integer; {total strength}
  charm: integer; {good looking meter}
  seen_dragon: integer; {seen dragon?  5 if yes else 0}
  seen_violet: integer; {seen violet?  5 if yes else 0}
  level: integer; {level of player}
  time: word; {day # that player last played on}
  arm: string[20]; {armour name}
  arm_num: integer; {armour number}
  dead: shortint; {player dead?  5 if yes else 0}
  inn: shortint; {player sleeping at inn?  5 if yes else 0}
  gem: integer; {# of gems on hand}
  exp: longint; {experience}
  sex: shortint; {gender, 5 if female else 0}
  seen_bard: shortint; {seen bard?  5 if yes else 0}
  last_alive_time: integer; {day # player was last reincarnated on}
  Lays: integer; {players lays stat}
  Why: integer; {not used yet}
  on_now: boolean; {is player on?}
  m_time: integer; {day on_now stat was last used}
  time_on: string[5]; {time player logged on in Hour:Minutes format}
  class: shortint; {class, should be 1, 2 or 3}
  extra: integer;      {*NEW*  If 1, player has a horse}
  love: string[25]; {not used - may be used for inter-player marrages later}
  married: integer; {who player is married to, should be -1 if not married}
  kids: integer; {# of kids}
  king: integer; {# of times player has won game}
  skillw: shortint; {number of Death Knight skill points}
  skillm: shortint; {number of Mystical Skills points}
  skillt: shortint; {number of Thieving Skills points}

  levelw: shortint; {number of Death Knight skill uses left today}
  levelm: shortint; {number of Mystical skill uses left today}
  levelt: shortint; {number of Thieving skill uses left today}

  inn_random: boolean; {not used yet}
  married_to: integer; {same as Married, I think - don't know why it's here}
  v1: longint;
  v2: integer; {# of player kills}
  v3: integer; {if 5, 'wierd' event in forest will happen}
  v4: boolean; {has player done 'special' for that day?}
  v5: shortint; {has player flirted with another player that day?  if so, 5}
  new_stat1: shortint;
  new_stat2: shortint;  {these 3 are unused right now}
  new_stat3: shortint;  {Warning: Joseph's NPCLORD screws with all three}
end;
monst = record
           name: string[60];
           strength: longint;
           gold: longint;
           weapon: string[60];
           exp_points: longint;
           hit_points: longint;
           death: string[100]; {shown when monster is killed by power move}
 end;
var
  FromF, ToF: file;
  NumRead, NumWritten: Word;
  Player: array[1..100] of Player_info;
  Monster:array[1..100] of monst;
  x,oldx:integer;

procedure loadp;
begin
  Assign(FromF, 'Chris.dat'); { Open input file }
  Reset(FromF, 1);  { Record size = 1 }

  repeat
    BlockRead(FromF, Player, SizeOf(Player), NumRead);
  until (NumRead = 0) or (NumWritten <> NumRead);

Close(FromF);

end;
procedure loadm;
begin
  Assign(FromF, 'lenemy.dat'); { Open input file }
  Reset(FromF, 1);  { Record size = 1 }

  repeat
    BlockRead(FromF, Monster, SizeOf(Monster), NumRead);
  until (NumRead = 0) or (NumWritten <> NumRead);

Close(FromF);

end;

procedure savep;
begin

clrscr;
Assign(ToF, 'lenemy.dat'); { Open output file }
Rewrite(ToF, 1);  { Record size = 1 }

{repeat                  }

    BlockWrite(ToF, monster, Sizeof(Player), NumWritten);

 {until (NumRead = 0) or (NumWritten <> NumRead);
{ Close(FromF);  }
close(ToF);
end;

procedure savem;
begin

clrscr;
Assign(ToF, 'player.dat'); { Open output file }
Rewrite(ToF, 1);  { Record size = 1 }

{repeat                  }

    BlockWrite(ToF, player, Sizeof(Player), NumWritten);

 {until (NumRead = 0) or (NumWritten <> NumRead);
{ Close(FromF);  }
close(ToF);
end;

procedure monstedit;
var oldx:integer;
begin;
loadm;
clrscr;
textcolor(7);
x:=1;
oldx:=x+1;
repeat

if oldx<>x then
begin;
clrscr;
textcolor(7);
writeln(' Enemy Editor v1.2');
writeln(' account num :',x);
write('(a) Name :');
test(monster[x].name);
textcolor(7);
writeln('(b) Strength :',monster[x].strength);
writeln('(c) Gold :',monster[x].gold);
writeln('(d) Weapon :',monster[x].weapon);
writeln('(e) Experience :',monster[x].exp_points);
writeln('(f) Hit Points :',monster[x].hit_points);
writeln('(g) Death Note :');
test(monster[x].death);
end;

ch:=readkey;
oldx:=x;
if ch=']' then x:=x+1;
if ch='[' then x:=x-1;
if ch='a' then begin
writeln;
write('Monster Name:');
readln(monster[x].name);
oldx:=x+1;
end;
if ch='b' then begin
writeln;
write('Monster Strength:');
readln(monster[x].strength);
oldx:=x+1;
end;
if ch='c' then begin
writeln;
write('Monster Gold:');
readln(monster[x].gold);
oldx:=x+1;
end;
if ch='d' then begin
writeln;
write('Monster Weapon:');
readln(monster[x].weapon);
oldx:=x+1;
end;
if ch='e' then begin
writeln;
write('Monster Experience:');
readln(monster[x].exp_points);
oldx:=x+1;
end;
if ch='f' then begin
writeln;
write('Monster Hit Points:');
readln(monster[x].hit_points);
oldx:=x+1;
end;
if ch='g' then begin
writeln;
writeln('Monster Death Note:');
readln(monster[x].death);
oldx:=x+1;
end;
if ch='s' then begin;
savem;
oldx:=x+1;
end;
if x=0 then x:=100;
if x=101 then x:=1;
until ch='q';

end;
procedure playedit;
var oldx:integer;
begin;
loadP;
clrscr;
textcolor(7);
x:=1;
oldx:=x+1;
repeat

if oldx<>x then
begin;
clrscr;
textcolor(7);
writeln(' Player Editor v1.2');
writeln(' account num :',x);
writeln;
write('(a) Name :');
test(player[x].names);
textcolor(7);
writeln('(b) Real Name :',Player[x].Real_names);
writeln('(c) Gold :',Player[x].gold);
writeln('(d) Weapon :',PLayer[x].weapon);
writeln('(e) Experience :',PLayer[x].exp);
writeln('(f) Hit Points :',PLayer[x].hit_points);
writeln('(g) Hit Max :' ,Player[x].hit_max);
writeln('(h) Fights :' , Player[x].fights_left);
writeln('(i) Gold in bank :',player[x].bank);
writeln('(j) Strength :' , Player[x].Strength);
writeln('(k) Defence :',player[x].Def);
writeln('(l) Charm : ',player[x].charm);
writeln('(m) Player Fights : ',player[x].human_left);
writeln('(n) Level : ',player[x].level);
writeln('(o) Armour : ',player[x].arm);
writeln('(p) Armour number : ',player[x].arm_num);
writeln('(r) Weapon number : ',player[x].weapon_num);
write('(t) Player : ');
if player[x].dead = 5 then test('`4DEAD') else test('`2ALIVE');
textcolor(7);
write('(u) Sleeping Inn : ');
if player[x].inn = 5 then write('Yes') else write('No');
writeln;
writeln('(v) gems : ',player[x].gem);
write('(w) sex : ');
if player[x].sex = 1 then write ('Female') else write('Male');
writeln;
end;

ch:=readkey;
oldx:=x;
if ch=']' then x:=x+1;
if ch='[' then x:=x-1;
if ch='a' then begin
writeln;
write('Player Name:');
readln(PLayer[x].names);
oldx:=x+1;
end;
if ch='b' then begin
writeln;
write('Player Real name:');
readln(PLayer[x].Real_names);
oldx:=x+1;
end;
if ch='c' then begin
writeln;
write('Player Gold:');
readln(Player[x].gold);
oldx:=x+1;
end;
if ch='d' then begin
writeln;
write('Player Weapon:');
readln(Player[x].weapon);
oldx:=x+1;
end;
if ch='e' then begin
writeln;
write('Player Experience:');
readln(Player[x].exp);
oldx:=x+1;
end;
if ch='f' then begin
writeln;
write('Player Hit Points:');
readln(PLayer[x].hit_points);
oldx:=x+1;
end;
if ch='g' then begin
writeln;
write('Player Hit Max :');
readln(PLayer[x].hit_max);
oldx:=x+1;
end;
if ch='h' then begin
writeln;
write('Fights:');
readln(Player[x].Fights_left);
oldx:=x+1;
end;
if ch='i' then begin
writeln;
write('Gold in bank :');
readln(Player[x].bank);
oldx:=x+1;
end;
if ch='j' then begin
writeln;
write('Player Strength :');
readln(Player[x].Strength);
oldx:=x+1;
end;

if ch='k' then begin
writeln;
write('Player Defence :');
readln(Player[x].def);
oldx:=x+1;
end;

if ch='l' then begin
writeln;
write('Charm :');
readln(PLayer[x].Charm);
oldx:=x+1;
end;

if ch='m' then begin
writeln;
write('Player Fights :');
readln(PLayer[x].Human_left);
oldx:=x+1;
end;
if ch='n' then begin
writeln;
write('Level :');
readln(PLayer[x].level);
oldx:=x+1;
end;
if ch='o' then begin
writeln;
write('Armour :');
readln(PLayer[x].arm);
oldx:=x+1;
end;
if ch='p' then begin
writeln;
write('Armour number :');
readln(PLayer[x].arm_num);
oldx:=x+1;
end;
if ch='r' then begin
writeln;
write('Weapon number :');
readln(PLayer[x].weapon_num);
oldx:=x+1;
end;
if ch='t' then begin;
if player[x].dead = 0 then player[x].dead := 5 else player[x].dead := 0;
oldx:=x+1;
end;
if ch='u' then begin;
if player[x].inn = 0 then player[x].inn := 5 else player[x].inn := 0;
oldx:=x+1;
end;
if ch='v' then begin;
writeln;
write('Gems : ');
readln(player[x].gem);
oldx:=x+1;
end;
if ch='w' then begin;
if player[x].sex = 0 then player[x].sex := 1 else player[x].sex := 0;
oldx:=x+1;
end;

if ch='s' then begin;
savep;
oldx:=x+1;
end;
if x=0 then x:=100;
if x=101 then x:=1;
until ch='q';

end;

begin;

InitDoorDriver('GAME.CTL');
textcolor(7);
oldx:=2;
x:=1;

repeat
textcolor(7);
if oldx<>x then begin
clrscr;
Writeln('Setup and Editor v1.2');
Writeln;
writeln('(1) Player Editor');
writeln('(2) Enemy Editor');
writeln('(q) Quit');
writeln;
Write('Your Selection :');
end;
ch:=readkey;
if ch='1' then begin;
playedit;
oldx:=x+1;
ch:=' ';
end;

if ch='2' then begin;
monstedit;
oldx:=x+1;
ch:=' ';
end;
until ch='q';
end.
