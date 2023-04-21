Uses Crt;

Procedure PutIndexed(Prt:Word;Ind,Val:Byte);
Begin
   Port[prt]:=Ind;
   Port[prt+1]:=Val;
End;

Procedure SetModeQ;
var
   X   : Byte;
Begin
   asm
      mov ax,013h
      int 10h
   end;
   port[$3d4]:=$11; X := port[$3d5] and $7F; port[$3d4]:=$11;
   port[$3d5]:=X;

   port[$3c2]:=$E3;

   PutIndexed($3d4,$00,$5F); PutIndexed($3d4,$01,$3F);
   PutIndexed($3d4,$02,$40); PutIndexed($3d4,$03,$82);
   PutIndexed($3d4,$04,$4A); PutIndexed($3d4,$05,$9A);
   PutIndexed($3d4,$06,$23); PutIndexed($3d4,$07,$B2);
   PutIndexed($3d4,$08,$00); PutIndexed($3d4,$09,$61);
   PutIndexed($3d4,$10,$0A); PutIndexed($3d4,$11,$AC);
   PutIndexed($3d4,$12,$FF); PutIndexed($3d4,$13,$20);
   PutIndexed($3d4,$14,$40); PutIndexed($3d4,$15,$07);
   PutIndexed($3d4,$16,$1A); PutIndexed($3d4,$17,$A3);

   PutIndexed($3c4,$01,$01); PutIndexed($3c4,$04,$0E);

   PutIndexed($3ce,$05,$40); PutIndexed($3ce,$06,$05);

   X:=Port[$3DA]; Port[$3C0]:= $10 or $20; Port[$3C0]:= $41;
   X:=Port[$3DA]; Port[$3C0]:= $13 or $20; Port[$3C0]:= $0;
End;

Procedure SetText; assembler;
asm
   mov ax,03h
   int 10h
end;

Procedure PutPixel(X,Y,C:Byte);
Begin
   Mem[$A000:Y shl 8+X]:=C;
End;

Function GetPixel(X,Y:Byte):Byte;
Begin
   GetPixel:=Mem[$A000:Y shl 8+X];
End;

Var
   I,
   J   : Byte;
Begin
   SetModeQ;
   For I:=0 to 255 Do
      For J:=0 to 255 Do
         PutPixel(I,J,(I+J) and $FF);
   Readkey;
   SetText;
End.
