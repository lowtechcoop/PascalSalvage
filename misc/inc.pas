Unit Inc;

{ Created By: Fire&Ice }
{ Last Modified: 10/11/96 }
INTERFACE

Function Right(Strng:string;numbr:byte):string;
Function Left(Strng:string;numbr:byte):string;
Procedure Pause;
Procedure CC(col:integer);
Procedure BC(col:integer);
Procedure Cnt_Txt (txt:string);

Const
{ These are all the Textcolor() Options...                          }
  Black=0;        { Black                                          }
  DkBlue=1;       { Dark Blue                                      }
  DkGreen=2;      { Dark Green                                     }
  DkTurquoise=3;  { Dark Turquoise                                 }
  DkRed=4;        { Dark Red                                       }
  DkPurple=5;     { Dark Purple                                    }
  Brown=6;        { Brown                                          }
  LtGray=7;       { Standard Text Color (Light Gray)               }
  DkGray=8;       { Dark Gray                                      }
  LtBlue=9;       { Light Blue                                     }
  LtGreen=10;     { Light Green                                    }
  LtTurquoise=11; { Light Turquoise                                }
  LtRed=12;       { Light Red (Pink)                               }
  LtPurple=13;    { Light Purple                                   }
  Yellow=14;      { Yellow                                         }
  White=15;       { White                                          }
  Flash=16;       { Text Attrib for Flashing (Add 16 to Color Num) }
{ Number of Columns in the Screen (For Procedure Cnt_Txt) }
  NumCols=80;

IMPLEMENTATION
uses Crt;

{***************************************************************************}
FUNCTION Right(Strng:string;numbr:byte):string;
Var
 loc:byte;                                        { Like The MSBasic }
                                                  { Right Procedure }
Begin
  If numbr >= LENGTH(Strng) then
    Right:=strng
  Else
    Begin
      loc:=length(strng)-numbr+1;
      Right:=copy(strng,loc,numbr);
    End;
End;
{***************************************************************************}
FUNCTION Left(Strng:string;numbr:byte):string;       { Like The MSBasic
}
  Begin                                              { Left Procedure }
    Left:=COPY(Strng,1,numbr);
  End;
{***************************************************************************}
Procedure Pause;                      { This Procedure pauses the
program }
Var
  Wtt:Char;

  Begin
    writeln;write('Press Any Key To Continue...');Wtt:=readkey;writeln;
  End;
{***************************************************************************}
Procedure CC(col:integer);      { Easier than typing Textcolor() }
  Begin
    Textcolor(col);           { ** CC stands for 'Color Change' ** }
  End;
{***************************************************************************}
Procedure BC(col:integer);    { Easier than typing Textbackground() }
  Begin
    Textbackground(col);    { ** BC stands for 'Background Change' ** }
  End;
{***************************************************************************}
Procedure Cnt_Txt (txt:string);         { This Procedure does the }
Var
  shft:integer;                     { task of centering a line of text }

  Begin
    Shft:=(NumCols - Length(txt)) DIV 2;
    Shft:=Shft+Length(txt);
    Writeln(txt:shft);
  End;
{***************************************************************************}
End.

