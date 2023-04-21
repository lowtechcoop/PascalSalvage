
program mousetest;
{ Test program for mouseunit, by Bas van Gaalen, Holland, PD }
uses crt,video,mouse;

function hex(value : word) : string;
const hexchars : array[0..15] of char = '0123456789abcdef';
begin
  hex := hexchars[value shr 4]+hexchars[value and 15];
end;

begin
  resetmouse;
  if driverinstalled then begin
    filltext(' ',0,0,25,20,7);
    cursoroff;
    showmouse;
    getmouseversion;
    gotoxy(1,5);
    writeln('version : ',hex(verhi),'.',hex(verlo));
    writeln('type    : ',mtypes[mousetype]);
    writeln('buttons : ',buttons);

    {mousewindow(10,10,70,40);}

    repeat
      gotoxy(1,10);
      write('x : ',getmousex:2,'    y : ',getmousey:2,#13);

      gotoxy(1,11);
      if leftpressed then begin
        write('left');
        dspat(getstratcursor,0,13,7);

      end else write('    ');

      gotoxy(1,12);
      if rightpressed then write('right') else write('     ');

    until keypressed;

    hidemouse;
    cursoron;

  end else writeln('no mousedriver installed!');
end.
