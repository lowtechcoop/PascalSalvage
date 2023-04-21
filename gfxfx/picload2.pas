
{$i-,v-}

program PictureLoader;
{ Another raw-picture loader (pal at $10: ColoRIX/EGA format), by Bas van Gaalen, Holland, PD}
uses crt;
const vseg = $a000;
type
  str80 = string[80];
  buftp = array[0..4095] of byte;
  palbuf = array[0..$2ff] of byte;
var
  picfile : file;
  palette : palbuf;
  buffer : buftp;
  filename : str80;
  i,bufct : longint;
  nofread : integer;

procedure setpal(col,r,g,b : byte); assembler; asm
  mov dx,03c8h; mov al,col; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al end;

procedure setcolors(buf : palbuf); var c : word; i : byte; begin c := 3;
  for i := 1 to 255 do begin setpal(i,buf[c],buf[c+1],buf[c+2]); inc(c,3); end; end;

begin
  filename := paramstr(1);
  if filename = '' then begin
    writeln('Please enter filename on commandline.'); halt; end;
  assign(picfile,filename);
  reset(picfile,1); if ioresult <> 0 then begin
    writeln(filename+' not found in current dir'); halt; end;
  seek(picfile,10);
  blockread(picfile,palette,$300);
  asm mov ax,2eh; int 10h; end;
  setcolors(palette);
  bufct := 0;
  repeat
    blockread(picfile,buffer,4096,nofread);
    for i := 0 to nofread-1 do begin
      port[$03cd] := (bufct+i) shr 16;
      mem[vseg:(bufct+i) and $ffff] := buffer[i];
    end;
    inc(bufct,nofread);
  until nofread < 4096;
  close(picfile);
  repeat until keypressed;
  textmode(lastmode);
end.
