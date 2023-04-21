Program FillTriangleProgram;

{ simple program for texture-mapping }
{ programmed by Christian Fleischer }
{ If you use this programm or inportant }
{ parts of it in your own program }
{ please give me credits somewhere and email me! }
{ email: daydream@cs.tu-berlin.de }

Uses
  Crt;

const
  Rund=256;
  Zoom=100;
  ClipZ=10;
  LenX:LongInt=100;
  LenY:LongInt=80;

type
  Pun2DInt=Record x,y:LongInt; end;
  Pun3DInt=Record x,y,z:LongInt; end;
  Triangle3D=Array[0..2] of Pun3DInt;
  Polygon2D=Array[0..3] of Pun2DInt;

Var
  Scr:Array[-99..100,-159..160] of Byte absolute $A000:0;
  Tri3D:Triangle3D;
  BMP:Array[0..127,0..127] of Byte;

Procedure Project(P1,P2:Pun3DInt; Var Poly:Polygon2D; Var LastPt:integer);
  begin   { projiziert einen Punkt auf die Bildschirm-Ebene }
    if P1.z>=ClipZ then
      begin  { Startpunkt der Linie liegt vor der ClipZ-Ebene }
        Inc(LastPt);
        Poly[LastPt].x:=(P1.x*Zoom) div P1.z;
        Poly[LastPt].y:=(P1.y*Zoom) div P1.z;
      end;
    if ((P2.z<ClipZ) and (P1.z>=ClipZ)) or ((P1.z<ClipZ) and (P2.z>=ClipZ)) then
      begin  { einer der beiden Punkte liegt hinter der ClipZ-Ebene }
        Inc(LastPt);
        Poly[LastPt].x:=(P2.x+(ClipZ-P2.z)*(P1.x-P2.x) div (P1.z-P2.z))*Zoom div ClipZ;
        Poly[LastPt].y:=(P2.y+(ClipZ-P2.z)*(P1.y-P2.y) div (P1.z-P2.z))*Zoom div ClipZ;
      end;
  end;

Procedure Swap(Var a,b:LongInt);
Var
  c:LongInt;
  begin
    c:=a;
    a:=b;
    b:=c;
  end;

Procedure FillTriangle(Tri3D:Triangle3D);
Var   { texturiert ein Dreieck }
  LoPun,HiPun,PtX,PtY:LongInt;
  Poly2D:Polygon2D;
  P,A,B,Norm,PMulA,PMulB:Pun3DInt;
  LinksX,LinksDiffY,LinksDiffX,LinksAddX,
  RechtsX,RechtsDiffY,RechtsDiffX,RechtsAddX,
  StartY,EndeY,
  Orientierung:LongInt;
  Alpha,Beta,
  LeftPt,RightPt,NextLeftPt,NextRightPt,
  Poly2DLastPt,dir:integer;   { Orientierung der Ebene (direction des Punktedurchlaufs) }

{ zwei Hilfsfunktionen von FillTriangle: }

Function GetBeta(Rx,Ry,Rz:LongInt):integer;
{ Bitmap-Index Beta berechnen }
  begin
    GetBeta:=((Rx*PMulA.x+Ry*PMulA.y+Rz*PMulA.z)*127)
          div (Rx*Norm.x+Ry*Norm.y+Rz*Norm.z);
  end;

