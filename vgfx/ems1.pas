{ Simple EMS demo that shows how to allocate 1 page of EMS memory
  and push/pop a string to it.

  You can store most anything in EMS, as long as it doesn't exceed 16384
  bytes PER page, you can use as many pages as you have available by the
  EMS driver.
}

uses dos,crt,ems;

{ Declare our variables }
var EMSVer : word;      { EMS Driver Version }
    Handle : integer;   { Handle for the EMS page }
    S      : string;    { String for putting in EMS }
    StLen  : integer;   { String's length }


{ Main Procedure! }
begin
     clrscr;
     writeln;

     { Initialize the EMS driver }
     EMSVer := EMS_Init;

     { If EMSResult is greater than or equal to $80 then it is an EMS driver
       error }
     if (EMSResult >= $80) then
     begin
          { There was an EMS error, so display the description }
          writeln('EMS Error:  ', EMS_ErrDesc[EMSResult]);
          halt(1);
     end
     else if (EMSVer = 0) then
     begin
          writeln('EMS Demo:  No EMS driver found!');
          halt(1);
     end;


     { Allocate 1 page of EMS memory }
     handle := EMSAlloc(1);

     if (EMSResult>=$80) then
     begin
          { There was an EMS error, so display the description }
          writeln('EMS Alloc Error:  ', EMS_ErrDesc[EMSResult]);
          halt(1);
     end;


     { Map this page so we can use it

                               This is the physical page in the frame to
                               | assign our logical page to.
     This is the logical page  |
 This is the EMS handle     |  |
                      v     v  v }
     if (not EMSMap(Handle, 0, 0)) then
     begin
          { There was an EMS error, so display the description }
          writeln('EMS Map Error:  ', EMS_ErrDesc[EMSResult]);
          EMSFree(handle);
          halt(1);
     end;


     { Here is the string we will put into the EMS page }
     s := 'This is a test string for EMS!';

     { Store the string length in bytes so we know how much to store
       and restore }
     stlen := length(s);


     { Print the string before it goes into EMS }
     writeln('String before being pushed into EMS : "', s, '"');


     { Move the string into EMS (page 0)

                          This is the pointer to the EMS physical page 0
 MkPtr creates a pointer  |
 to our string |          |         How many bytes to 'move' into EMS
               |          |         |
               v          v         v        }
     move(mkptr(s)^, EMSPage(0)^, stlen);


     { Erase the string, so no trace is found! }
     s:='';
     writeln('String after it is nulled           : "', s, '"');


     { Copy the string back from EMS (page 0) - Works the same way as
       the 'move' above does, except we reversed the parameters. }
     move(EMSPage(0)^, mkptr(s)^, stlen);


     writeln('String after being restored from EMS: "', s, '"');

     readkey;


     { Free the EMS page we allocated earlier }
     EMSFree(handle);

     { Check for EMS error }
     if (EMSResult>=$80) then
     begin
          { There was an EMS error, so display the description }
          writeln('EMS Free Error:  ', EMS_ErrDesc[EMSResult]);
          halt(1);
     end;

     halt(0);
end.
