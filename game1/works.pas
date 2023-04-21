  program readrecords;
{ Simple, IT"S BLODDY SIMPLE}
uses crt,miss,ddplus;
var
real_name:string;
alias:string;
choice:char;
gender:string;
account:integer;
type player_info = record
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
var
  FromF, ToF: file;
  NumRead, NumWritten: Word;
  Buf: array[1..200] of Player_info;
  x:integer;

procedure save;
begin
if gender='m' then buf[x].sex:= 0;
if gender='f' then buf[x].sex:= 1;
if gender='M' then buf[x].sex:= 0;
if gender='F' then buf[x].sex:= 1;

clrscr;
Assign(ToF, 'chris.dat'); { Open output file }
Rewrite(ToF, 1);  { Record size = 1 }

{repeat                  }

    BlockWrite(ToF, Buf, Sizeof(Buf), NumWritten);

 {until (NumRead = 0) or (NumWritten <> NumRead);
{ Close(FromF);  }
close(ToF);
end;
procedure status;
begin;
alias:=buf[account].names;
test(alias);
textcolor(3);
writeln;
writeln(buf[account].weapon_num);
writeln(buf[account].arm_num );
write(buf[account].hit_points);
write('/',buf[account].hit_max);
writeln('');
writeln(buf[account].charm);
writeln(buf[account].weapon);
writeln(buf[account].arm);
writeln(buf[account].exp);
writeln(buf[account].strength);
writeln(buf[account].def);
if buf[account].sex = 1 then gender:='Female';
if buf[account].sex=0 then gender:='Male';
writeln(gender);
end;
procedure news;

  begin;
  clrscr;
            screenlength:=20;
            colour_file('wings.nws');
           delay(1000);
           status;

  end;



procedure new_user;
begin;
writeln('I Haven''t Seen Your Face Around Here Do You Want To enter[y/n]');
readln(choice);
if choice= 'y' then begin
buf[x].real_names:=real_name;
writeln('alias');
readln(buf[x].names);
writeln('gender');
readln(gender);
buf[x].weapon_num := 1;
buf[x].arm_num :=1;
buf[x].hit_points :=20;
buf[x].hit_max :=20;
buf[x].charm :=1;
buf[x].weapon:='Nuke';
buf[x].arm:='Vest';
buf[x].exp:=0;
buf[x].strength:=0;
buf[x].def:=0;
save;
end;
end;


procedure load;
begin
  Assign(FromF, 'Chris.dat'); { Open input file }
  Reset(FromF, 1);  { Record size = 1 }

  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
  until (NumRead = 0) or (NumWritten <> NumRead);

Close(FromF);

InitDoorDriver('GAME.CTL');
real_name := user_first_name+user_last_name;
repeat
x:=x+1;
if buf[x].real_names=real_name then account:=x;
until buf[x].real_names='';
if account =0 then new_user;
alias := buf[account].names;
write('welcome ');
test(alias);
delay(5000);
news;
end;

begin;
clrscr;
textColor(15);
load;
end.
