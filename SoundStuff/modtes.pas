{ --------------------------------------------------------------------------}
{   TEST PROGRAM  .. cut }

Uses Crt,Mods;
 var ch : char;
begin
 Device:=dvsblaster;
 MixSpeed:=15909; {10000;}
 setvolume(255);
 WriteLn(PlayMod('lotus.MOD'));
 repeat
  ch:=ReadKey; if ch=#0 then ch:=ReadKey;
  Case ch of
   #43 :  begin Inc(Volume); SetVolume(Volume); end; {���� ����}
   #45 :  begin Dec(Volume); SetVolume(Volume); end; {���� �����}
   #42 :  begin Volume:=255; SetVolume(Volume); end; {���� ������窠 MAX}
  end;
 until ch in [#27];
 StopMod;
end.
