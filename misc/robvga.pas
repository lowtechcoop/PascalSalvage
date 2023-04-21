unit RobVGA;

interface

const
   Black=0;
   Blue=1;
   Green=2;
   Cyan=3;
   Red=4;
   Magenta=5;
   Brown=6;
   LightGray=7;
   DarkGray=8;
   LightBlue=9;
   LightGreen=10;
   LightCyan=11;
   LightRed=12;
   LightMagenta=13;
   Yellow=14;
   White=15;
   MaxX=319;
   MaxY=199;
   MaxColor=255;
   EmptyFill=0;
   SolidFill=1;

procedure VGAMode;
procedure ClearGraph;
procedure TextMode;
procedure putpixel(x,y:word; c:byte);
function  getpixel(x,y:word):byte;
procedure Box(x1,y1,x2,y2,c,Style:integer);
procedure Line(x1, y1, x2, y2, c : integer);
procedure Circle(x_center, y_center, radius, Color : Integer);
procedure Diamond(x_center, y_center, radius, Color : Integer);
procedure BackGround(c:byte);
procedure palette(c,r,g,b:byte);
procedure loadPCX(filename:string);

implementation

procedure VGAMode; assembler; asm
  mov ah,0; mov al,13h; int 10h; end;

procedure ClearGraph; assembler; asm
  mov ah,0; mov al,13h; int 10h; end;

procedure TextMode; assembler; asm
  mov ah,0; mov al,3; int 10h; end;

procedure PutPixel(x,y:word; c:byte);
begin
  if (x<0) or (x>319) or (y<0) or (y>199) then exit;
  asm
    mov ax,-24576; mov es,ax; mov ax,y; mov dx,320; mul dx
    mov di,ax; add di,x; mov al,c; mov [es:di],al end;
end;

procedure Line(x1, y1, x2, y2, c : integer);
var
  count : integer;
begin
  if (x1<x2) and (y1=y2) then
  begin
     for count:= x1 to x2 do
     begin
       PutPixel(count, y1, c);    { Straight line left to right }
     end;
     exit;
  end;
  if (y1<y2) and (x1=x2) then
  begin
     for count:= y1 to y2 do
     begin
       PutPixel(x1, count, c);    { Straight line top to bottom }
     end;
     exit;
  end;
  if (x1>x2) and (y1=y2) then
  begin
     for count:= x2 to x1 do
     begin
       PutPixel(count, y1, c);    { Straight line right to left }
     end;
     exit;
  end;
  if (y1>y2) and (x1=x2) then
  begin
     for count:= y2 to y1 do
     begin
       PutPixel(x1 ,count, c);    { Straight line bottom to top }
     end;
     exit;
  end;
end;

procedure Circle(x_center, y_center, radius, Color : Integer);
var
  x, y, d : Integer;
begin
  x:=0; y:=radius; d:=2*(1-radius);
  While y>=0 do begin
    PutPixel(x_center+x,y_center+y,Color);
    PutPixel(x_center+x,y_center-y,Color);
    PutPixel(x_center-x,y_center+y,Color);
    PutPixel(x_center-x,y_center-y,Color);
    if d +y > 0 then begin
      dec (y);
      dec (d,2*y+1);
    end;
    if x > d then begin
      inc (x);
      inc (d,2*x+1);
    end;
  end;
end;

procedure Diamond(x_center, y_center, radius, Color : Integer);
var
  x, y, d : integer;
begin
  x:=0; y:=radius; d:=2*(1-radius);
  While y>=0 Do Begin
    PutPixel(x_center+x,y_center+y,Color);
    PutPixel(x_center+x,y_center-y,Color);
    PutPixel(x_center-x,y_center+y,Color);
    PutPixel(x_center-x,y_center-y,Color);
    if d +y > 0 then begin
      dec (y);
      dec (d,4*y+1);
    end;
    if x > d then begin
      inc (x);
      inc (d,1*y+1);
    end;
  end;
end;

function GetPixel(x,y:word):byte; assembler; asm
  mov ax,-24576; mov es,ax; mov ax,y; mov dx,320; mul dx
  mov di,ax; add di,x; mov al,[es:di] end;

procedure Box(x1,y1,x2,y2,c,Style:integer);
var
  x,y,x3,y3:integer;
label
  EmptyFill,SolidFill;
begin
  case style of
    0 : goto EmptyFill;
    1 : goto SolidFill;
  end;
  exit;
  EmptyFill:
    for x:=x1 to x2 do
    begin
      PutPixel(x,y1,c);
      PutPixel(x,y2,c);
    end;
    for y:=y1 to y2 do
    begin
      PutPixel(x1,y,c);
      PutPixel(x2,y,c);
    end;
  exit;
  SolidFill:
    for y:=y1 to y2 do
    begin
      for x:=x1 to x2 do
      begin
        PutPixel(x,y,c);
      end;
    end;
  exit;
end;

procedure BackGround(c:byte);
var
  screen: array[1..64000] of byte absolute $A000:0000; a: longint;
begin
  for a:=1 to 64000 do screen[a]:=c
end;

procedure palette(c,r,g,b:byte); assembler; asm
  mov dx,03c8h; mov al,c; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al end;

procedure loadPCX(filename:string);

  const
    gseg : word = $a000;

  type
    pcxheader = record
      manufacturer,version,encoding,bits_per_pixel : byte;
      xmin,ymin,xmax,ymax,hres,vres : word;
      palette : array[0..47] of byte;
      reserved : byte;
      color_planes : byte;
      bytes_per_line : word;
      palette_type : word;
      filler : array[0..57] of byte;
    end;

  var
    pcxfile : file;
    header : pcxheader;

    function validpcx : boolean;
    begin
      seek(pcxfile,0);
      blockread(pcxfile,header,sizeof(header));
      with header do validpcx := (manufacturer = 10) and (version = 5) and
        (bits_per_pixel = 8) and (color_planes = 1);
    end;

    function validpal : boolean;
    var v : byte;
    begin
      seek(pcxfile,filesize(pcxfile)-769);
      blockread(pcxfile,v,1);
      validpal := v = $0c;
    end;

    procedure setpal;
    var pal : array[0..767] of byte;
    begin
      seek(pcxfile,filesize(pcxfile)-768);
      blockread(pcxfile,pal,768);
      asm
        cld
        xor di,di
        xor bx,bx
       @L1:
        mov dx,03c8h
        mov ax,bx
        out dx,al
        inc dx
        mov cx,3
       @L2:
        mov al,byte ptr pal[di]
        shr al,1
        shr al,1
        out dx,al
        inc di
        loop @L2
        inc bx
        cmp bx,256
        jne @L1
      end;
    end;

    procedure unpack;
    var gofs,j : word; i,k,v,loop : byte;
    begin
      seek(pcxfile,128);
      gofs := 0;
      for i := 0 to header.ymax-header.ymin+1 do begin
        j := 0;
        while j < header.bytes_per_line do begin
          blockread(pcxfile,v,1);
          if (v and 192) = 192 then begin
            loop := v and 63;
            inc(j,loop);
            blockread(pcxfile,v,1);
            for k := 1 to loop do begin
              mem[gseg:gofs] := v;
              inc(gofs);
            end;
          end
          else begin
            mem[gseg:gofs] := v;
            inc(gofs);
            inc(j);
          end;
        end;
      end;
    end;

begin
  assign(pcxfile,filename);
  reset(pcxfile,1);
  if not validpcx then halt;
  if not validpal then halt;
  setpal;
  unpack;
end;

end.