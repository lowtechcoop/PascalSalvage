program motd;

  {

  motto of the day for dos...
 Blair Harrison 1997
    modified for confucious 25/4/98
  }

  uses crt,  { For functions like textcolor }
       dos;  { For more advanced file-handling functions }
  var
      tagfile:text;
      invisible,  { For counting the number of lines }
      line:string;  { For storing the selected line }
      taglines,
      whereto:word;  { For getting params }
      counter, { For counting number of lines read }
      numberlines,  { For storing number of lines read }
      select:integer;  { Random number generated within range
    of numberlines }
      files,
      files2:pathstr;  { For checking param paths }

procedure help;  { Displayed if 1st param = none or `?' }

begin;

 writeln;
 textcolor(12);
 writeln('This is confucious version b!');
 writeln;

 textcolor(7);  { For naffer, non-colour-reset PCs }
 halt;

end;

procedure notags;  { What if taglines don't exist? }
begin;
 writeln('Tagline file not found.');
 halt;
end;

procedure nodest;  { What if destination doesn't exist? }
begin;
 writeln('Destination file not found.');
 halt;
end;

procedure getline; { Write the tagline to a text file }

begin;
 writeln('Confucious Say');

 writeln(line);
 writeln(' ');
 writeln('By Blair Harrison 1997');


end;

begin  { Actually start the program }
    clrscr;
    counter:=-1;
    assign(tagfile,'c:\confu.txt');
    reset(tagfile);

    while not eof(tagfile) do  { Count the number of lines in the text }

      begin;
       readln(tagfile,invisible);
       numberlines:=numberlines+1;
      end;

    randomize; { Generate a random number based on the number of lines }
    select:=random(numberlines);

    reset(tagfile);  { Important to reset the file before re-accessing }

    while not eof(tagfile) do  { Match the random number with a line }

      begin;
       readln(tagfile,line);
       counter:=counter+1;
       IF counter=select THEN getline;  { Get dat tagline! }
      end;

end.