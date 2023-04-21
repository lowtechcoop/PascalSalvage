Program Tileing;
Uses Crt;

Type
 Buffer = Array[1..64000] Of Byte;
 BufferPtr = ^Buffer;
 TileGraphic = Array[1..16,1..16] Of Byte;
 MapArray = Array[1..128,1..80] Of Byte;
 MapWalk = Array[1..128,1..80] Of Boolean;
 Tiles = Array[1..4] Of TileGraphic;

 MapRec = Record
  MapInfo : MapArray;
  Walkable : MapWalk;
 End;

 HeroRec = Record
  Hx,Hy : Integer;
  HpMax,Hp : Integer;
  MpMax,Mp : Integer;
  XP, XPUp : Integer;
  Str,Def : Integer;
  MpStr : Integer;
  Level : Integer;
  Gold : Integer;
 End;

Var
 Tile : Tiles;
 Map : MapRec;
 BGScreen,FGScreen : BufferPtr;
 BGSSeg, FGSSeg : Word;
 Hero : HeroRec;
 Intkey : Integer;
 PosX,PosY : Integer;

Const
 Vga=$a000;

 Plains : TileGraphic =
((48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48),
 (48,44,48,48,44,48,48,44,48,48,44,48,48,44,48,48),
 (48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,44),
 (48,44,48,48,44,48,48,44,48,48,48,44,48,48,48,48),
 (48,48,48,48,48,48,48,48,48,48,48,48,48,44,48,48),
 (48,48,44,48,48,44,48,48,48,44,48,48,48,48,48,48),
 (48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,44),
 (44,48,48,48,44,48,48,48,48,48,44,48,48,44,48,48),
 (48,48,48,48,48,48,48,44,48,48,48,48,48,48,48,44),
 (48,48,44,48,48,48,48,48,48,48,48,48,48,48,48,48),
 (48,48,48,48,48,44,48,48,48,48,44,48,48,44,48,44),
 (48,44,48,48,48,48,48,44,48,48,48,48,48,48,48,48),
 (48,48,48,48,48,48,48,48,48,48,48,48,48,44,48,48),
 (48,48,48,48,48,48,48,48,48,48,44,48,48,48,44,48),
 (48,48,48,44,48,48,44,48,48,48,48,48,48,48,48,48),
 (44,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48));

 Water : TileGraphic =
((54,54,55,55,55,55,55,55,55,55,55,55,55,55,55,55),
 (55,54,55,55,54,55,55,55,54,54,54,55,55,55,55,55),
 (54,55,55,55,55,54,54,55,55,55,55,55,55,54,55,55),
 (55,55,55,55,55,55,55,55,55,55,54,54,55,55,54,55),
 (55,55,54,54,55,55,55,55,55,54,55,55,54,55,55,55),
 (55,54,54,54,54,55,55,55,54,55,55,55,55,54,55,55),
 (55,54,55,55,54,55,55,55,55,55,55,55,55,55,55,55),
 (54,55,55,55,54,54,55,55,54,55,55,55,54,54,54,55),
 (55,55,55,54,55,55,55,54,54,54,55,55,55,55,55,55),
 (55,55,55,55,55,55,54,55,55,55,54,55,55,55,55,55),
 (55,55,54,54,55,55,55,55,55,55,55,55,55,55,55,55),
 (54,54,55,55,54,55,55,55,55,55,55,54,55,55,55,55),
 (54,55,55,55,54,55,55,55,55,55,55,54,55,55,55,55),
 (55,54,54,55,55,55,55,55,55,55,55,55,54,55,55,55),
 (55,55,54,55,55,55,54,54,55,55,55,55,54,55,55,55),
 (55,55,55,55,55,54,55,54,54,55,55,55,55,55,55,55));

 HeroPic :TileGraphic =
