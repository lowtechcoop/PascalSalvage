{$A+,R-,S-,N-,L-,O-,D-,X+,G+}
uses graphics, crt;

var x,col,red :integer;

procedure circ;
begin
for x:=1 to 300 do;
    begin
    col:=col+1;
    FgColor:=col;
    circle(160,100,x);
    end;
end;




begin
setcrtmode($13);
circ;
setcrtmode($3);
end.