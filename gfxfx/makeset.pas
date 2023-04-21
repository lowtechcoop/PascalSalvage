
program dropcharset;
{ Put TheDraw uncrunched Pascal ansi file on screen, and 'unchain' it...
  by Bas van Gaalen, Holland, PD }
uses
  crt,bcrt;

type
  scrtype = array[0..7999] of byte;
  storetype = array[0..4,0..320] of word;

var
  txtfile : text;
  scraddr : scrtype absolute $b800:$0000;
  chars : storetype;
  v,x : word;
  i,y : byte;

{$i charset.inc}

begin
  textmode(co80+font8x8);
  ansiwrite(imagedata,scraddr,imagedata_length);
  assign(txtfile,'CHARS.INC');
  rewrite(txtfile);

  for i := 0 to 4 do { 5-line hi charset }
    for x := 0 to 79 do begin { 80 small characters on one line }
      for y := 0 to 3 do begin { 4 lines of big characters }
        v := memw[$b800:y*5*160+i*160+x+x];
        memw[$b800:(i*5+20+y)*160+x+x] := v;
        chars[i,y*80+x] := v;
      end;
    end;

  writeln(txtfile,'  chars : array[0..4,0..320] of word = (');
  write(txtfile,'    ');
  for y := 0 to 4 do begin { 5-line hi charset }
    for x := 0 to 320 do begin { 320 bytes in one line }
      write(txtfile,chars[y,x],',');
      if x mod 10 = 9 then begin writeln(txtfile); write(txtfile,'    '); end;
    end;
    write(txtfile,'),(');
  end;
  writeln(txtfile,')');

  close(txtfile);
  repeat until keypressed;
end.
