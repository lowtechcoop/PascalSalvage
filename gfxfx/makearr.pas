
program MakeArrayFromBintable;
{ Convert binairy file to Pascal array (old version), by you-know-who... }
uses
  crt,dos;

var
  InFile : file of byte;
  OutFile : text;
  FileName : pathstr;
  I,Size,TotalSize : longint;
  J,reps : word;
  InByte,repbyte,Len : byte;

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
    repbyte := inbyte;

    reps := 0;
    while (inbyte = repbyte) and (not eof(infile)) do begin
      read(infile,inbyte);
      inc(reps);
    end;

    if reps = 1 then begin
      if repbyte = 0 then begin
        write(outfile,0,',',0,',',1,',',0,',');
        write(outfile,inbyte,',');
        inc(totalsize,5);
      end
      else if inbyte = 0 then begin
        write(outfile,repbyte,',');
        write(outfile,0,',',0,',',1,',',0,',');
        inc(totalsize,5);
      end
      else begin
        write(OutFile,repbyte,',',inbyte,',');
        inc(Len,ValLen(repbyte)+ValLen(inbyte)+2);
        inc(TotalSize,2);
      end;
      inc(i,2);
    end
    else if reps > 1 then begin
      write(outfile,0,',');
      write(outfile,repbyte,',');
      write(outfile,lo(reps),',',hi(reps),',');
      inc(totalsize,4);
      inc(i,reps-1);
    end;
    if Len > 75 then begin
      writeln(OutFile);
      write(OutFile,'    ');
      Len := 4;
    end;
    inc(i); write(#13,size-i:6,reps:5);
  end;
  writeln(OutFile,');');
  writeln(OutFile);
  writeln(OutFile,'  TotalSize = ',TotalSize-1,';');
  close(InFile); close(OutFile);
  writeln;
end.
