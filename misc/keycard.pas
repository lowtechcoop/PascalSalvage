unit keycard;

INTERFACE
uses crt;

procedure card_in;
procedure card_out;
procedure atm_mach;
procedure reset_side;

implementation

procedure card_out;

Const Dly = 200;

 var
 x:integer;
    begin
    Window (67, 7,76,12);
    Write ('읕嘗컴컴켸');
    Write ('께께께께께');
    Write ('께께께께께');
    Write ('께께께께께');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);
    (* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)
    Window (67, 7,76,12);
    Write ('� �      �');
    Write ('읕嘗컴컴켸');
    Write ('께께께께께');
    Write ('께께께께께');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);
    (* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)
    Window (67, 7,76,12);
    Write ('� �      �');
    Write ('� �      �');
    Write ('읕嘗컴컴켸');
    Write ('께께께께께');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);
 (*-----------------------------------------*)
    Window (67, 7,76,12);
    Write ('� �      �');
    Write ('� �      �');
    Write ('� �      �');
    Write ('읕嘗컴컴켸');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);

    Window (67, 7,76,12);
    Write ('� �      �');
    Write ('� �      �');
    Write ('� �      �');
    Write ('읕嘗컴컴켸');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);
  (*------------------------------------------------------------*)
    Window (67, 7,76,12);
    Write ('� � KEY  �');
    Write ('� �      �');
    Write ('� �      �');
    Write ('� �      �');
    Write ('읕嘗컴컴켸');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);
    (* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)
   Window (67,7,76,12);
    Write ('旼寶컴컴커');
    Write ('� � KEY  �');
    Write ('� �      �');
    Write ('� �      �');
    Write ('� �      �');
    Window (67,12,77,12);
    Write ('읕嘗컴컴켸');
    Delay (dly*3);
  (* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)
    Window (67, 7,76,12);
    Write ('袴袴袴袴袴');
    Write ('께께께께께');
    Write ('께께께께께');
    Write ('께께께께께');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly*3);
  End;

procedure atm_mach;
 begin
    clrscr;
    Window (63,2,80,17);
    textcolor (yellow);
    clrscr;
    Write ('께께께께께께께께께');
    Write ('꾑컴컴컴컴컴컴컴럴');
    Write ('꾄컴컴컴컴컴컴컴쉿');
    Write ('께께께께께께께께께');
    Write ('께꾐袴袴袴袴袴림께');
    Write ('께꾈袴袴袴袴袴쓰께');
    Write ('께께께께께께께께께');
    Write ('께께께께께께께께께');
    Write ('께께께께께께께께께');
    Write ('께께께께께께께께께');
    Write ('께께께께께께께께께');
    Write ('께께께께께께께께께');
    Write ('꾑컴컴컴컴컴컴컴럴');
    Write ('꾄컴컴컴컴컴컴컴쉿');
    Write ('께께께께께께께께께');
  end;

procedure card_in;

const
dly = 200;

  Begin
    Window (67,7,76,12);
    Write ('旼寶컴컴커');
    Write ('� � KEY  �');
    Write ('� �      �');
    Write ('� �      �');
    Write ('� �      �');
    Window (67,12,77,12);
    Write ('읕嘗컴컴켸');
    Delay (dly*3);
    (* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)
    Window (67, 7,76,12);
    Write ('� � KEY  �');
    Write ('� �      �');
    Write ('� �      �');
    Write ('� �      �');
    Write ('읕嘗컴컴켸');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);
    (* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)
    Window (67, 7,76,12);
    Write ('� �      �');
    Write ('� �      �');
    Write ('� �      �');
    Write ('읕嘗컴컴켸');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);
    (* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)
    Window (67, 7,76,12);
    Write ('� �      �');
    Write ('� �      �');
    Write ('읕嘗컴컴켸');
    Write ('께께께께께');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);
    (* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)
    Window (67, 7,76,12);
    Write ('� �      �');
    Write ('읕嘗컴컴켸');
    Write ('께께께께께');
    Write ('께께께께께');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);
    (* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)
    Window (67, 7,76,12);
    Write ('읕嘗컴컴켸');
    Write ('께께께께께');
    Write ('께께께께께');
    Write ('께께께께께');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
    Delay (dly);
    (* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)
    Window (67, 7,76,12);
    Write ('袴袴袴袴袴');
    Write ('께께께께께');
    Write ('께께께께께');
    Write ('께께께께께');
    Write ('께께께께께');
    Window (67,12,77,12);
    Write ('께께께께께');
  End;

  Procedure Reset_side;
  Begin
    Window (63,2,80,17);
    Clrscr;
    Write ('께께께께께께께께께');
    Write ('꾑컴컴컴컴컴컴컴럴');
    Write ('꾄컴컴컴컴컴컴컴쉿');
    Write ('께께께께께께께께께');
    Write ('께꾐袴袴袴袴袴림께');
    Write ('께꾈袴袴袴袴袴쓰께');
    Write ('께께께께께께께께께');
    Write ('께께께께께께께께께');
    Write ('께께께께께께께께께');
    Write ('께께께께께께께께께');
    Write ('께께께께께께께께께');
    Write ('께께께께께께께께께');
    Write ('꾑컴컴컴컴컴컴컴럴');
    Write ('꾄컴컴컴컴컴컴컴쉿');
    Write ('께께께께께께께께께');
  End;

  end.
