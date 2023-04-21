Unit Menunit;


Interface

Type
  AttrStr       = Record                                       {for MenuBars}
                    len,
                    X, Y   : Byte;
                    Attrs : Array [1..80] Of Byte;
                  End;

var
  VBase: Word;
  Ascii,
  ScanCode      : Char;

Const
        CuUp                                        = #72;
        CuDn                                        =        #80;
        CuLe                                        = #75;
        Ctrl_CuLe                        = #115;
        CuRi                                        = #77;
        Ctrl_CuRi                        = #116;
        Home                                        = #71;
        Ctrl_Home                        = #119;
        EndKey                                = #79;
        Ctrl_End                        = #117;
        PgUp                                        = #73;
        Ctrl_PgUp                        = #132;
        PgDn                                        = #81;
        Ctrl_PgDn                        = #118;
        BELL                                        = #7;
        BS                                                = #8;
        TB                                                = #9;
        Shift_TB                        = #15;
        LF                                                = #10;
        FF                                                = #12;
        CR                                                = #13;
        FEND                                        = #26;
        ESC                                                = #27;
        SCR                                                = #141;
        DEL                                                = #83;
        SPACE                                        = #32;
        NULL                                        = #0;
        INS                                                = #82;

{
Show a MenuBar at pos x,y with length Len and colors Attr
}
Procedure ShowMenuBar (X, Y, len, Attr: Byte; Var s: AttrStr);

{
Hide the MenuBar (must be first defined with ShowMenuBar
}
Procedure HideMenuBar (Var s: AttrStr);

{
A simple menu-example you always could use
}
Function Menu (X1, Y1, X2, Y2, BarAttr: Byte): Byte;

Implementation

Function ReadProc (X, Y : Word) : Word; Assembler;
Asm
  Dec   X
  Dec   Y
  mov   AX, Y
  mov   CL, 5
  ShL   AX, CL
  mov   SI, AX
  mov   CL, 2
  ShL   AX, CL
  add   SI, AX
  ShL   X, 1
  add   SI, X

  mov   AX, VBase
  push  DS
  mov   DS, AX
  lodsw
  pop   DS
End;

Function ScreenAttr (X, Y: Byte): Byte;
Begin
  ScreenAttr := Hi (ReadProc (X, Y) );
End;

Procedure WriteAttr (Attr, X, Y, n, Step: Byte);
Var
  t      : Byte;
  Ofset : Word;
Begin
  If (X >= 0) And (Y >= 0) Then
  Begin
    X := X - 1; Y := Y - 1;
  End;
  Ofset := (Y * 80 + X) ShL 1 + 1;
  For t := 1 To n Do
  Begin
    Move (Attr, Ptr (VBase, OfSet)^, 1);
    Inc (Ofset, Step);
  End;
End;

Procedure ShowMenuBar (X, Y, len, Attr: Byte; Var s: AttrStr);
Var
  i: Integer;
Begin
  s. len := len;
  s. X  := X;
  s. Y  := Y;
  For i := X To X + len Do s. Attrs [i] := ScreenAttr (i, Y);
  WriteAttr (Attr, X, Y, len, 2);
End;

Function Key: Word; Assembler;
Asm
  @001:
  Int  28h
  mov  AH, 01h
  Int  16h
  jz   @001
  XOr  AH, AH
  Int  16h
End;

Procedure KeyIn; Assembler;
Asm
  Call Key
  mov Scancode, AH
  Or  AL, AL
  jz  @001
  @001:
  mov Ascii, AL
End;

Procedure HideMenuBar (Var s: AttrStr);
Var
  i: Integer;
Begin
  With s Do
  Begin
    For i := X To X + len Do WriteAttr (Attrs [i], i, Y, 1, 2);
  End;
End;

Function VideoBase: Word;
Var
  Base : Byte;
Begin
  Asm
    Int 11h
    mov base, AL
  End;
  If (base And 48) = 48 Then VideoBase := $B000                              
{Mono}
  Else VideoBase := $B800;                                             
     {Kleur}
End;


Function Menu (X1, Y1, X2, Y2, BarAttr: Byte): Byte;
Var
  row  : Integer;
  done : Boolean;
  Bar  : AttrStr;
Begin
  Row := Y1;
  done := False;
  Repeat
    ShowMenuBar (X1, Row, X2 - X1, BarAttr, Bar);
    KeyIn;
    HideMenuBar (Bar);
    If Ascii = #0 Then
    Begin
      Case Scancode Of
        CuUp  : If row > Y1 Then Dec (row) Else row := Y2;
        CuDn  : If row = Y2 Then row := Y1 Else Inc (row);
        Home  : row := Y1;
        EndKey: row := Y2;
      End;
    End
    Else
    Begin
      Case AScii Of
        Cr : Begin menu := Succ(row - Y1); done := True End;
        Esc: Begin menu := 0; done := True; End;
      End;
    End
  Until Done;
End;

{Unit Initialization}
Begin
   VBase := VideoBase;
End.
