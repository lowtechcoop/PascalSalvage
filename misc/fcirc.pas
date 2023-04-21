{$A+,R-,S-,N-,L-,O-,D-,X+,G+,F+}
uses crt;

var cir,red :word;
       col:word;
    FgColor:integer;
    f:LongInt;
Const
        _Hollow = 0;        _Filled = 1;

Var
        Segment : Word;
   Ch : Char;

Procedure ACircle(Control, X, Y, Radius, Color : Word); Assembler;
        Asm
           MOV AX, Segment
      MOV ES, AX
      MOV SI, Radius             { XI := R }
      MOV DI, 0      { YI := 0 }
      MOV CX, Radius
      SHR CX, 1      { N := XI Div 2 }
      MOV AX, Control
      CMP AX, 1
      JE @Filled

@Hollow:

      @Loope:
                        {putpix}
                   MOV BX, 320
                   MOV AX, Y
         SUB AX, DI
                   MUL BX
                   MOV BX, AX
                   ADD BX, X
         SUB BX, SI
         MOV DX, Color
         MOV ES:[BX], DL
                   MOV BX, 320
                   MOV AX, Y
         SUB AX, SI
                   MUL BX
                   MOV BX, AX
                   ADD BX, X
         SUB BX, DI
         MOV DX, Color
         MOV ES:[BX], DL
                   MOV BX, 320
                   MOV AX, Y
         SUB AX, DI
                   MUL BX
                   MOV BX, AX
                   ADD BX, X
         ADD BX, SI
         MOV DX, Color
         MOV ES:[BX], DL
                   MOV BX, 320
                   MOV AX, Y
         SUB AX, SI
                   MUL BX
                   MOV BX, AX
                   ADD BX, X
         ADD BX, DI
         MOV DX, Color
         MOV ES:[BX], DL
                   MOV BX, 320
                   MOV AX, Y
         ADD AX, DI
                   MUL BX
                   MOV BX, AX
                   ADD BX, X
         SUB BX, SI
         MOV DX, Color
         MOV ES:[BX], DL
                   MOV BX, 320
                   MOV AX, Y
         ADD AX, SI
                   MUL BX
                   MOV BX, AX
                   ADD BX, X
         SUB BX, DI
         MOV DX, Color
         MOV ES:[BX], DL
                   MOV BX, 320
                   MOV AX, Y
         ADD AX, DI
                   MUL BX
                   MOV BX, AX
                   ADD BX, X
         ADD BX, SI
         MOV DX, Color
         MOV ES:[BX], DL
                   MOV BX, 320
                   MOV AX, Y
         ADD AX, SI
                   MUL BX
                   MOV BX, AX
                   ADD BX, X
         ADD BX, DI
         MOV DX, Color
         MOV ES:[BX], DL
                        {putpix}
         ADD CX, DI  { N := N + YI }
         CMP CX, SI  { If N > XI Then }
         JNG @Skip   { Do This }
           DEC SI            { XI := XI - 1 }
           SUB CX, SI        { N := N - XI }
         @Skip:
         INC DI      { YI := YI + 1 }
      CMP DI, SI
      JNG @Loope
      JMP @End

@Filled:

      @Loopeb:
                        {putpix}
                   MOV BX, 320
                   MOV AX, Y
         SUB AX, DI
                   MUL BX
                   MOV BX, AX
                   ADD BX, X
         SUB BX, SI
         MOV DX, CX           { Part 2 }
         XCHG BX, DI
         MOV AX, Color
         MOV CX, SI
                        SHL CX, 1
         inc cx
                        REP STOSB
         MOV DI, BX
         MOV CX, DX

                   MOV BX, 320
                   MOV AX, Y
         ADD AX, DI
                   MUL BX
                   MOV BX, AX
                   ADD BX, X
         SUB BX, SI
         MOV DX, CX           { Part 3 }
         XCHG BX, DI
         MOV AX, Color
         MOV CX, SI
                        SHL CX, 1
         inc cx
                        REP STOSB
         MOV DI, BX
         MOV CX, DX
                        {putpix}
         ADD CX, DI  { N := N + YI }
         CMP CX, SI  { If N > XI Then }
         JNG @Skipb   { Do This }
           DEC SI            { XI := XI - 1 }
           SUB CX, SI        { N := N - XI }
                                {putpix}
                           MOV BX, 320
                           MOV AX, Y
                 SUB AX, SI
            dec ax
                           MUL BX
                           MOV BX, AX
                           ADD BX, X
                 SUB BX, DI
                 MOV DX, CX        { Part 1 }
                 MOV AX, Color
                 MOV CX, DI
                                SHL CX, 1
            inc cx
                 XCHG BX, DI
                                REP STOSB
                 MOV DI, BX
                 MOV CX, DX

                           MOV BX, 320
                           MOV AX, Y
                 ADD AX, SI
            inc ax
                           MUL BX
                           MOV BX, AX
                           ADD BX, X
                 SUB BX, DI
                 MOV DX, CX
                 MOV AX, Color         { Part 4 }
                 MOV CX, DI
                                SHL CX, 1
            inc cx
                 XCHG BX, DI
                                REP STOSB
                 MOV DI, BX
                 MOV CX, DX
                                {putpix}
         @Skipb:
         INC DI      { YI := YI + 1 }
      CMP DI, SI
      JNG @Loopeb

      @End:
   End;

procedure pset(x,y:word;col:byte); assembler;
asm
 mov ah,$c
 xor bh,bh
 mov al,[col]
 mov cx,[x]
 mov dx,[y]
 int $10
end;

procedure pale;

Begin
     Red:=0;

     Repeat;
       repeat
       f:=f+1;
       until f=400;
       f:=0;
       Red:=Red+1;
       col:=col+1;
       if col>254 then col:=1;
       port[$3c8]:=col;
       port[$3c9]:=red;
       port[$3c9]:=0;
       port[$3c9]:=red;
     until red=62;
end;

Procedure Circle (x_center, y_center, radius : Integer);
{ Draw a circle with center (x_center,y_center) and radius 'radius' }
Var
  x, y, d : Integer;

Begin
  { bressenham circle algorithm using integer-only arithmetic }
  x:=0; y:=radius; d:=2*(1-radius);
  While y>=0 Do Begin
    pset (x_center+x,y_center+y,FgColor);
    pset (x_center+x,y_center-y,FgColor);
    pset (x_center-x,y_center+y,FgColor);
    pset (x_center-x,y_center-y,FgColor);
    If d + y > 0 then Begin
      Dec (y);
      Dec (d,2*y+1);
    End;
    If x > d then Begin
      Inc (x);
      Inc (d,2*x+1);
    End;
  End;
End;
procedure circ;
begin
  repeat;
  col:=col+1;
    if col>255 then col:=1;
    cir:=cir+1;
    FgColor:=col;
    ACircle(_Hollow,160,100,cir,col);
  until cir>100;

end;

function setscreenmode(mode:byte):boolean; assembler;
asm
 mov al,[mode]
 xor ah,ah
 int $10
 mov ah,$f
 int $10
 cmp al,[mode]
 je @itworked
 xor al,al
 jmp @end
@itworked:
 mov al,1
@end:
end;


begin
Segment := $A000;
setscreenmode($13);
circ;
repeat;
pale;
until keypressed=true;
setscreenmode($3);
end.