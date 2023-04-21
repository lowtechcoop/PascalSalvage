
{$M $800, 0, 3000}
uses crt, dos;

const trail_len = 10;              {length of spark trail in pixels}
const num_sparks = 20;             {number of sparks per explosion}
const num_frames = 70;             {length of explosion}
type Tspark = record
   x      : longint;
   y      : longint;
   dirx   : integer;
   diry   : integer;
   points : array[1..trail_len,0..1] of longint;
   head   : byte;
end;

var spark  : array[1..num_sparks] of Tspark;
    frames : word;
    screen_buf : array[0..2000] of byte;
var Int1CSave : Pointer;

procedure init_spark(initx, inity : integer);
var i,j : byte;
begin
   for i:=1 to num_sparks do
   begin
      frames := num_frames;
      spark[i].head := 1;
      spark[i].x:=initx; spark[i].y:=inity;
      spark[i].dirx := integer(random(512))-256;
      spark[i].diry := integer(random(255))-128;
      for j:=1 to trail_len do
      begin
         spark[i].points[j,0] := initx shr 8;
         spark[i].points[j,1] := inity shr 8;
      end;
   end;
end;

procedure spark_frame;
var i,j,x1,y1 : longint;
begin
   dec(frames);
   if(frames = 0) then init_spark(random(80) shl 8, random(25) shl 8);

   for i:=1 to num_sparks do
   with spark[i] do
   begin
      {erase tail}
      j := head+1;
      if(j>trail_len) then j := 1;
      x1 := points[j,0];
      y1 := points[j,1];
      if(x1>0) and (x1<80) and
        (y1>0) and (y1<25) then screen_buf[y1*80 + x1] := 7;

      {move head pointer}
      inc(head);
      if(head > trail_len) then head := 1;

      {work out new spark posistion}
      x := x + dirx;
      y := y + diry;
      diry := diry + 10;
      points[head,0] := x shr 8;
      points[head,1] := y shr 8;

      {draw spark trail}
      j:=head-1;
      if(j<1) then j:=trail_len;
      x1 := points[j,0];
      y1 := points[j,1];
      if(x1>0) and (x1<80) and
        (y1>0) and (y1<25) then screen_buf[y1*80 + x1] := 16+7;

      {draw spark head}
      j:=head;
      x1 := points[j,0];
      y1 := points[j,1];
      if(x1>0) and (x1<80) and
        (y1>0) and (y1<25) then screen_buf[y1*80 + x1] := 48+7;
   end;

   asm
      mov ax, $B800
      mov es, ax
      mov di, 1
      mov cx, 2000
      mov si, offset screen_buf
    @@L0:
      mov al, [si]
      mov [es:di], al
      inc si
      add di, 2
      loop @@L0
   end; {dump buffer to screen}
end;


{$F+,S-,W-}
procedure TimerHandler; interrupt;
  begin
    { Timer ISR }
    spark_frame;
  end;
{$F-,S+}

var i : word;
begin
   {clrscr;}
   for i:=0 to 2000 do screen_buf[i] := 7;

   init_spark(40 shl 8, 10 shl 8);

   GetIntVec($1C,Int1CSave);
   SetIntVec($1C,Addr(TimerHandler));
   keep(0);
end.


... If a man says something in a forest, and there are no women around
... to hear him, is he still wrong?
___ Blue Wave/386 v2.30 [NR]
-!- Platinum Xpress/Win/Wildcat5! v2.0GI
 ! Origin: WELCOM BBS (3:771/370)  
