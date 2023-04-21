
{$g+}
program displaypackedpic;
{ display packed picture in mode 13h, by Bas van Gaalen, Holland, PD }
uses dos,crt;
var
  infile : file;
  palette : array[0..767] of byte;
  infname : pathstr;
  i,num,ofs : word;
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
  { file i/o }
  if paramstr(1) = '' then begin
    write(' infile: '); readln(infname); end else infname := paramstr(1);
  assign(infile,infname);
  reset(infile,1);
  if ioresult <> 0 then begin
    writeln('error opening ',infname); halt; end;

  { set graphics and palette }
  asm mov ax,13h; int 10h; end;
  blockread(infile,palette,768);
  setpalette(palette);

  { unpack picture to screen }
  ofs := 0;
  while filepos(infile) < filesize(infile) do begin
    blockread(infile,inbyte,1);
    if inbyte = 0 then begin
      blockread(infile,inbyte,1);
      blockread(infile,num,2);
      for i := 0 to num-1 do mem[sega000:ofs+i] := inbyte;
      inc(ofs,num);
    end else begin
      mem[sega000:ofs] := inbyte;
      inc(ofs);
    end;
  end;
  close(infile);

  { wait for key and clearkeybuf }
  repeat until keypressed; while keypressed do readkey;
  asm mov ax,3; int 10h; end;
end.
