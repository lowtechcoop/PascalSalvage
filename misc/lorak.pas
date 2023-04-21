program fader; { Fader prog using fire stuff }
uses crt;
var x,y,g:integer;
    col:byte;
    a,b,c,d:word;
CONST VGA = $A000;

TYPE Virtual = Array [1..64000] of byte;  { The size of our Virtual Screen }
     VirtPtr = ^Virtual;                  { Pointer to the virtual screen }

VAR Virscr : VirtPtr;                     { Our first Virtual screen }
    Vaddr  : word;                        { The segment of our virtual screen}

Procedure SetMCGA;  { This procedure gets you into 320x200x256 mode. }
BEGIN
  asm
     mov        ax,0013h
     int        10h
  end;
END;

{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure SetText;  { This procedure returns you to text mode.  }
BEGIN
  asm
     mov        ax,0003h
     int        10h
  end;
END;
Procedure Cls (Where:word;Col : Byte); assembler;
   { This clears the screen to the specified color }
asm
   push    es
   mov     cx, 32000;
   mov     es,[where]
   xor     di,di
   mov     al,[col]
   mov     ah,al
   rep     stosw
   pop     es
End;
Procedure SetUpVirtual;
   { This sets up the memory needed for the virtual screen }
BEGIN
  GetMem (VirScr,64000);
  vaddr := seg (virscr^);
END;

{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
Procedure ShutDown;
   { This frees the memory used by the virtual screen }
BEGIN
  FreeMem (VirScr,64000);
END;

{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure flip(source,dest:Word); assembler;
  { This copies the entire screen at "source" to destination }
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

procedure setpal;
var pall:byte;
begin;
pall:=0;
for x:=1 to 32 do begin;
port[$3c8]:=x;
port[$3c9]:=x shl 1;
port[$3c9]:=0;
port[$3c9]:=0;
end;

for x:=0 to 63 do
 begin;
    port[$3c8]:=x+32;
    port[$3c9]:=63;
    port[$3c9]:=x;
    port[$3c9]:=x; { this routine sucks ... but it works}

    port[$3c8]:=x+95;  {it will set a real crappy fire pal..}
    port[$3c9]:=63;
    port[$3c9]:=x;
    port[$3c9]:=x;

    port[$3c8]:=x+158;
    port[$3c9]:=x;
    port[$3c9]:=x;
    port[$3c9]:=x;

 end;


end;
procedure drawfire;
var col:integer;
begin;
     g:=g+1;
     x:=0;
    repeat
    col:=random(255);
    mem[vaddr:64000-x]:=col ;{put down a line of pixels at the bottom}

     x:=x+1;
    until x>319;

   for a :=0 to 64000 do  begin;
      b:=(mem[vaddr:a+1]+mem[vaddr:a+320]+mem[vaddr:a-1]+mem[vaddr:a+640]);
      {play with the above line to get diff fx!}
      {main fire routine}
      {try changing the numbers to see what happens}
      c:=b shr 2;    {shr 2 = div by 4 in asm}
      mem[vaddr:a] := c ; {write all to virtual screen}

      end;
flip(vaddr,vga);{flip virtual to real screen}
end;

begin;
randomize;
setupvirtual;  {get virtual screen memory}
setmcga; {set vga 320x200}
{setpal;}{uncomment this to see the colours}
cls(vaddr,0);
cls(VGA,0); {clear the screens}

repeat
x:=0;
drawfire;
until keypressed;

shutdown; {free memory}
settext;      {return to textmode}

end.