Function GetAlpha(Rx,Ry,Rz:LongInt):integer;
{ Bitmap-Index Alpha berechnen }
  begin
    GetAlpha:=((Rx*PMulB.x+Ry*PMulB.y+Rz*PMulB.z)*127)
           div (Rx*Norm.x+Ry*Norm.y+Rz*Norm.z);
  end;


  begin
    P:=Tri3D[1];
    A:=Tri3D[0];
    B:=Tri3D[2];

    Poly2DLastPt:=-1;
    Project(Tri3D[0],Tri3D[1],Poly2D,Poly2DLastPt);
    Project(Tri3D[1],Tri3D[2],Poly2D,Poly2DLastPt);
    Project(Tri3D[2],Tri3D[0],Poly2D,Poly2DLastPt);
    if Poly2DLastPt<2 then
      Exit;   { weniger als drei Punkte ergeben keine Fl„che... }

    { allgemeine Vorberechnungen }
    { Norm ist ein Vektor (im Raum) senkrecht zum Dreick }
    Norm.x:=(A.y-P.y)*(B.z-P.z)-(A.z-P.z)*(B.y-P.y);
    Norm.y:=(A.z-P.z)*(B.x-P.x)-(A.x-P.x)*(B.z-P.z);
    Norm.z:=(A.x-P.x)*(B.y-P.y)-(A.y-P.y)*(B.x-P.x);
    PMulA.x:=Tri3D[1].y*Tri3D[0].z-Tri3D[1].z*Tri3D[0].y;
    PMulA.y:=Tri3D[1].z*Tri3D[0].x-Tri3D[1].x*Tri3D[0].z;
    PMulA.z:=Tri3D[1].x*Tri3D[0].y-Tri3D[1].y*Tri3D[0].x;
    PMulB.x:=-Tri3D[1].y*Tri3D[2].z+Tri3D[1].z*Tri3D[2].y;
    PMulB.y:=-Tri3D[1].z*Tri3D[2].x+Tri3D[1].x*Tri3D[2].z;
    PMulB.z:=-Tri3D[1].x*Tri3D[2].y+Tri3D[1].y*Tri3D[2].x;
    Orientierung:=Norm.x*P.x+Norm.y*P.y+Norm.z*P.z;
    { wie herum mssen die Punkte des Poly2D durchlaufen werden? }
    dir:=1;
    if Orientierung=0 then
      Exit    { Ebene nur als Strich zu sehen }
    else
      if Orientierung<0 then
        dir:=-1;
    { herausfinden, wo welcher Eckpunkt sich befindet }
    LoPun:=0;
    if Poly2D[1].y<Poly2D[LoPun].y then
      LoPun:=1;
    if Poly2D[2].y<Poly2D[LoPun].y then
      LoPun:=2;
    if Poly2DLastPt=3 then
      if Poly2D[3].y<Poly2D[LoPun].y then
        LoPun:=3;

    HiPun:=0;
    if Poly2D[1].y>Poly2D[HiPun].y then
      HiPun:=1;
    if Poly2D[2].y>Poly2D[HiPun].y then
      HiPun:=2;
    if Poly2DLastPt=3 then
      if Poly2D[3].y>Poly2D[HiPun].y then
        HiPun:=3;

    { Parameter fr Fll-Algorithmus berechnen }
    { ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }
    { Kantenlinien-Parameter }
      { fr links }
    LeftPt:=LoPun;
    NextLeftPt:=(LeftPt+dir+Poly2DLastPt+1) mod (Poly2DLastPt+1);

    LinksDiffY:=Poly2D[LeftPt].y-Poly2D[NextLeftPt].y-1;  { -1 wegen Randpunkten: geh”ren beide dazu! }
    LinksDiffX:=Poly2D[LeftPt].x-Poly2D[NextLeftPt].x-1;
    LinksAddX:=(LinksDiffX*Rund) div LinksDiffY;
    LinksX:=Poly2D[LeftPt].x*Rund;

      { fr rechts }
    RightPt:=LoPun;
    NextRightPt:=(RightPt-dir+Poly2DLastPt+1) mod (Poly2DLastPt+1);

    RechtsDiffY:=Poly2D[RightPt].y-Poly2D[NextRightPt].y-1;
    RechtsDiffX:=Poly2D[RightPt].x-Poly2D[NextRightPt].x-1;
    RechtsAddX:=(RechtsDiffX*Rund) div RechtsDiffY;
    RechtsX:=Poly2D[RightPt].x*Rund;
    StartY:=Poly2D[LoPun].y;
    EndeY:=Poly2D[HiPun].y;

    For PtY:=StartY to EndeY do
      begin
        { linke und rechte Kantenlinie verfolgen }
        Inc(LinksX,LinksAddX);
        Inc(RechtsX,RechtsAddX);
        For PtX:=LinksX div Rund to RechtsX div Rund do
          begin
            Alpha:=GetAlpha(PtX,PtY,Zoom);
            Beta:=GetBeta(PtX,PtY,Zoom);
            if (Alpha>=0) and (Alpha<=127) and (Beta>=0) and (Beta<=127) then
              Scr[PtY,PtX]:=BMP[Alpha,Beta];
          end;
        if PtY=Poly2D[NextLeftPt].y then
          begin  { neuen Eckpunkt verwenden! }
            LeftPt:=NextLeftPt;
            NextLeftPt:=(LeftPt+dir+Poly2DLastPt+1) mod (Poly2DLastPt+1);
            LinksDiffY:=Poly2D[LeftPt].y-Poly2D[NextLeftPt].y-1;
            LinksDiffX:=Poly2D[LeftPt].x-Poly2D[NextLeftPt].x-1;
            LinksAddX:=(LinksDiffX*Rund) div LinksDiffY;
            LinksX:=Poly2D[LeftPt].x*Rund;
          end;
        if PtY=Poly2D[NextRightPt].y then
          begin  { neuen Eckpunkt verwenden! }
            RightPt:=NextRightPt;
            NextRightPt:=(RightPt-dir+Poly2DLastPt+1) mod (Poly2DLastPt+1);
            RechtsDiffY:=Poly2D[RightPt].y-Poly2D[NextRightPt].y-1;
            RechtsDiffX:=Poly2D[RightPt].x-Poly2D[NextRightPt].x-1;
            RechtsAddX:=(RechtsDiffX*Rund) div RechtsDiffY;
            RechtsX:=Poly2D[RightPt].x*Rund;
          end;
      end;
  end;

Var
  i,j:integer;
  Key:Char;

begin
  directVideo:=false;
  asm
    mov ax,$13
    int $10
  end;
  FillChar(Scr,SizeOf(Scr),0);
  For i:=0 to 127 do
    For j:=0 to 127 do
      BMP[j,i]:=i+20;
  For i:=0 to 62 do
    begin
      BMP[i,i]:=10;
      BMP[i+1,i]:=10;
    end;
  For i:=0 to 360 do
    BMP[Round(cos(i/360*2*Pi)*31)+32,Round(sin(i/360*2*Pi)*31)+32]:=4;
  For i:=0 to 127 do
    For j:=0 to 127 do
      Scr[j-90,i-150]:=BMP[j,i];

  Tri3D[0].x:=0; Tri3D[0].y:=-90; Tri3D[0].z:=150;
  Tri3D[1].x:=-110; Tri3D[1].y:=50;  Tri3D[1].z:=220;
  Tri3D[2].x:=30; Tri3D[2].y:=80; Tri3D[2].z:=100;

  FillTriangle(Tri3D);
  Key:=UpCase(ReadKey);
end.