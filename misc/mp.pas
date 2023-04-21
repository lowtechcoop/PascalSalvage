{*      MPLAY.PAS
 *
 * Minimal Protracker module player using MIDAS Sound System
 *
 * Copyright 1995 Petteri Kangaslampi and Jarno Paananen
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*}


uses crt,midas, mfile, mplayer, modp, errors, mconfig;


{****************************************************************************\
*
* Function:     toASCIIZ(dest : PChar; str : string) : PChar;
*
* Description:  Converts a string to ASCIIZ format. (StrPCopy is NOT available
*               in real mode!)
*
* Input:        msg : string            string to be converted
*               dest : PChar            destination buffer
*
* Returns:      Pointer to the converted string;
*
\****************************************************************************}

function toASCIIZ(dest : PChar; str : string) : PChar;
var
    spos, slen : integer;
    i : integer;

begin
    spos := 0;                          { string position = 0 }
    slen := ord(str[0]);                { string length }

    { copy string to ASCIIZ conversion buffer: }
    while spos < slen do
    begin
        dest[spos] := str[spos+1];
        spos := spos + 1;
    end;

    dest[spos] := chr(0);               { put terminating 0 to end of string }

    toASCIIZ := dest;
end;




var
    module : PmpModule;
    i, error, isConfig : integer;
    str : array [0..256] of char;


{Maybe you must change the ports a bit, the second number isn't always 2}
const resetport = $226;
      datareadyport = $22E;
      readdataport = $22A;
      wbsport = $22C;
      writeport = $22C;

procedure wait;
begin
     delay(10);
end;

procedure writedsp(data : byte);assembler;
asm
   mov dx,wbsport
@loop:
   in al,dx
   test al,1 shl 7
   jnz @loop
   mov al,data
   out dx,al
end;

function readdsp : byte;assembler;
asm
   mov dx,datareadyport
@loop:
   in al,dx
   test al,1 shl 7
   jz @loop
   mov dx,readdataport
   in al,dx
end;

function readsound : byte;
begin
     writedsp($20);
     readsound := readdsp;
end;

procedure resetsb;assembler;
asm
   mov dx,resetport
   mov al,1
   out dx,al
   call wait
   mov dx,resetport
   xor al,al
   out dx,al
   mov dx,datareadyport
@loop:
   in al,dx
   test al,1 shl 7
   jz @loop
   mov dx,readdataport
   in al,dx
   call readsound
end;

var x : word;
    y : byte;
    oldy : array[0..319] of byte;

BEGIN
   resetsb;
    { Check that there is only one argument - the file name: }
    if ParamCount <> 1 then
    begin
        WriteLn('Usage:  MPLAY   <filename>');
        Halt;
    end;

    { Check that the configuration file exists: }
    error := fileExists('MIDAS.CFG', @isConfig);
    if error <> OK then
        midasError(error);
    if isConfig <> 1 then
    begin
        WriteLn('Configuration file not found - run MSETUP.EXE');
        Halt;
    end;

    midasSetDefaults;                   { set MIDAS defaults }
    midasLoadConfig('MIDAS.CFG');       { load configuration }
    midasInit;                          { initialize MIDAS Sound System }

    { Convert command line argument to ASCIIZ and load module: }
    toASCIIZ(str, ParamStr(1));
    module := midasLoadModule(str, @mpMOD, NIL);

    midasPlayModule(module, 0);         { start playing }


   asm mov ax,13h;int 10h; end;
repeat
    mem[$A000:x+oldy[x]*320] := 0;
      y := 100+(readsound-127) div 2;
      mem[$A000:x+y*320] := 9;
      oldy[x] := y;
      x := (x+1) mod 320;
until keypressed;


    midasStopModule(module);            { stop playing }
    midasFreeModule(module);            { deallocate module }
    midasClose;                         { uninitialize MIDAS }
END.