(( 0, 0, 0, 0, 0, 0,22,22,22,22,22, 0, 0, 0, 0, 0),
 ( 0,19,19, 0, 0, 0,22,26,26,26,22, 0, 0, 0, 0, 0),
 ( 0,19,19, 0, 0, 0,22,22,22,22,22, 0, 0, 0, 0, 0),
 ( 0,19,19, 0, 0, 0, 0,22,22,22, 0, 0, 0, 0, 0, 0),
 ( 0,19,19, 0, 0, 0, 0,26,26,26, 0, 0, 0, 0, 0, 0),
 ( 0,19,19, 0, 0,27,27,27,27,27,27,27, 0, 0, 0, 0),
 ( 0,19,19, 0,27,27,23,23,27,23,23,27,27, 0, 0, 0),
 ( 0,19,19, 0,27,27,27,23,23,23,27,27,27, 0, 0, 0),
 ( 0,21,19, 0,27,27,27,27,23,27,27,27,27,27, 0, 0),
 (21,21,21,21,27, 0,28,27,23,27,27, 0,27,27, 0, 0),
 ( 0,21,21,27,27, 0,28,27,27,27,27, 0,27,27,27, 0),
 ( 0, 0, 0, 0, 0, 0,27,27,27,27,27, 0, 0,27,27, 0),
 ( 0, 0, 0, 0, 0, 0,27,28, 0,27,27, 0, 0, 0, 0, 0),
 ( 0, 0, 0, 0, 0, 0,114,114, 0,114,114, 0, 0, 0, 0, 0),
 ( 0, 0, 0, 0,114,114,114,114, 0,114,114,114,114, 0, 0, 0),
 ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));

 Forest : TileGraphic =
((47,47,119,47,47,44,47,47,119,47,44,47,47,120,47,47),
 (44,47,119,47,47,44,47,44,119,47,47,44,47,120,47,47),
 (47,119,119,119,47,47,47,119,119,119,47,47,47,120,47,47),
 (119,119,119,119,119,47,119,119,119,119,119,47,120,120,120,47),
 (119,119,119,119,119,44,119,119,119,119,119,47,120,120,120,47),
 (119,119,119,119,119,47,119,119,119,119,119,47,120,120,120,47),
 (119,119,119,119,119,44,119,119,119,119,119,47,120,120,120,47),
 (119,119,119,119,119,47,119,119,119,119,119,47,120,120,120,47),
 (119,119,119,119,119,44,119,119,120,120,119,47,120,120,120,47),
 (47,119,119,119,44,47,47,120,120,120,48,48,120,120,120,47),
 (44,119,119,119,47,47,44,120,120,120,47,48,120,120,120,47),
 (47,119,119,119,44,47,47,120,121,120,47,47,47,120,47,47),
 (47,47, 6,47,47,47,47,47, 6,47,44,47,44, 6,44,47),
 (44,47, 6,47,47,44,47,47, 6,47,47,47,47, 6,47,47),
 (47,47, 6,44,47,47,47,47,47,47,47,44,47,44 ,47,44),
 (47,44,47,47,47,47,44,47,47,44,47,47,47,47,47,47));

Procedure setmcga;
Begin asm mov ax,0013h;int 10h;end; End;

Procedure settext;
Begin asm mov ax,0003h;int 10h;end; End;

Procedure cls (col : byte; where:word);
Begin
 Fillchar (mem [where:0],64000,col);
End;

Procedure putpixel(x,y : integer; col:byte; where:word);
Begin
 mem[where:x+(y*320)]:=col;
End;

Procedure flip(source,dest:word);
Begin
  asm
   push    ds
   mov     ax, [Dest]
   mov     es, ax
   mov     ax, [Source]
   mov     ds, ax
   xor     si, si
   xor     di, di
   mov     cx, 32000
   rep     movsw
   pop     ds
  end;
End;

Procedure ScreenSetup;
Begin
 Getmem(BGScreen,64000);
 BGSSeg:=seg(BGScreen^);
 GetMem(FGScreen,64000);
 FGSSeg:=seg(FGScreen^);
End;

Procedure ScreenClose;
Begin
 Freemem(BGScreen,64000);
 FreeMem(FGScreen,64000);
End;

Procedure AssignTileInfo(Var Tile:Tiles);
Var Tx,Ty:Integer;
Begin
 Tile[1]:=Plains;
 Tile[2]:=Water;
 Tile[3]:=HeroPic;
 Tile[4]:=Forest;
End;

Procedure PutTile(Index:Integer; X,Y : Integer; Where:Word);
Var Tx, Ty : Integer;
Begin
 For Tx:=1 to 16 do
  For Ty:=1 to 16 do
    If (Tile[Index][Ty,Tx] <> 0) then
     Putpixel((X+Tx)-1,(Y+Ty)-1,(Tile[Index][Ty,Tx]),Where);
End;

