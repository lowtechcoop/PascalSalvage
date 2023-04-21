uses crt;
var d,e,f:integer;

procedure testmod(a:integer);assembler;
asm;
mov dx,a
mov dx,3f8h

end;

begin
testmod(999);


end.
