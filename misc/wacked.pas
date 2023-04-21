Uses DOS;
Const
   Up = 72; Down = 80;
   Left = 75; Right = 77;
Var
   Sintab, Costab : Array [0..255] of Integer;
   Px, Py, I, J : Word;
   TempAng, Ang : Byte;
   Virscr, Map : Pointer;
   Keydown : Array [0..127] of Boolean;
   OldKbInt : Procedure; 
   Xadd1, Xadd2, Yadd1, Yadd2, X1, X2, Y1, Y2 : Integer;

Procedure Hline(Sy : Word; Mx1, My1, Mx2, My2 : Integer);
Var
   Xgrad, Ygrad, Xer, Yer : Integer;
   I, D : Word;
Begin
   Xgrad := (Mx2-Mx1) div 319;
   Ygrad := (My2-My1) div 319;
   Xer := Mx1;
   Yer := My1;
   D := Sy*320;
   For I := 0 to 319 do
   Begin
      Mem[Seg(Virscr^):D ] := Mem[Seg(Map^):(Xer shr 8)+(Yer shr 8 shl 8)];
      Inc(D);
      Xer := Xer + Xgrad; Yer := Yer + Ygrad;
   End;
End;
{$F+}
Procedure MyKbInt; Interrupt;
Begin
   Keydown[Port[$60] and 127] := (Port[$60] and 128) = 0;
   Port[$20] := $20;
End;
{$F-}
Begin
   Getmem(Virscr, 65535); Getmem(Map, 65535);
   Fillchar(Keydown, Sizeof(Keydown), 0);
   Getintvec($09, @OldKbInt);
   Setintvec($09, @MyKbInt);
   Asm
      mov ax, 0013h; int 10h
   End;
   Fillchar(Mem[Seg(Virscr^):0], 65535, 0);
   For I := 0 to 255 do
   Begin
      Costab[I] := Round(Cos(I*pi/128)*256);
      Sintab[I] := Round(Sin(I*pi/128)*256);
   End;
   Port[$3c8] := 0;
   For I := 0 to 255 do
   Begin
      Port[$3c9] := I shr 2;
      Port[$3c9] := I shr 2;
      Port[$3c9] := I shr 2;
   End;
   For I := 0 to 255 do
   For J := 0 to 255 do
      Mem[Seg(Map^):I+J shl 8] := I xor J;

   Px := 127; Py := 127; Ang := 64;

   Repeat
      TempAng := Ang + 30;
      Xadd1 := Costab[TempAng]; Yadd1 := -Sintab[TempAng];
      TempAng := Ang - 30;
      Xadd2 := Costab[TempAng]; Yadd2 := -Sintab[TempAng];

      X1 := Px; Y1 := Py;
      X2 := Px; Y2 := Py;

      For I := 0 to 63 do
      Begin
         Hline((199-I), X1, Y1, X2, Y2);
         X1 := X1 + Xadd1; Y1 := Y1 + Yadd1;
         X2 := X2 + Xadd2; Y2 := Y2 + Yadd2;
      End;

      If Keydown[Left] then Inc(Ang);
      If Keydown[Right] then Dec(Ang);

      If Keydown[Up] then
      Begin
         Px := Px + Costab[Ang]; Py := Py + -Sintab[Ang];
      End;

      If Keydown[Down] then
      Begin
         Px := Px - Costab[Ang]; Py := Py - -Sintab[Ang];
      End;

      Move(Mem[Seg(Virscr^):0], Mem[$A000:0], 64000);
      Fillchar(Mem[Seg(Virscr^):0], 65535, 0);
   Until Keydown[1];
   Asm
      mov ax, 0003h; int 10h
   End;
   Freemem(Virscr, 65535); Freemem(Map, 65535);
   Fillchar(Keydown, Sizeof(Keydown), 0);
   Setintvec($09, @OldKbInt);
End.
