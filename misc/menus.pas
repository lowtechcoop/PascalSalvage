unit menus;
interface
uses crt,ddplus,dos;

var
car1,car2,car3,car4,car5,car6,car7,car8,car9,car10,car11,car12,car13,
car14,car15,car16,car17,car18,car19,car20,
ch:char;{ keypressed char }

finished,
t,
Alias, { Your Characters Alias name }
Real_Name, { Your Real name }
E_name,
Player_Tyres, { Tyres Name }
Player_Engine,
damage,
Player_Chasis,
Player_Gears,
Enemy_Tyres,
Enemy_Car,
Player_Car,
Enemy_Engine,
Enemy_Chasis,
Enemy_Gears:String[20];

Cash_Hand, { Your Cash that you have on hand }
Cash_Bank, { Your Cash in the bank }
Interest_Rate, { % interest to a bank loan }
Princible, { Ammount of Loan }
Player_Tyre_dam,
Player_Engine_dam,
Player_Chasis_dam,
Player_Gears_dam,
Enemy_Tyre_dam,
P_rpms,
e_rpms,
Enemy_Engine_dam,
Enemy_Chasis_dam,
Enemy_Gears_dam,
Player_Tyre_Num,
Player_Engine_Num,
Player_Chasis_Num,
Player_Gears_Num,
Enemy_Tyre_Num,
Enemy_Engine_Num,
Enemy_Chasis_Num,
Enemy_Gears_Num,

exp,
Player_Postion,
Enemy_Postion,
P_speed,
E_speed,
P_Car_Num,
E_acc,
Acc,
P_dis_done,
p_dis_left,
E_dis_done,
E_dis_left,
dis_total,
E_exp,
E_car_num,
Ammount:longint;

procedure drag;
procedure findcar;
procedure winner;
procedure test;
procedure writeit;
procedure nextmove;
procedure checkcar;

Implementation

procedure status;
begin;
if Player_engine_dam = 0 then damage := 'Perfect';
if Player_engine_dam > 0 then damage := 'Ok';
if Player_engine_dam > 30 then damage := 'Running Rough';
if Player_engine_dam > 60 then damage := 'Leaking Bad';
if Player_engine_dam > 90 then damage := 'Don''t look good';
if PLayer_engine_dam > 100 then damage :='Its gone';
if PLayer_engine_dam > 100 then Finished :='true';
writeln('Engine ',damage);
end;

procedure gears;
begin;

if p_rpms > 2000 then Player_engine_dam := player_engine_dam + random(100);
if P_rpms > 2000 then begin;
if player_gears_num = 5 then player_Engine_dam := Player_engine_dam + Random(100);
if player_gears_num < 5 then begin;
if player_gears = 'Auto' then Player_gears_num := Player_gears_num + 1;
if player_gears = 'Auto' then p_rpms := 1000;
end;
end;
if E_rpms > 2000 then Enemy_engine_dam := Enemy_engine_dam + random(100);
if E_rpms > 2000 then begin;
if enemy_gears_num = 5 then enemy_Engine_dam := enemy_engine_dam+Random(100);
if enemy_gears_num < 5 then begin;
if enemy_gears = 'Auto' then enemy_gears_num := enemy_gears_num + 1;
if enemy_gears = 'Auto' then e_rpms := 1000;

end;
end;
end;

procedure checkcar;
begin;
if P_Car_num = 1 then begin;
if p_speed >132 then drag;
end;
if P_Car_num = 2 then begin;
if p_speed >145 then drag;
end;
if P_Car_num = 3 then begin;
if p_speed >156 then drag;
end;
if P_Car_num = 4 then begin;
if p_speed >170 then drag;
end;
if P_Car_num = 5 then begin;
if p_speed >187 then drag;
end;
if P_Car_num = 6 then begin;
if p_speed >196 then drag;
end;

if P_Car_num = 7 then begin;
if p_speed >212 then drag;
end;

if P_Car_num = 8 then begin;
if p_speed > 232 then drag;
end;

begin;
if E_Car_num = 1 then begin;
if E_speed >132 then drag;
end;
if E_Car_num = 2 then begin;
if E_speed >145 then drag;
end;
if E_Car_num = 3 then begin;
if E_speed >156 then drag;
end;
if e_Car_num = 4 then begin;
if e_speed >170 then drag;
end;
if e_Car_num = 5 then begin;
if e_speed >187 then drag;
end;
if e_Car_num = 6 then begin;
if e_speed >196 then drag;
end;
if e_Car_num = 7 then begin;
if e_speed >212 then drag;
end;

