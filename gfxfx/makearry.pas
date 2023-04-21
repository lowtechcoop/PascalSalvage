
program MakeArrayFromBintable;
{ you know the drill... }
uses
  crt,dos;

var
  InFile : file of byte;
  OutFile : text;
  FileName : pathstr;
  I,Size,TotalSize : longint;
  J : word;
  InByte,Len : byte;

function ValLen(Num : byte) : byte; begin
  if Num <> 0 then ValLen := round(ln(Num)/2.303)+1 else ValLen := 1; end;

begin
  writeln;
  if paramstr(1) = '' then begin
    write('Enter Filename: ');
    readln(FileName);
  end else FileName := paramstr(1);

  assign(InFile,FileName);
  reset(InFile);
  seek(InFile,$20); { <-- Put filepointer after mess-header! }
  Size := filesize(InFile);
  assign(OutFile,'ARRAY.INC');
  rewrite(OutFile);
  writeln(OutFile,'  PicArray : array[0..TotalSize] of byte = (');
  write(OutFile,'    ');
  TotalSize := 0; I := 0; Len := 4;
  while not eof(InFile) do begin
    read(InFile,InByte);
    write(OutFile,InByte,',');
    inc(Len,ValLen(InByte)+1);
    inc(TotalSize);

    if InByte = 0 then begin
      J := 1;
      inc(I);
      read(InFile,InByte);
      while (InByte = 0) and (not eof(InFile)) do begin
        inc(J);
        inc(I);
        read(InFile,InByte);
      end;
      write(OutFile,lo(J),',',hi(J),',');
      inc(Len,ValLen(lo(J))+ValLen(hi(J))+2);
      inc(TotalSize,2);
      if InByte <> 0 then begin
        write(OutFile,InByte,',');
        inc(Len,ValLen(InByte)+1);
        inc(TotalSize);
      end;
    end;

    if Len > 75 then begin
      writeln(OutFile);
      write(OutFile,'    ');
      Len := 4;
    end;
    inc(I); write(#13,Size-I:6);
  end;
  writeln(OutFile,');');
  writeln(OutFile);
  writeln(OutFile,'  TotalSize = ',TotalSize-1,';');
  close(InFile); close(OutFile);
  writeln;
end.
