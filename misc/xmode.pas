Program XModeScroller; { By Harald Houppermans 1997 }

Uses Dos;

Const Speed:ShortInt = 1;

      Size:Byte=160; { Size 40 and 160 are programmed in source code }
      {  40  320x200 1 screen  across, 4 screen  down (  320x800 ) }
      {  80  320x200 2 screens across, 2 screens down (  640x400 ) }
      { 160  320x200 4 screens across, 1 screen  down ( 1280x200 ) }

      scEsc       = 001;

Var fofs,fseg:word;

    OldKbdInt: Procedure; {Variable to save old keyboard interrupt in}
    Key:Array[0..127] of Boolean; { All keys, true if that key is pressed }

Procedure SetChain4; Assembler;  { Get into Chain-4 videomode }
Asm
   mov   ax,0013h         { Videomode 13h  320*200*256 }
   int   10h              { Set the mode }

   mov   dx,03c4h         { Sequencer Address Register }
   mov   al,4             { Index 4 - Memory mode }
   out   dx,al            { Select it }
   inc   dx               { 03c5h - Here we set the mem mode }
   in    al,dx            { Get settings inside register }
   and   al,11110111b     { Disable 3rd bit will give us chain4 }
   or    al,00000100b     { Bit 2 enabled => no odd/even-scheme }
   out   dx,al            { Inform VGA }

   mov   dx,3d4h
   mov   al,14h           { Turn off Double Word mode }
   out   dx,al
   inc   dx
   in    al,dx
   and   al,10111111b     { Bit 6 := 0 => Disable double word adressing }
   out   dx,al
   mov   dx,3d4h
   mov   al,17h           { Mode Control Register }
   out   dx,al
   inc   dx
   in    al,dx            { Get what's in the register }
   or    al,01000000b     { Bit 6 := 1 => Address memory as lineair array }
   out   dx,al

   mov   dx,3d4h          { Select the port }
   mov   al,13h           { Select the index Logical Screen Width }
   out   dx,al            { Inform VGA about it }
   inc   dx               { Increase port value }
   mov   al,[Size]        { Set the size }
   out   dx,al            { Give info to VGA }
End;

Procedure Cls_C4; Assembler;
Asm
   mov   dx,03c4h         { Select port 03c4h }
   mov   al,2             { Map Mask Register }
   out   dx,al
   inc   dx
   mov   al,00001111b     { Select all planes for writing }
   out   dx,al            { So we can clear all planes at once }

   mov   ax,0a000h
   mov   es,ax
   xor   di,di            { Set es:di = Screen Mem }
   mov   ax,0             { Color to put = black }
   mov   cx,32768         { 32768 (words) * 2 = 65536 bytes = 1 screen }

   cld
   rep   stosw            { Clear it }
End;

Procedure Plot(X,Y:Integer; Color:Byte); Assembler;
Asm
   mov    ax,[Y]                   { Put Y in ax }
   xor    bx,bx                    { Reset bx to zero }
   mov    bl,[Size]                { Size in bl (it's a Byte!) }
   imul   bx                       { Now ax:=ax*bx => Y:=Y*Size }
   shl    ax,1                     { Multiply by 2 => Y:=Y*2 (Dunno why) }
   mov    bx,ax                    { Save Y-value in bx }
   mov    ax,[X]                   { Move X-value into ax }
   mov    cx,ax                    { And in cx }
   shr    ax,2                     { Divide ax by 4  (x div 4) }
   add    bx,ax                    { Y:=Y+X   bx contains final location }
   and    cx,00000011b             { cl:=0,1,2 or 3  (x mod 4) }
   mov    ah,00000001b             { Start value (plane 0) }
   shl    ah,cl                    { Eg plane 2: 00000001 => 00000100 }
   mov    dx,3c4h                  { Sequencer Register }
   mov    al,2                     { Select index 2 => plane enable }
   out    dx,ax                    { Enable selected plane }
   mov    ax,0a000h                { VGA segment }
   mov    es,ax                    { es points to VGA }
   mov    al,[Color]               { Color in al }
   mov    es:[bx], al              { Place it }
End;

Procedure MoveTo(X,Y : Integer); Assembler;
Asm
   mov   ax,[Y]           { Y value }
   xor   bx,bx            { Reset bx to zero }
   mov   bl,[Size]        { Size in bl }
   shl   bx,1             { *2 (dunno why) }
   imul  bx               { Multiply Y with size }
   mov   bx,ax            { Save Y into BX }

   add   bx,[X]           { Y:=Y+X }

   mov   dx,03d4h         { CRTC address register }
   mov   al,0ch           { Start Address High register }
   out   dx,al
   inc   dx
   mov   al,bh            { Send high byte of start address }
   out   dx,al

   dec   dx
   mov   al,0dh           { Start Address Low register }
   out   dx,al
   inc   dx
   mov   al,bl            { Send low byte of start address }
   out   dx,al
End;

Procedure SetPal( Col,R,G,B:Byte); Assembler;
Asm
  mov dx,03c8h;
  mov al,[Col];
  out dx,al;
  inc dx;
  mov al,[R]; out dx,al;
  mov al,[G]; out dx,al;
  mov al,[B]; out dx,al;
End;

Procedure Retrace; Assembler;
Asm
  mov dx,03dah
  @vert1: in al,dx; test al,8; jnz @vert1
  @vert2: in al,dx; test al,8; jz @vert2;
End;

Procedure GetFont; Assembler;
Asm
  mov ax,1130h
  mov bh,1
  int 10h
  mov fseg,es
  mov fofs,bp
End;

Procedure WriteTxt(x,y:word; txt:string; Color:Byte;lvseg:word);
Var i,j,k:byte;
Begin
  for i:=1 to length(txt) do for j:=0 to 7 do for k:=0 to 7 do
    if ((mem[fseg:fofs+ord(txt[i])*8+j] shl k) and 128) <> 0 then
      plot((i*8)+x+k,(y+j),color);
End;

Procedure NewKbdInt;Interrupt; Assembler; {The new keyboard interrupt}
Const biosseg : word = $40; {Segment to bios data}
Asm
   xor bh,bh               { Reset bh }
   in al,60h               { Get scancode }
   mov bl,al               { Save scancode }
   and bl,01111111b        { Mask the lower 7 bits }
   xor al,10000000b        { Invert upper bit }
   shr al,7                { Just moves the upper bit to the lowest }
   mov byte ptr key[bx],al { Save keyboard status }
   pushf                   { Push flags }
   call oldkbdint          { Call old keyboard interrupt }
   cli                     { Disable interrupts }
   mov es,biosseg          { Get bios segment }
   mov ax,es:[1Ah]         { Get keyboard buffert start }
   mov es:[1Ch],ax         { Write buffert start to buffert end=buffert empty
}
   sti                     { Enable interrupts }
End;

Procedure Install_Keys;
Begin
  GetIntVec($9,@OldKbdInt); { Get old interrupt }
  SetIntVec($9,@NewKbdInt); { Set new interrupt }
End;

Procedure Restore_Keys;
Begin
  SetIntVec($9,@OldKbdInt); { Restore old interrupt }
End;

Var X,Y,I:Integer;
Begin
  Install_Keys;

  SetChain4;
  Cls_C4;

(* Select Plane ?
  asm
    mov   dx,3ceh          { Select port }
    mov   al,02            { Select index }
    out   dx,al            { Give info to VGA }
    inc   dx               { Increase port value (datafield) }
    mov   al,00000001b     { Enable plane 0   (bit 0 is now set) }
    out   dx,al            { Inform VGA about this }
  end; *)

  SetPal(1,63,0,0); { red }
  SetPal(2,0,63,0); { green }
  SetPal(3,63,0,63); { blue }
  SetPal(4,63,63,63); { white }

  GetFont;

  CASE Size of 40 : BEGIN { 320 * 800 }
                     FOR X:=0 TO 319 DO BEGIN
                      plot(x,0,1); { plane 1 }
                      plot(x,199,1);

                      plot(x,200,2); { plane 2 }
                      plot(x,199+200,2);

                      plot(x,200+200,3); { plane 3 }
                      plot(x,199+200+200,3);

                      plot(x,200+200+200,4); { plane 4 }
                      plot(x,199+200+200+200,4);
                     END;

                     FOR Y:=0 TO 199 DO BEGIN
                      plot(0,Y,1); { plane 1 }
                      plot(319,Y,1);

                      plot(0,Y+200,2); { plane 2 }
                      plot(319,Y+200,2);

                      plot(0,Y+400,3); { plane 3 }
                      plot(319,Y+400,3);

                      plot(0,Y+600,4); { plane 4 }
                      plot(319,Y+600,4);
                     END;
                     writetxt(160-24,100-4,'PAGE 1',1,$a000);
                     writetxt(160-24,300-4,'PAGE 2',2,$a000);
                     writetxt(160-24,500-4,'PAGE 3',3,$a000);
                     writetxt(160-24,700-4,'PAGE 4',4,$a000);
                    END; { END OF 320 * 800 (SIZE 40) }

              160 : BEGIN { 1280 * 200 }
                     FOR X:=0 TO 319 DO BEGIN
                      plot(x,0,1); { plane 1 }
                      plot(x,199,1);

                      plot(x+320,0,2); { plane 2 }
                      plot(x+320,199,2);

                      plot(x+320+320,0,3); { plane 3 }
                      plot(x+320+320,199,3);

                      plot(x+320+320+320,00,4); { plane 4 }
                      plot(x+320+320+320,199,4);
                     END;

                     FOR Y:=0 TO 199 DO BEGIN
                      plot(0,Y,1); { plane 1 }
                      plot(319,Y,1);

                      plot(0+320,Y,2); { plane 2 }
                      plot(319+320,Y,2);

                      plot(0+320+320,Y,3); { plane 3 }
                      plot(319+320+320,Y,3);

                      plot(0+320+320+320,Y,4); { plane 4 }
                      plot(319+320+320+320,Y,4);
                     END;

                     writetxt(160-24,100-4,'PAGE 1',1,$a000);
                     writetxt(160-24+320,100-4,'PAGE 2',2,$a000);
                     writetxt(160-24+320+320,100-4,'PAGE 3',3,$a000);
                     writetxt(160-24+320+320+320,100-4,'PAGE 4',4,$a000);
                   END; { END OF 1280*200 (SIZE 160) }

  END; { END OF CASE }

{ Main Loop(s) }
  Y:=0;
  X:=0;

  CASE Size of 40 : Repeat
                      Y := Y + Speed;
                      IF (Y > 599) OR (Y < 1) THEN Speed:=-Speed;

                      Retrace;
                      MoveTo(0,Y);
                    Until Key[scEsc];

              160 : Repeat
                      X := X + Speed;
                      IF (X > 239) OR (X < 1) THEN Speed:=-Speed;

                      Retrace;
                      MoveTo(X,0);
                    Until Key[scEsc];

  END; { END OF CASE }

  asm
    mov ax,0003h { textmode }
    int 10h
  end;

  Restore_Keys;
End.