if e_Car_num = 8 then begin;
if e_speed > 232 then drag;
end;
end;
end;

procedure nextmove;
begin;
writeln('+ Increase Accelation');
writeln('- Decreases Accelation');
writeln('r Push it to the redline');
writeln('quit');
    readln(ch);
    if ch=('=') then Acc:=Acc+1;
    if ch = ('-') then acc:=acc-1;
    if ch = ('r') then acc:=5;
    if ch =('r') then player_gears_num := player_gears_num + 1;
    if ch = ('q') then finished:= t;
    if Ch = ('s') then status;
end;
procedure test;
begin;
t := 'true';
randomize;
{your car}

Dis_total := 10000; { distance in metres}

P_dis_left := Dis_total ;
E_dis_left := Dis_total ;

Alias := 'Carnage!!';
acc := 2; {20% accelaration }
exp := random(100);
player_engine_num := 4;
player_tyre_num := 5;
player_gears_num := 1;
player_chasis_num := 3;
player_gears:='Auto';
p_car_num := 3;
{other car}
E_name := 'Dirty Dav';
Enemy_gears:='Auto';
E_acc := random(10);
E_exp := random(200);
Enemy_engine_num := Random(Player_engine_num+1);
Enemy_tyre_num := Random(player_Tyre_num+1);
Enemy_gears_num := Random(Player_Gears_num+1);
Enemy_chasis_num := Random(Player_Chasis_num+1);
E_car_num := Random(p_car_num+1);
end;

procedure findcar;
begin;
car1:=' ';
car2:=' ';
car3:=' ';
car4:=' ';
car5:=' ';
car6:=' ';
car7:=' ';
car8:=' ';
car9:=' ';
car10:=' ';
car11:=' ';
car12:=' ';
car13:=' ';
car14:=' ';
car15:=' ';
car16:=' ';
car17:=' ';
car18:=' ';
car19:=' ';
car20:=' ';
if P_dis_left <= dis_total - 9000 then car2 := '*';
if P_dis_left <= dis_total - 8000 then car4 := '*';
if P_dis_left <= dis_total - 7000 then car6 := '*';
if P_dis_left <= dis_total - 6000 then car8 := '*';
if P_dis_left <= dis_total - 5000 then car10 := '*';
if P_dis_left <= dis_total - 4000 then car12 := '*';
if P_dis_left <= dis_total - 3000 then car14 := '*';
if P_dis_left <= dis_total - 2000 then car16 := '*';
if P_dis_left <= dis_total - 1000 then car18 := '*';
if P_dis_left <= dis_total  then car20 := '*';

if E_dis_left <= dis_total - 9000 then car1 := '+';
if E_dis_left <= dis_total - 8000 then car3 := '+';
if E_dis_left <= dis_total - 7000 then car5 := '+';
if E_dis_left <= dis_total - 6000 then car7 := '+';
if E_dis_left <= dis_total - 5000 then car9 := '+';
if E_dis_left <= dis_total - 4000 then car11 := '+';
if E_dis_left <= dis_total - 3000 then car13 := '+';
if E_dis_left <= dis_total - 2000 then car15 := '+';
if E_dis_left <= dis_total - 1000 then car17 := '+';
if E_dis_left <= dis_total then car19 := '+';

end;

