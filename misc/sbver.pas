
Ä Area: Pascal - FidoNet ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Msg#: 1514                                         Date: 06-16-97 01:57
  From: Jeroen van Rooij                             Read: Yes    Replied: No 
    To: Greg MacLellan                               Mark:                     
  Subj: autodetect sound card
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Hello Greg,

Saturday, 14 June 1997 20:26:20, Greg MacLellan wrote to All Subject:
autodetect sound card

 GM> i need some code that will autodetect the TYPE of sound card..
 GM> yes, i can check env varibles, but that doesn't tell me what
 GM> version of soundblaster it is (1.0, 2.0, pro, 16) or gus or pas..

Well Greg, i found this code in a Swag. If it's not what you're
lookin' for, let me know and i dig up another code. I have really
good one's (also not posted in a Swag).

[===============================Snip================================]
PROGRAM sb;               { Determine Sound Blaster version.  TP5+  }
                          { Jul.13.94 Greg Vigneault                }
USES  Dos,                { import GetEnv                           }
      Crt;                { import Delay                            }
VAR Major, Minor : BYTE;  { version has major & minor parts         }

(*-----------------------------------------------------------------*)
{ this procedure returns 0.0 if any error condition...              }
PROCEDURE SBver (VAR Maj, Min : BYTE);
  VAR bev : STRING[32];                       { environment string  }
      j,k : WORD;                             { scratch variables   }
  BEGIN
    Maj := 0;  Min := 0;                      { initialize          }
    bev := GetEnv('BLASTER');                 { look in environment }
    IF bev[0] = #0 THEN EXIT;                 { no sign of Blaster  }
    j := Pos('A',bev);                        { search for i/o port }
    IF j = 0 THEN EXIT ELSE INC(j);           { none?               }
    Val( '$'+Copy(bev,j,3), j, k );           { base port number    }
    IF k <> 0 THEN EXIT;                      { if bad port value   }
    INC(j,$C);                                { command port        }
    Port[j] := $E1;                           { command             }
    DEC(j,2);                                 { input port          }
    Delay(20);                                { wait for response   }
    Maj := Port[j];                           { version major part  }
    Delay(20);                                { wait for response   }
    Min := Port[j];                           { version minor part  }
  END {SBver};

BEGIN
  SBver (Major, Minor);
  WriteLn;
  WriteLn ('Sound Blaster version: ',Major,'.',Minor);
  WriteLn;
END.

[===============================Snip================================]
 -=> Greetz, Jeroen van Rooij, <=-

.!. Forrest Gump: You can lead a horse to water, but who has the time?
-!- Terminate 4.00/Pro
 ! Origin: þThe Moutain BBSþ ++31(0)135400628, Berkel-Enschot (2:285/264.78)  
