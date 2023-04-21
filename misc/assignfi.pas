    PROGRAM EZInvest (Input, Output); (*Jenny Tehvand*)
    (*This program allows users to compare the dividend of three different
    investment stratagies and tells them which opportunity would earn the
    most money.  The three firms are: Shipley's Stocks and Shares Brokerage -
    BHP blue chip shares, Bank of Australia - Fixed Term Deposit and Southern
    Queensland Building Society - Bank Bill.*)

    USES CRT;

    CONST
      shares = 1.25;
      termrate = 0.08;
      charge = 5.00;
      min = 800;
      bilrate1 = 0.08;
      bilrate2 = 0.09;

    VAR
      cho,quit:integer;
      inves:real;
      dividend:real;
      time:real;
      cont:char;
    (***********************************************************************)

    PROCEDURE music;
    (*makes a musical sound to entertain the user*)

    BEGIN  (*begins music procedure*)
      SOUND (185);
      DELAY (400);
      NOSOUND;
      DELAY (200);
      SOUND (310);
      DELAY (400);
      NOSOUND;
      DELAY (200);
      SOUND (335);
      DELAY (400);
      NOSOUND;
      DELAY (200);
    END;  (*ends music procedure*)

    (***********************************************************************)

    PROCEDURE border;
    (*displays a border for the screen*)

    VAR
      across,side:integer;

    BEGIN    (*begins border procedure*)
      CLRSCR;
      Textcolor (green);
      GoToXY (1,1);
      Write ('É');
      FOR across:= 2 TO 78 DO
      BEGIN   (*begins for to loop*)
        GoToXY (across,1);
        Write ('Í');
        GoToXY (2,79);
        Textcolor (green);
        Writeln ('»');
      END;
      FOR across:= 2 TO 78 DO
      BEGIN
        Textcolor (green);
        GoToXY (across,25);
        Write ('Í');
        GoToXY (1,25);
        Write ('È');
      END;
      FOR side:= 2 TO 24 DO
      BEGIN
        GoToXY (1,side);
        Textcolor (green);
        Write ('º');
      END;
      FOR side:= 2 TO 24 DO
      BEGIN
        GoToXY (79,side);
        Textcolor (green);
        Write ('º');
        GoToXY (79,25);
        Write ('¼');
      END;  (*ends loop*)
    END;

    (***********************************************************************)

    PROCEDURE begnscrn;
    (*the beginning screen for the program*)

    BEGIN    (*begins display screen*)
      border;
      music;
      Textcolor (blue);
      GoToXY (32,3);
      Write ('²²²²²²  ²²²²²²');
      GoToXY (32,4);
      Write ('²            ²');
      GoToXY (32,5);
      Write ('²           ²');
      GoToXY (32,6);
      Write ('²²²²       ²');
      GoToXY (32,7);
      Write ('²         ²');
      GoToXY (32,8);
      Write ('²        ²');
      GoToXY (32,9);
      Write ('²²²²²²  ²²²²²²');
      GoToXY (10,12);
      Write ('²  ²²        ²  ²                ²  ²²²²²²     ²²²²    ²²²²²²²');
      GoToXY (10,13);
      Write ('²  ² ²       ²   ²              ²   ²         ²    ²      ²');
      GoToXY (10,14);
      Write ('²  ²  ²      ²    ²            ²    ²        ²      ²     ²');
      GoToXY (10,15);
      Write ('²  ²   ²     ²     ²          ²     ²         ²           ²');
      GoToXY (10,16);
      Write ('²  ²    ²    ²      ²        ²      ²²²²       ²²²²       ²');
      GoToXY (10,17);
      Write ('²  ²     ²   ²       ²      ²       ²              ²      ²');
      GoToXY (10,18);
      Write ('²  ²      ²  ²        ²    ²        ²      ²        ²     ²');
      GoToXY (10,18);
      Write ('²  ²      ²  ²        ²    ²        ²        ²      ²     ²');
      GoToXY (10,19);
      Write ('²  ²       ² ²         ²  ²         ²         ²    ²      ²');
      GoToXy (10,20);
      Write ('²  ²        ²²          ²²          ²²²²²²     ²²²²       ²');
      Readkey;
    END;  (*ends beginning display*)

    (***********************************************************************)

    PROCEDURE stats (VAR inves:real;VAR ti:real);
    (*This procedure asks the user for their statistics*)

    BEGIN  (*amount procedure*)
      CLRSCR;
      border;
      music;
      Textcolor (blue);
      GoToXY (12,13);
      Writeln ('Please enter the amount, in dollars, to be invested');
      GoToXY (12,14);
      Readln (inves);
      GoToXY (12,15);
      music;
      Writeln ('How long would you like to invest this amount in years?');
      GoToXY (12,16);
      Readln (ti);
    END;   (*amount procedure*)

    (***********************************************************************)

     PROCEDURE menu (VAR choice:integer);

     (*This is the menu procedure, it tells the user the types of
     investments available*)

     BEGIN   (*menu procedure*)
       CLRSCR;
       border;
       music;
       Textcolor (blue);
       GoToXY (30,3);
       Write ('EZ INVEST');
       Textcolor (3);
       GoToXY (23,7);
       Writeln ('Please choose an investment:');
       GoToXY (23,9);
       Writeln ('1. Shipleys Stocks and Shares Brokerage');
       GoToXy (26,10);
       Writeln ('BHP Blue Chip Shares');
       GoToXY (23,12);
       Writeln ('2. Bank of Australia');
       GoToXY (26,13);
       Writeln ('Fixed Term Deposit');
       GoToXY (23,15);
       Writeln ('3. Southern Queensland Building Society');
       GoToXY (26,16);
       Writeln ('Bank Bill');
       GoToXY (23,18);
       Writeln ('4. Quit.');
       GoToXY (36,22);
       REPEAT
       Readln (choice);
       UNTIL choice IN [1,2,3,4];
     END;   (*menu procedure*)

    (***********************************************************************)

    PROCEDURE display (divi:real);
    (*This displays the dividend of any of the choices*)

    BEGIN    (*begins the display*)
      CLRSCR;
      border;
      music;
      Textcolor (blue);
      GoToXY (12,12);
      Writeln ('The dividend you will recieve will be $',divi :5 :2);
      GoToXY (12,14);
      Writeln ('Press any key to return to the main menu');
      Readkey;
    END;     (*ends the display*)

    (***********************************************************************)

    PROCEDURE BlueChip (invest:real; ti:real; VAR divi:real);
    (*This procedure calculates the Blue Chip Shares*)

    BEGIN     (*begins the calculation*)
      stats (invest,ti);
      divi := ((invest/shares) * 0.10) * ti;
      display (divi);
      menu (cho);
    END;      (*ends the calculation*)

    (***********************************************************************)

    PROCEDURE Deposit (invest:real; ti:real; VAR divi:real);
    (*this calculates the fixed term deposit plan*)

    BEGIN   (*begins the calculation*)
      stats (invest,ti);
      divi := (((invest * termrate) - charge) * ti);
      display (divi);
    END;    (*ends the calculation*)

    (***********************************************************************)

    PROCEDURE bankbill ( invest:real; ti:real; VAR divi:real);
    (*calculates the bank bill plan*)

    BEGIN    (*begins the bankbill calculation*)
      stats (invest,ti);
      IF invest >= min THEN
      BEGIN  (*begins the loop*)
        divi := ((invest * bilrate1)* ti);
      END
      ELSE;
      BEGIN
        divi := ((((invest - min)* bilrate2)+ min)* bilrate1) * ti;
      END;   (*ends the loop*)
      display (divi);
    END;     (*ends the calculation*)

    (***********************************************************************)
    PROCEDURE exit;
    (*this option exits the program*)

    BEGIN  (*begin procedure*)
      border;
      music;
      GoToXY (25,12);
      Textcolor (3);
      Writeln ('Thank you for using EZ INVEST');
      GoToXY (40,13);
      Textcolor (14);
      Writeln ('');
      GoToXY (12,23);
      Textcolor (white);
      Writeln ('Produced by Jenny & Co.');
      Readkey;
    END;   (*end procedure*)

    (***********************************************************************)
    PROCEDURE choices (choice:integer; invest:real; ti:real;VAR divi:real);
     (*This is the case procedure*)

     BEGIN  (*case procedure*)
       CASE choice OF
       1: BlueChip(invest,ti,divi);
       2: Deposit (invest,ti,divi);
       3: Bankbill (invest,ti,divi);
       4: quit:=1;
       END; (*ends case*)

     END;   (*case procedure*)

    (***********************************************************************)

    BEGIN (*main*)
        begnscrn;
        repeat
           menu (cho);
           choices (cho, inves, time, dividend);
        until quit=1;
    END. (*main*)
