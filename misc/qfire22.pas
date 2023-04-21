
� Area: Demos NZ - FidoNet 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
  Msg#: 208                                          Date: 11-05-97 14:55
  From: Perry Lorier                                 Read: Yes    Replied: No 
    To: You Know Your REALLY bored when...           Mark:                     
  Subj: fire mrk ]i[
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
program bfireQ; { Mode Q/2 dual fire with different randomization aka:
Southern Lights :)}
Const Size=5;

Procedure Cls (Where:word;Col : Byte); assembler;
   
asm
   mov     cx, 16000;
   mov     es,[where]
   xor     di,di
   mov     al,[col]
   mov     ah,al
   db $66
   rep     stosw
End;

Procedure PutIndexed(Prt:Word;Ind,Val:Byte);
Begin
   Port[prt]:=Ind;
   Port[prt+1]:=Val;
End;

Procedure SetModeQ2;
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

   { This sets double scanline mode, the VGA draws each scanline twice,
   making this a modeQ/2, or 256x128x256 :).  BTW: 12.5x80x16 is a fun
   video mode :) Its quite clear from the screen whats going on: everything
   looks "stripped" if you look closely :) }

   asm
      mov dx,3d4h
      mov al,9
      out dx,al
      inc dx
      in al,dx
      mov ah,al
      or ah,128
      dec dx
      mov al,9
      out dx,al
      inc dx
      mov al,ah
      out dx,al
   end;
End;

procedure setpal;
var
   x   : byte;
   i,
   j   : Byte;
begin;
   X:=0;
   for I:=0 to 15 Do
      For J:=0 to 15 Do
      begin
         port[$3C8]:=X;
         port[$3C9]:=I*4;
{         Port[$3C9]:=(I+J)*2;}
         Port[$3C9]:=0;
         Port[$3C9]:=J*4;
         Mem[$A000:I*256+J]:=X;
         X:=X+1;
      End;
end;

{ModeQ(/2) PutText}
Procedure PutText(X,Y:Byte;S:String;R,G:Byte);
Var
   I,
   J,
   K   : Byte;
Begin
   For I:=1 to Length(S) Do
      For J:=0 to 7 Do
         For K:=0 to 7 Do
            If Mem[$F000:$FA6E+Ord(S[I])*8+J] and (1 shl K)<>0 Then
               Mem[$A000:word(Y+J) shl 8+X+8*I-K]:=R*$10+G;
End;

{ Umm, very different! }
procedure drawfire;
var
   x   : Word;
   r,
   g   : Byte;
begin;
   Repeat
      { Unique randomization :) }
      For x:=0 to 100 Do
         Mem[$A000:33280+Random(255)]:=Random(255);

      { This does the two fires seperately then joins them together}
      asm
         mov bx,33280
         mov ax,$A000
         mov es,ax
      @loopy:
         {Clear the Colours}
         xor ax,ax
         xor cx,cx

         mov dl,[es:bx]  { DL = Pixel }
         mov al,dl       { AL = R }
         and dl,$F
         mov cl,dl       { CX = DL and $F }

         mov dl,[es:bx+255]
         add al,dl
         adc ah,0
         and dl,$F
         add cl,dl
         adc cl,0

         mov dl,[es:bx+256]
         add al,dl
         adc ah,0
         and dl,$F
         add cl,dl
         adc cl,0

         mov dl,[es:bx+257]
         add al,dl
         adc ah,0
         and dl,$F
         add cl,dl
         adc cl,0

         shr ax,2
         and al,$F0
         shr cx,2
         or al,cl
         mov [es:bx],al
         dec bx
         cmp bx,29000
         ja @loopy
      End;
    Until Port[$60]<128; {Until a key is pressed}
end;

begin;
   randomize;
   setmodeQ2;
   setpal;
   drawfire;
   asm
      mov ax,3h
      int 10h
   end;
end.
... This is meaningful only to a small select group, Tom added defusingly.

-!- Myst
 ! Origin: null (tm) (3:774/950.42)  
