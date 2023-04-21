Program Display_Ansi__Scroll_80_25;

USES CRT;

TYPE BufferType = Array[0..63999] of Byte;
     Line       = Array[1..160] of Byte;

CONST LinesToDisplay = 20;   { Must be <= 25                     }
      MinY           = 0;    { Must be >= 0                      }
      MaxY           = 158;  { Must be <= the length of the ansi }
      StartDisplay   = 5;    { Must be >= 1 & <= 24 depending on }
                             { LinesToDisplay.                   }
VAR Buffer : ^BufferType;                            { Buffer for ansi     }
    Ch     : Char;                                   { inputted key        }
    Y      : Integer;                                { display from line Y }
    Screen : Array [1..25] Of Line Absolute $B800:0; { 25 lines of 160     }
                                                     { bytes each          }
{$L Ansi.OBJ}                                        { Linking the obj     }
Procedure Ansi; External;                            { into the  prog.     }

Procedure Showcursor; Assembler;
          Asm
          mov ax,0100h
          mov cx,0506h
          int 10h
          End;

Procedure Hidecursor; Assembler;
          Asm
          mov ax,0100h
          mov cx,02607h
          int 10h
          End;

Procedure Flushbuffer; Assembler;
          Asm
          mov ax, $0C00;
          int 21h;
          end;

Procedure GetKey(Var Ch : Char);
          Begin
          Ch := #0;
          Repeat
                Ch := readkey;
          Until (Ch <> #0);
          End;

Procedure Key2Dir(Var Y : Integer;
                  Var Ch: Char);
          Begin
{up}      If (Ch = #72) and (Y > MinY) then
             Begin
             dec(y);
             End;
{down}    If (Ch = #80) and (Y < MaxY - LinesToDisplay) then
             Begin
             inc(y);
             End;
{pgup}    If (Ch = #73) then begin
           if ((Y - LinesToDisplay) >= 1) then
             Begin
             y := y - LinesToDisplay;
             End
           else
             begin
             y := miny;
             end;
           end;
{pgdown}  If (Ch = #81) then begin
           if ((Y + (2 * LinesToDisplay)) < MaxY) then
             Begin
             y := y + LinesToDisplay;
             End
           else
             begin
             y := maxy - LinesToDisplay;
             end;
          end;
{home}    If (Ch = #71) and (Y > MinY) then
             Begin
             y := miny;
             End;
{end}     If (Ch = #79) and (Y < MaxY) then
             Begin
             y := maxy - LinesToDisplay;
             End;
End;

Procedure PercentageBar(Y : Word);
VAR
   Percent  : Integer;
   Offset   : Integer;
   Bars     : Integer;
   Counter  : Integer;
            Begin
               Percent := (Round((Y + LinesToDisplay) / MaxY * 100));
               Bars := Trunc(Percent * 0.10);
               gotoxy(1,25);
               textcolor(8);
               Write('[');
               For Counter := 1 to Bars Do
               Begin
                    textcolor(9);
                    Write('²');
               End;
               Offset := Percent - (Bars * 10);
               If Offset >= 5 Then
               Begin
                    textcolor(1);
                    Write('±');
                    Bars := Bars + 1;
               End;
               For Counter := Bars to 9 Do
               Begin
                    textcolor(8);
                    Write('°');
               End;
               textcolor(8);
               Write('] ');
               textcolor(15);
               Write(Percent, '%  ');
          End;

Procedure Display_80_25(Y, Y2 : Word);
          Begin
               If (Y2 <= 25) And (Y >= 0) Then
               Begin
                    Move(Buffer^[Y*160],Screen[StartDisplay],Y2*160);
               End;
          End;

Begin
   Y := 0;
   Clrscr;
   Hidecursor;
   New(Buffer);
   Buffer:=@Ansi;
   Display_80_25(Y,LinesToDisplay);

   Repeat
   Percentagebar(Y);
   Flushbuffer;
   GetKey(Ch);
   Key2Dir(Y, Ch);

   Display_80_25(Y,LinesToDisplay);

   Until (Ch = #27);
   Showcursor;
   Clrscr;
End.

{i know it's long... but it wirks... anyone with a shorter one that works
 this well, email it to me at purp0@juno.com}
