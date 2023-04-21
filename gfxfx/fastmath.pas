
unit fastmath;
{ approximatly-20%-faster-sin-cos-and-other-giometrical-stuff unit }
{ made by Bas van Gaalen, Holland, PD }
{ uh, not finished... }

interface

const divd = 1024;

{ input: 0 <= arc <= 359, output: -divs <= sinus(arc) <= divd }
function sinus(_arc : word) : integer;

{ input: 0 <= arc <= 359, output: -divs <= cosin(arc) <= divd }
function cosin(_arc : word) : integer;

implementation

type stype = array[0..359] of integer;
var stab : stype;

procedure calcsin(var st : stype); var i : word; begin
  for i := 0 to 359 do st[i] := round(sin(2*pi*i/360)*divd); end;

function sinus(_arc : word) : integer; begin
  sinus := stab[_arc]; end;

function cosin(_arc : word) : integer; begin
  cosin := stab[(_arc+90) mod 360]; end;

begin
  calcsin(stab);
end.
