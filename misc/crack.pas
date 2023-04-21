{ Example for Keep }
{modded for hacking progs - BH - DBS 11-3-98}

{$M $800,0,0 }   { 2K stack, no heap }
uses Crt, Dos;
var
  timerintVec : Procedure;
{$F+}
procedure Timer; interrupt;
begin
  {call int 21 to reset time to 12:00  18.2 times/s but prob not}
  asm
    mov ah,2d
    mov ch,0
    mov cl,0
    mov dh,0
    mov dl,0
    int 21
  end;
  inline ($9C); { PUSHF -- Push flags }
  { Call old ISR using saved vector }
  timerintVec; {dont think so!!!}
end;
{$F-}
begin
  { Insert ISR into keyboard chain }
  GetIntVec($1c,@timerIntVec);
  SetIntVec($1c,Addr(Timer));
  Keep(0); { Terminate, stay resident }
end.