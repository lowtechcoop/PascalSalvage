{$N+}

program MakeCoSinTab;
{ Make several kinds of tables - select one, by Bas van Gaalen, Holland, PD }
uses
  crt;

const
  TabLen = 255;

var
  TabFile : text;
  Table : array[0..TabLen] of integer;

{----------------------------------------------------------------------------}

procedure SinTab;

var
  I : byte;

begin
  clrscr;
  for I := 0 to TabLen do begin
    Table[I] := round(sin((2*pi/TabLen)*I)*128);
    if I mod 20 = 19 then writeln(TabFile);
    write(TabFile,Table[I],',');
  end;
end;

{----------------------------------------------------------------------------}

procedure Globe1;

type CoorRec = record X,Y,Z : integer; end;

var
  Phi,Theta : real;
  I : word;
  X,Y,Z : integer;
  Range : byte;

{
r (of rho) : afstand tot de oorsprong, r>=0;

fi         : hoek in x-y-vlak met x-as, loopt van 0 tot pi

theta      : hoek met de z-as, loopt van 0 tot 2pi.

De cartesische coordinaten van een punt zijn dan gegeven door:

x = r * sin theta * cos fi
y = r * sin theta * sin fi
z = r * cos theta
}

begin
  randomize;
  Range := 30;
  for I := 0 to TabLen do begin
    Phi := random(3142)/1000;
    Theta := random(6283)/1000;
    X := round(Range*sin(Theta)*cos(Phi));
    Y := round(Range*sin(Theta)*sin(Phi));
    Z := round(Range*cos(Theta));

    writeln('X = ',X:4,';   Y = ',Y:4,';   Z = ',Z:4);

    if I mod 5 = 4 then writeln(TabFile);
    write(TabFile,'(',X,',',Y,',',Z,'),');
  end;
end;

{----------------------------------------------------------------------------}

procedure Globe2;

const
  R = 50;

var
  Range : real;
  A,B,C : integer;
  X,Y,Z : integer;
  I : byte;
{
A wordt random getrokken uit (-R, +R)
B wordt random getrokken uit (-R, +R)
C wordt random getrokken uit (-R, +R)

Nu ligt het punt (A, B, C) random in het inwendige van een kubus die om de
bol heen ligt.  Verbind dit punt met het middelpunt van de bol, en snij de
verbindingslijn met het oppervlakte.  Kies het snijpunt dat aan dezelfde
kant van (0, 0, 0) ligt als (A, B, C).

Afstand = wortel(A^2 + B^2 + C^2)
X = A * R / afstand
Y = B * R / afstand
Z = C * R / afstand

(X, Y, Z) ligt nu op het oppervlakte van de bol.  Niet helemaal random
overigens want punten in de buurt van de hoeken ven de kubus zijn
waarschijnlijker dan andere.  Maar ik denk dat het voor jouw doel
goed genoeg is.
}

begin
  randomize;

  for I := 0 to TabLen do begin
    A := random(2*R)-R;
    B := random(2*R)-R;
    C := random(2*R)-R;
    Range := sqrt(A*A+B*B+C*C);
    X := round(A*R/Range);
    Y := round(B*R/Range);
    Z := round(C*R/Range);

    writeln('X = ',X:4,';   Y = ',Y:4,';   Z = ',Z:4);
    if I mod 5 = 4 then writeln(TabFile);
    write(TabFile,'(',X,',',Y,',',Z,'),');
  end;
end;

{----------------------------------------------------------------------------}

procedure MakeKlok;

{ps. voor mensen met coprocessor is double of single in
 $N+ mode ALTIJD sneller omdat dat je een conversieslag
 uitspaart}

const
  size = 1.5;
  res = 25;

var
  fie,xi,yi,i : integer;
  x,y,z : real;

begin
  i := 0;
  xi := -res;
  while xi < res do begin
    yi := -res;
    while yi < res do begin
      x:=xi/res*size; y:=yi/res*size;
      z:=2*exp(-sqr(x)-sqr(y));

      writeln('x = ',round(x*50):4,';   y = ',round(y*50):4,';   z = ',round(z*50):4);
      if i mod 5 = 4 then writeln(TabFile);
      write(TabFile,'(',round(x*50),',',round(y*50),',',round(z*50),'),');

      inc(yi,4);
      inc(i);
    end;
    inc(xi,4);
  end;
  writeln;
  writeln('Number of values: ',i);
end;

{----------------------------------------------------------------------------}

procedure Parabole;

const
  Max = 125;

var
  I : real;
  J : word;

begin
  J := 0; I := -sqrt(Max);
  while I <= sqrt(Max) do begin
    writeln(round(sqr(I)));
    I := I+0.0875;
    if J mod 20 = 19 then writeln(TabFile);
    write(TabFile,round(sqr(I)),',');
    inc(J);
  end;
  writeln;
  writeln('Number of values: ',J);
end;

{----------------------------------------------------------------------------}

procedure ConvSinus;

const
  Ampl : byte = 40;

var
  Step,Divider : real;
  SinVal : word;
  I,J,X,Y : byte;

begin
  X := 1; Y := 1; Ampl := Ampl div 2;
  Step := Ampl/800; Divider := 1;
  for I := 0 to 255 do begin
    SinVal := round(((sin(8*I*pi/255)*Ampl)+Ampl)/Divider);
    Divider := Divider+Step;

    gotoxy(X,Y); write(SinVal:4);
    if wherey > 49 then begin
      inc(X,5);
      Y := 1;
    end else inc(Y);

    if J mod 20 = 19 then writeln(TabFile);
    write(TabFile,SinVal,',');
    inc(J);

  end;
  repeat until keypressed;
end;

{----------------------------------------------------------------------------}

begin
  clrscr;
  assign(TabFile,'SINTAB.DAT');
  rewrite(TabFile);
  {MakeKlok;}
  {Globe1;}
  {Parabole;}
  {ConvSinus;}
  SinTab;
  close(TabFile);
  repeat until keypressed;
end.