Procedure PutTileMap(Var Map:MapRec; Xb,Yb,Xe,Ye,Tile:Integer);
Var Sx,Sy:Integer;
Begin
 For Sx:=Xb to Xe do
  For Sy:=Yb to Ye do
   Map.MapInfo[Sx,Sy]:=Tile;
End;

Procedure PutMap(PosX,PosY : Integer);
Var Mx,My : Integer;
Begin
 For Mx:=PosX to PosX+20-1 do
  For My:=PosY to PosY+12-1 do
    PutTile((Map.MapInfo[Mx,My]),(Mx-PosX)*16,(My-PosY)*16,BGSSeg);
End;

Procedure SetupHero(Var Hero:HeroRec);
Begin
 Hero.Hx:=5*16;
 Hero.Hy:=5*16;
 Hero.Hp:=50;
 Hero.HpMax:=50;
 Hero.Mp:=30;
 Hero.MpMax:=30;
 Hero.MpStr:=3;
 Hero.Level:=1;
 Hero.Xp:=0;
 Hero.XpUp:=200;
 Hero.Str:=5;
 Hero.Def:=5;
 Hero.Gold:=200;
End;

Procedure InitMap(Var Map:MapRec);
Var Mx, My : Integer;
Begin
 For Mx:=1 to 128 do
  For My:=1 to 80 do
   If (Mx=1) or (Mx=128) or (My=1) or (My=80) then
    Begin
     Map.MapInfo[Mx,My]:=2;
     Map.Walkable[Mx,My]:=False;
    End
   Else
    Begin
     Map.MapInfo[Mx,My]:=1;
     Map.Walkable[Mx,My]:=True;
    End;
End;

Procedure DrawHero(Var Hero:HeroRec;Intkey:Integer;Var PosX:Integer; Var PosY:Integer);
Var C:Integer;
Begin
    If (Intkey=75) then {Move Left}
     Begin
      If (PosX=1) and (Hero.Hx>16) then Dec(Hero.Hx,16)
      Else If (Hero.Hx=160) and (PosX <> 1) then Dec(PosX,1)
       Else If (Hero.Hx>16) and (Hero.Hx <> 160 ) then Dec(Hero.Hx,16);
      PutMap(PosX,PosY);
     End;
    If (Intkey=77) then {Move Right}
     Begin
      If (PosX=1) and (Hero.Hx<160) then Inc(Hero.Hx,16)
       Else If (PosX<109) and (Hero.Hx = 160) then Inc(PosX,1)
        Else If (Hero.Hx<288) then Inc(Hero.Hx,16);
     PutMap(PosX,PosY);
     End;
    If (Intkey=80) then {Move Down}
     Begin
      If (PosY=1) and (Hero.Hy<96) then Inc(Hero.Hy,16)
       Else If (PosY<69) and (Hero.Hy=96) then Inc(PosY,1)
        Else If (Hero.Hy<160) then Inc(Hero.Hy,16);
     PutMap(PosX,PosY);
     End;
    If (Intkey=72) then {Move Up}
     Begin
      If (PosY=1) and (Hero.Hy>16) then Dec(Hero.Hy,16)
       Else If (PosY<>1) and (Hero.Hy=96) then Dec(PosY,1)
        Else If (Hero.Hy>96) then Dec(Hero.Hy,16);
      PutMap(PosX,PosY);
     End;
 PutTile(3,Hero.Hx,Hero.Hy,BGSSeg);
End;

Begin
 PosX:=1; PosY:=1;
 ScreenSetup;
 SetMcga;
 Cls(0,BgSSeg);
 Cls(0,FgSSeg);
 Cls(0,Vga);
 SetUpHero(Hero);
 AssignTileInfo(Tile);
 InitMap(Map);
 PutTileMap(Map,10,10,20,30,4);
 PutTileMap(Map,30,50,119,74,4);
 PutMap(PosX,PosY);
 DrawHero(Hero,Intkey,PosX,PosY);
 Flip(BGSSeg,FGSSeg);
 Flip(FGSSeg,Vga);
 Repeat
  If keypressed then
   begin
    Intkey:=ord(Readkey);
    DrawHero(Hero,Intkey,PosX,PosY);
    Flip(BGSSeg,FGSSeg);
    Flip(FGSSeg,Vga);
   end;
 Until Intkey=27;
 SetText;
End.