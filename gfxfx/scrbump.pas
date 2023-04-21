
program text_sinus_scroll;
{ smooth sinus-scroll in textmode, by Bas van Gaalen, Holland, PD }
uses crt;
const sspd = -1; samp = 75; sofs = 250; slen = 255; vseg : word = $b800;
  txt : string = 'Another way to scroll... :-)     ';
var stab : array[0..255] of word; fseg,fofs : word;

procedure getfont8x8; assembler; asm
  mov ax,1130h; mov bh,1; int 10h; mov fseg,es; mov fofs,bp; end;

procedure setimage(ch : char; var data);
var offset : word;
begin
  offset := ord(ch)*32;
  inline($fa);
  portw[$03c4] := $0402;
  portw[$03c4] := $0704;
  portw[$03ce] := $0204;
  portw[$03ce] := $0005;
  portw[$03ce] := $0006;
  move(data,ptr($a000,offset)^,8);
  portw[$03c4] := $0302;
  portw[$03c4] := $0304;
  portw[$03ce] := $0004;
  portw[$03ce] := $1005;
  portw[$03ce] := $0E06;
  inline($fb);
end;

procedure initialize;
var charset : array[0..7] of byte; i : byte;
begin
  if lastmode = 7 then vseg := $b000;
  textmode(co80+font8x8);
  textcolor(white); clrscr;
  writeln; writeln('In case you don''t believe it: this is textmode...');
  gotoxy(1,1); mem[$b800:1] := 0;
  for i := 0 to 7 do begin
    fillchar(charset,sizeof(charset),0);
    charset[i] := 3;
    setimage(chr(128+i),charset);
  end;
end;

procedure generatetab; var i : byte; begin
  for i := 0 to 255 do stab[i] := round(sin(4*pi*i/slen)*samp)+sofs; end;

procedure scroll;
var postab : array[0..79,0..7] of word; bitmap : array[0..79,0..7] of byte;
  sctr,tctr,curchar,l,b,x,y : byte;
begin
  fillchar(postab,sizeof(postab),0);
  fillchar(bitmap,sizeof(bitmap),0);
  sctr := 0; tctr := 1;
  repeat
    curchar := ord(txt[tctr]); tctr := 1+tctr mod length(txt);
    for b := 0 to 7 do begin
      move(bitmap[1,0],bitmap[0,0],sizeof(bitmap));
      for l := 0 to 7 do
        if ((mem[fseg:fofs+8*curchar+l] shl b) and 128) <> 0 then
          bitmap[79,l] := 1 else bitmap[x,y] := 0;
      while (port[$3da] and 8) <> 0 do; while (port[$3da] and 8) = 0 do;
      for x := 0 to 79 do for y := 0 to 7 do mem[vseg:postab[x,y]] := 32;
      for x := 0 to 79 do for y := 0 to 7 do begin
        postab[x,y] := (y+(stab[(sctr+x) mod slen] div 8))*160+x+x;
        if bitmap[x,y] = 1 then mem[vseg:postab[x,y]] := 128+stab[(sctr+x) mod slen] mod 8;
      end;
      sctr := (sctr+sspd) mod slen;
    end;
  until keypressed;
end;

begin
  initialize;
  getfont8x8;
  generatetab;
  scroll;
  textmode(lastmode);
end.
