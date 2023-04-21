  program readrecords;
{ Simple, IT"S BLODDY SIMPLE}
uses crt,chris;
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
begin
clrscr;
  Assign(FromF, ParamStr(1)); { Open input file }
  Reset(FromF, 1);  { Record size = 1 }

  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
  until (NumRead = 0) or (NumWritten <> NumRead);

 Close(FromF);
repeat
x:=x+1;
writeln(buf[x].real_names,test(buf[x].names));
until x=1

end.