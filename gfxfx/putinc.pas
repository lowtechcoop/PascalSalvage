
{$g+}
program displaypackedpic;
{ display packed picture in mode 13h, by Bas van Gaalen, Holland, PD }
uses crt;
const
{$i incfile.inc}
var
  i,j,num,ofs : word;
  inbyte : byte;

procedure setpalette(var pal); assembler;
asm
  push ds
  mov dx,03c8h
  xor ax,ax
  out dx,al
  inc dx
  lds si,pal
  mov cx,0300h
  rep outsb
  pop ds
end;

begin
  { set graphics and palette }
  asm mov ax,13h; int 10h; end;
  setpalette(pal);

  { unpack picture to screen }
  i := 0;
  while i < sizeof(pic) do begin
    inbyte := pic[i];
    if inbyte = 0 then begin
      inbyte := pic[i+1];
      num := pic[i+2]+256*pic[i+3];
      for j := 0 to num-1 do mem[sega000:ofs+j] := inbyte;
      inc(ofs,num); inc(i,4);
    end else begin
      mem[sega000:ofs] := inbyte;
      inc(ofs); inc(i);
    end;
  end;

  { wait for key and clearkeybuf }
  repeat until keypressed; while keypressed do readkey;
  asm mov ax,3; int 10h; end;
end.
