
� Area: Demos NZ - FidoNet 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
  Msg#: 182             Rec'd                        Date: 10-30-97 12:09
  From: Perry Lorier                                 Read: Yes    Replied: No 
    To: Blair Harrison                               Mark:                     
  Subj: ModeQ/2 Fire
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
  PL> Ummm... No.
  PL> ModeQ is 256x256x256 LINEAR ADDRESSING...  No bank

 BN> I meant plane switching... I was sure I wrote that. Ho hum. Now I
 BN> sound like a vegetable. Anyways..

 BN> Yeah, yeah, I see the putpixel. I always thought that 256x256 was only
 BN> for virt screens in real mode.. Ho hum.
 BN> How do you set it?

 BH> Take a look at this ModeQ Fire, i just converted it from the other one in
 BH> about 5 minutes !! :)))))

I've finally got around to looking at it, and I spent about 20minutes and
came up with this... There ain't much left, but it BURNS along now :)

Its now in ModeQ/2 (256x128x256) to make the fire "taller", and I moved lots
of it to asm, and then removed the virtual screen (why we need virt screen
junk? :)

----cut----}
program bfireQ; { Mode Q/2 methane Fire - purple!! }

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
var pall:byte;
   x   : byte;
begin;
   pall:=0;
   for x:=1 to 32 do
   begin;
      port[$3c8]:=x;
      port[$3c9]:=0;
      port[$3c9]:=0 ;
      port[$3c9]:=0 ;
   end;

for x:=0 to 63 do
 begin;
    port[$3c8]:=x+32;
    port[$3c9]:=0;
    port[$3c9]:=0;
    port[$3c9]:=0;

    port[$3c8]:=x+95;
    port[$3c9]:=x*35 div 63;
    port[$3c9]:=0;         {change these 3 lines for diff colour fire!}
    port[$3c9]:=x;

    port[$3c8]:=x+158;
    port[$3c9]:=35;
    port[$3c9]:=x;
    port[$3c9]:=63;
 end;
end;

{ Umm, very different! }
procedure drawfire;
var
   x   : Word;
begin;
   Repeat
      for x:=0 to 512 Do
         mem[$A000:x-32511]:=Random(255);
   asm
      mov ax,$A000
      mov es,ax
      mov bx,65280-32000
    @again:
      mov ah,0
      mov al,[es:bx]
{Theres Gotta be a more efficient way of add ax,byte ptr [es:bx+y]?}
{Oh, and modeQ is just DESIGNED for asm! :)}
      add al,[es:bx+255]
      adc ah,0
      add al,[es:bx+256]
      adc ah,0
      add al,[es:bx+257]
      adc ah,0
      shr ax,2
      mov [es:bx],al
      dec bx
      cmp bx,20000
      ja @again
    end;
    Until Port[$60]=1; {Until ESC is pressed}
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
{

... If you get to an issue that's relevant, let us know. -- Joel

-!- Fog
 ! Origin: In the beginning everything was null and Void (3:774/950.42)  