procedure winner;
begin;
if PLayer_engine_dam > 110 then begin;
writeln(E_name,' Wins ',alias ,'''s engine blew ');
end;
if enemy_engine_dam  > 110 then begin;
 writeln(alias,' Wins ',E_name ,'''s engine blew ');
end;
if enemy_engine_dam < 110 then begin;
If P_dis_left > E_dis_left then writeln(E_name,' Wins');
end;

if enemy_engine_dam < 110 then begin;
If E_dis_left > P_dis_left then writeln(alias,' Wins');
end;

if player_engine_dam < 110 then begin;
If P_dis_left > E_dis_left then writeln(E_name,' Wins');
end;

if player_engine_dam < 110 then begin;
If E_dis_left > P_dis_left then writeln(alias,' Wins');
end;
end;
procedure Drag;
begin;
repeat
if PLayer_engine_dam > 100 then Finished :='true';
P_Speed := P_car_num * 10  + random (Player_Tyre_num + 10) +
           random (Player_engine_num + 15) + random (Player_Chasis_num + 10)+
           random (player_gears_num + 5) + random(exp) + random (exp) - exp;

E_Speed := E_car_num * 10  + random (Enemy_Tyre_num  + 10) +
           random (Enemy_engine_num + 15) + random (Enemy_Chasis_num + 10)+
           random (Enemy_gears_num + 5 ) + random(exp) + random(exp) - exp;

E_speed := E_speed + E_acc+E_acc+E_acc+ random(E_Acc)* Enemy_gears_num;
e_speed := e_speed * 2 - Enemy_engine_dam;
p_speed := p_speed + acc + acc+ acc+ random(Acc)* player_gears_num;
P_speed := p_speed * 2 - Player_engine_dam;
if PLayer_engine_dam > 110 then Finished :='true';
if enemy_engine_dam  > 110 then Finished :='true';
gears;
checkcar;
until P_speed > 30;
P_dis_left := P_dis_left - P_speed * 10;
P_dis_done := p_dis_left - P_dis_left;
E_dis_left := E_dis_left - E_speed * 10;
E_dis_done := E_dis_left - E_dis_left;
p_rpms := p_rpms + 1000;
E_rpms := E_rpms + 1000;
findcar;

end;

procedure writeit;
begin;
Writeln(alias,' is in ',Player_gears_num,' Gear at ',p_rpms * 2,' Rpms');
Writeln(E_name,' is in ',Enemy_gears_num,' Gear at ',E_rpms * 2,' Rpms');
writeln (e_name, ' ',E_speed,' Km/h');
Writeln (Alias,' ',P_speed,' Km/h');
writeln;
textcolor(2);
write('))');
textcolor(15);
write('|');
textcolor(14);
write('=======');
textcolor(15);
write('|');
textcolor(2);
write('()');
writeln;
write('((');
textcolor(15);
write('| ');
textcolor(4);
write(car1);
textcolor(15);
write(' | ');
textcolor(1);
write(car2);
textcolor(15);
write(' |');
textcolor(2);
write(')(');
writeln;
write('((');
textcolor(15);
write('| ');
textcolor(4);
write(car3);
textcolor(15);
write(' | ');
textcolor(1);
write(car4);
textcolor(15);
write(' |');
textcolor(2);
write(')(');
writeln;
write('((');
textcolor(15);
write('| ');
textcolor(4);
write(car5);
textcolor(15);
write(' | ');
textcolor(1);
write(car6);
textcolor(15);
write(' |');
textcolor(2);
write(')(');
writeln;
write('((');
textcolor(15);
write('| ');
textcolor(4);
write(car7);
textcolor(15);
write(' | ');
textcolor(1);
write(car8);
textcolor(15);
write(' |');
textcolor(2);
write(')(');
writeln;
write('((');
textcolor(15);
write('| ');
textcolor(4);
write(car9);
textcolor(15);
write(' | ');
textcolor(1);
write(car10);
textcolor(15);
write(' |');
textcolor(2);
write(')(');
writeln;
write('((');
textcolor(15);
write('| ');
textcolor(4);
write(car11);
textcolor(15);
write(' | ');
textcolor(1);
write(car12);
textcolor(15);
write(' |');
textcolor(2);
write(')(');
writeln;
write('((');
textcolor(15);
write('| ');
textcolor(4);
write(car13);
textcolor(15);
write(' | ');
textcolor(1);
write(car14);
textcolor(15);
write(' |');
textcolor(2);
write(')(');
writeln;
write('((');
textcolor(15);
write('| ');
textcolor(4);
write(car15);
textcolor(15);
write(' | ');
textcolor(1);
write(car16);
textcolor(15);
write(' |');
textcolor(2);
write(')(');
writeln;
write('((');
textcolor(15);
write('| ');
textcolor(4);
write(car17);
textcolor(15);
write(' | ');
textcolor(1);
write(car18);
textcolor(15);
write(' |');
textcolor(2);
write(')(');
writeln;
write('((');
textcolor(15);
write('| ');
textcolor(4);
write(car19);
textcolor(15);
write(' | ');
textcolor(1);
write(car20);
textcolor(15);
write(' |');
textcolor(2);
write(')(');
writeln;
textcolor(2);
write('))');
textcolor(15);
write('|');
textcolor(14);
write('=======');
textcolor(15);
write('|');
textcolor(2);
write('()');
writeln;

if E_dis_left < 0  then finished := t;
if P_dis_left < 0 then finished := t;
end;
end.