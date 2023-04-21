{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE
Description:  Demonstration for Client program using TWSocket.
Creation:     8 december 1997
Version:      1.03
EMail:        francois.piette@pophost.eunet.be
              francois.piette@rtfm.be             http://www.rtfm.be/fpiette
Support:      Use the mailing list twsocket@rtfm.be See website for details.
Legal issues: Copyright (C) 1996, 1997, 1998 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@pophost.eunet.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

Updates:
Dec 09, 1997 V1.01 Made it compatible with Delphi 1
Jul 09, 1998 V1.02 Adapted for Delphi 4
Dec 05, 1998 V1.03 Don't use TWait component


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

 Lm3k Client.

 }
unit CliDemo1;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles,winsock, WSocket, ExtCtrls,strutils, ComCtrls;

const
  IniFileName = 'CliDemo.ini';

type
  TClientForm = class(TForm)
    CliSocket: TWSocket;
    Panel1: TPanel;
    LineLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    SendEdit: TEdit;
    SendButton: TButton;
    DisconnectButton: TButton;
    PortEdit: TEdit;
    ServerEdit: TEdit;
    loginlm3kbutton: TButton;
    LM3Kinfo: TMemo;
    DisplayMemo: TMemo;
    lm3kcommand: TMemo;
    Button1: TButton;
    ListView1: TListView;
    motd: TMemo;
    udpsocket: TWSocket;
    discover: TButton;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    procedure DisconnectButtonClick(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure CliSocketDataAvailable(Sender: TObject; Error: Word);
    procedure CliSocketSessionConnected(Sender: TObject; Error: Word);
    procedure CliSocketSessionClosed(Sender: TObject; Error: Word);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure loginlm3kbuttonClick(Sender: TObject);
    procedure lm3kprocesscommand(Sender:TObject;Bufferdata:string);
    procedure lm3kprocess100(Sender:TObject;Buffer100:string);
    procedure lm3kprocess101(Sender:TObject;Buffer101:string);
    procedure lm3kprocess200(Sender:TObject;Buffer200:string);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure discoverClick(Sender: TObject);
    procedure udpSocketDataAvailable(Sender: TObject; Error: Word);
    procedure listview1click(Sender: TObject);

  private
    { Déclarations privées }
    Buffer       : array [0..1023] of char;
    Count        : Integer;
    ConnectError : Word;
    Initialized  : Boolean;
    Leechmasterlogin : Boolean;
   leechmastertest : boolean;

   procedure ProcessCommand(Cmd : String);

  public

    { Public }
  end;

var
  ClientForm: TClientForm;
  ColumnToSort: Integer;

const
CRLF = #13#10;

implementation

{$R *.DFM}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TClientForm.DisconnectButtonClick(Sender: TObject);
begin
    CliSocket.Close;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TClientForm.SendButtonClick(Sender: TObject);
begin
   { Be sure we are connected before sending anything }
    if CliSocket.State = wsConnected then
        CliSocket.SendStr(SendEdit.Text + crlf);
    ActiveControl := SendEdit;
    SendEdit.SelectAll;
    listview1.items.Clear;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TClientForm.ProcessCommand(Cmd : String);
begin
    DisplayMemo.Lines.Add(Cmd);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TClientForm.CliSocketDataAvailable(Sender: TObject; Error: Word);
{this is clunky for leechmaster, must streamline it}
var
    Len : Integer;
    I   : Integer;
begin
    Len := CliSocket.Receive(@Buffer[Count], SizeOf(Buffer) - Count - 1);
    if Len <= 0 then
        Exit;

    Count             := Count + Len;
    Buffer[Count]     := #0;

  {This processes line by line and feeds data thru one line at a time
    the #10 on the end fixes it so it sends the whole crlf sequence as
    part of the command}
    while TRUE do begin
        I := 0;
        while (I < Count) and (Buffer[I] <> #10) do
            Inc(I);
        if I >= Count then
            Exit;
        {ProcessCommand(Copy(StrPas(Buffer), 1, I));}
             lm3kprocesscommand(Sender,copy(strpas(Buffer),1,I)+#10);

        Count             := 0;
        if I >= Integer(StrLen(Buffer)) then
            break;

        Move(Buffer[I + 1], Buffer, Integer(Strlen(Buffer)) - I);
        Count             := StrLen(Buffer);
    end;


end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TClientForm.CliSocketSessionConnected(Sender: TObject;
  Error: Word);
begin
    ConnectError := Error;
    if Error <> 0 then
        DisplayMemo.Lines.Add('Can''t connect, error #' + IntToStr(Error))
    else
        DisconnectButton.Enabled := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TClientForm.CliSocketSessionClosed(Sender: TObject; Error: Word);
begin
    DisconnectButton.Enabled := FALSE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TClientForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
    IniFile : TIniFile;
begin
    IniFile := TIniFile.Create(IniFileName);
    IniFile.WriteInteger('Window', 'Top',    Top);
    IniFile.WriteInteger('Window', 'Left',   Left);
    IniFile.WriteInteger('Window', 'Width',  Width);
    IniFile.WriteInteger('Window', 'Height', Height);
    IniFile.WriteString('Data', 'Server',  ServerEdit.Text);
    IniFile.WriteString('Data', 'Port',    PortEdit.Text);
    IniFile.WriteString('Data', 'Command', SendEdit.Text);
    IniFile.Free;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TClientForm.FormShow(Sender: TObject);
var
    IniFile : TIniFile;
begin
    if Initialized then
        Exit;
    Initialized := TRUE;
    IniFile         := TIniFile.Create(IniFileName);

    Top             := IniFile.ReadInteger('Window', 'Top',    Top);
    Left            := IniFile.ReadInteger('Window', 'Left',   Left);
    Width           := IniFile.ReadInteger('Window', 'Width',  Width);
    Height          := IniFile.ReadInteger('Window', 'Height', Height);

    PortEdit.Text   := IniFile.ReadString('Data', 'Port',    'telnet');
    ServerEdit.Text := IniFile.ReadString('Data', 'Server',  'localhost');
    SendEdit.Text   := IniFile.ReadString('Data', 'Command', 'LASTNAME CAESAR');

    IniFile.Free;

    DisplayMemo.Clear;
    ActiveControl := SendEdit;
    SendEdit.SelectAll;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}




procedure TClientForm.loginlm3kbuttonClick(Sender: TObject);
begin

       if CliSocket.State <> wsConnected then begin
        CliSocket.Proto := 'tcp';
        CliSocket.Port  := PortEdit.Text; {23 for testing, 1680 for LM3k}
        CliSocket.Addr  := ServerEdit.Text; {later, will do broadcast to find lm3k servers}
        CliSocket.Connect;
        { Connect is asynchronous (non-blocking). We will wait while the }
        { session is connecting or application terminated.               }
        while CliSocket.State in [wsConnecting] do begin
            Application.ProcessMessages;
            if Application.Terminated then
                Exit;
        end;
    end;
       if CliSocket.State = wsConnected then
        CliSocket.SendStr('LM3K 1000 Delphiclientbeta0.1' + crlf);
        ActiveControl := SendEdit;  {select all text in editbox, i'll use it for searching later}
        SendEdit.SelectAll;
end;


Procedure TClientForm.lm3kprocesscommand(Sender:TObject;Bufferdata:string);
{Leechmaster server -> client commands
110 filesize filepath
199 list ends
200 motddata
201 thanksfiledata }

var     lmcommand:string;
        lmcommanddata:string;
        lmcommandint:integer;
begin
{leechmaster acknowledge login - only part that doesnt conform to command specs}

if leftstr(bufferdata,17)=('Welcome to TcpSrv') then begin
   leechmasterlogin:=True;
   linelabel.caption:='Login OK';
   exit; {skip to next line - don't need to worry about processing this one}
end; {don't pass on to exception handler - hack for emulator processing}

if leftstr(bufferdata,9)=('LM3K 1000') then begin
   leechmasterlogin:=True;
   linelabel.caption:='Login OK';
   exit; {skip to next line - don't need to worry about processing this one}
end; {check login}


lmcommand:=leftstr(bufferdata,3); {get leechmaster command code to decide what to do with data}
 {---try to convert lmcommand to an integer ---}

  try
    lmcommandint := strtoint(lmcommand);
  except on E: EConvertError do
  begin
      ShowMessage(E.ClassName + CRLF + E.Message);
      lmcommandint:=999;
     end;
end;
 {---}
lm3kcommand.Lines.add(lmcommand+'lmcommand');
displaymemo.lines.add(bufferdata+'---data ends---');
case lmcommandint of
     100: lm3kprocess100(sender,bufferdata);
     101: lm3kprocess101(sender,bufferdata);
     198: lm3kcommand.lines.add('idle timeout closing connection');
     199: lm3kcommand.Lines.add('end of file list'+' case 199');
     200: lm3kprocess200(sender,bufferdata);
     201: lm3kcommand.Lines.add(bufferdata+' case 201');
     999: lm3kcommand.Lines.add('could not convert datatype'+' case 999');   {only if lm3k server is not outputting in correct format}

     else
     lm3kcommand.lines.add('invalid lm3k command'+' case else');

end;

end;

procedure tclientform.lm3kprocess100(Sender:TObject;Buffer100:string);
    {format is
    100 size location
     need to split it into four variables, size and location, computername, and filename  then do something
     with them }

var
I,icount:integer;
filesize,filename,location,computername,tempvar:string;
stringsize,locationlength:integer;
item: tlistitem;
begin
stringsize:=length(buffer100)-4; {take the 100 off the start of the string}
buffer100:=rightstr(buffer100,stringsize); {replace string with 100 removed}
buffer100:=trim(buffer100); {cut crlf off end of it, and any spaces at start}

for I:=1 to length(buffer100) do
    begin
    if buffer100[I]=' ' then
      begin
      filesize:=leftstr(buffer100,I-1);
      location:=rightstr(buffer100,length(buffer100)-I);
      break;
      end;
end;
locationlength:=length(location);

I:=0;
icount:=0;
{take computername from unc name}

for I:=1 to locationlength do
   begin
   if location[I]='\' then icount:=icount+1;
   if icount=2 then computername:=midstr(location,3,I-2);
end;
I:=0 ;
icount:=0;
for I:=locationlength downto 1 do
begin
   if location[locationlength-I]='\' then  filename:=rightstr(location,I);
end;


lm3kcommand.Lines.add('filesize:'+filesize);
lm3kcommand.Lines.add('location:'+location);


item := listview1.items.add;

item.caption :=location;
item.subitems.add(filename);
item.subitems.add(filesize);
item.subitems.add(computername);
item.subitems.add('smb');



end;

procedure tclientform.lm3kprocess101(Sender:TObject;Buffer101:string);
    {101 - includes smb/ftp
    format is
   101 3841115 smb://\\BELIEF\dump\l33ch\mp3\17\blah.mp3
   101 3841115 ftp://10.66.0.1\l33ch\mp3\17\blah.mp3

     need to split it into 5 variables, size and location, computername, filename,protocol  then do something
     with them }

var
I,icount,scount:integer;
filesize,filename,location,computername,tempvar,protocol:string;
stringsize,locationlength:integer;
item: tlistitem;
begin
stringsize:=length(buffer101)-4; {take the 100 off the start of the string}
buffer101:=rightstr(buffer101,stringsize); {replace string with 100 removed}
buffer101:=trim(buffer101); {cut crlf off end of it, and any spaces at start}


for I:=1 to length(buffer101) do
    begin
    if buffer101[I]=' ' then
      begin
      filesize:=leftstr(buffer101,I-1);
      location:=rightstr(buffer101,length(buffer101)-I);
      break;
      end;
end;

protocol:=leftstr(location,3);
locationlength:=length(location)-6;
location:=rightstr(location,locationlength); {hax it up so its only the location, not the protocol}

I:=0;
icount:=0;      
scount:=0;
{need to process different if it's ftp or smb}

if protocol = 'smb' then
     begin

     {take computername from unc name}
       for I:=1 to locationlength do
        begin
        { if location[I]='/' then icount:=icount+1;
         if icount=2 then computername:=midstr(location,3,I-2);}
         if location[I]='/' then scount:=scount+1;
         if scount<1 then computername:=leftstr(location,I);   {why does this work????}

        end;
        I:=0 ;
        icount:=0;
        for I:=locationlength downto 1 do
        begin
           if location[locationlength-I]='/' then  filename:=rightstr(location,I);
        end;


        lm3kcommand.Lines.add('filesize:'+filesize);
        lm3kcommand.Lines.add('location:'+location);


        item := listview1.items.add;

        item.caption :=location;
        item.subitems.add(filename);
        item.subitems.add(filesize);
        item.subitems.add(computername);
        item.subitems.add('smb');
   end
   {ftp}
  else if  protocol= 'ftp' then
    begin
       {take computername from ip address name}
       for I:=1 to locationlength do
        begin
         if location[I]='/' then scount:=scount+1;
         if scount<1 then computername:=leftstr(location,I);   {why does this work????}


        end;
        I:=0 ;
        icount:=0;
        for I:=locationlength downto 1 do
        begin
           if location[locationlength-I]='/' then  filename:=rightstr(location,I);
        end;


        lm3kcommand.Lines.add('filesize:'+filesize);
        lm3kcommand.Lines.add('location:'+location);


        item := listview1.items.add;

        item.caption :=location;
        item.subitems.add(filename);
        item.subitems.add(filesize);
        item.subitems.add(computername);
        item.subitems.add('ftp');


    end


end;


procedure tclientform.lm3kprocess200(Sender:TObject;Buffer200:string);
var buflen:integer;
begin
buflen:=length(buffer200);
motd.lines.add(  leftstr((rightstr(buffer200,buflen-4)),buflen-6));

end;

procedure Tclientform.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
{sort the lists! FREE CODE FROM THE HELPFILE!}
begin
  ColumnToSort := Column.Index;
  (Sender as TCustomListView).AlphaSort;
end;

procedure Tclientform.ListView1Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else begin
   ix := ColumnToSort - 1;
   Compare := CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
  end;

end;



 procedure TClientForm.discoverClick(Sender: TObject);
begin
    udpSocket.Proto      := 'udp';
    udpSocket.Addr       := '255.255.255.255';
    udpSocket.Port       := '1680';
    udpSocket.LocalPort  := '0';
    {udpsocket.LocalAddr:='192.168.0.1';}
    udpSocket.Connect;
    udpSocket.SendStr('LM3K discover server YO');
    {udpSocket.Close;   - need to leave socket open on this port for connections}
end;

procedure TclientForm.udpSocketDataAvailable(Sender: TObject; Error: Word);
var
    Buffer : array [0..1023] of char;
    Len    : Integer;
    Src    : TSockAddrIn;
    SrcLen : Integer;
begin
    SrcLen := SizeOf(Src);
    Len    := udpSocket.ReceiveFrom(@Buffer, SizeOf(Buffer), Src, SrcLen);
    if Len >= 0 then begin
            Buffer[Len] := #0; {make it null terminated}
            displaymemo.lines.add('udp data from '+StrPas(inet_ntoa(Src.sin_addr))+'content:'+buffer);

           { DataAvailableLabel.Caption := IntToStr(atoi(DataAvailableLabel.caption) + 1) +
                                          '  ' + StrPas(inet_ntoa(Src.sin_addr)) +
                                          ':'  + IntToStr(ntohs(Src.sin_port)) +
                                          '--> ' + StrPas(Buffer);}

    end;

end;





procedure TClientForm.listview1click(Sender: TObject);
var inputfile,outputfile :file;
 NumRead, NumWritten: Integer;
  Buf: array[1..65536] of Char; {the magical number}
 filename,smbfilename,infilesize,outfilesize:string;

begin

if listview1.ItemFocused <> nil then

    smbfilename:=listview1.ItemFocused.caption;
    filename:=listview1.itemfocused.SubItems[0];
    displaymemo.Lines.Add(filename);
        savedialog1.filename:=filename;
        savedialog1.execute;
        if savedialog1.filename=filename then exit;
        {if you dont push ok, then it just cancels the transfer}


    displaymemo.Lines.add('attempting file copy routine!');
    assignfile(inputfile,smbfilename);
    displaymemo.Lines.add('assigned inputfile!');
    assignfile(outputfile,savedialog1.filename);
    displaymemo.Lines.add('assigned outputfile');
    FileMode := 0;
    reset(inputfile,1);
    displaymemo.Lines.add('reset inputfile');
    rewrite(outputfile,1);
    displaymemo.Lines.add('rewrote output file');
    FileMode := 2;
    infilesize:=IntToStr(FileSize(inputfile));
{    begin
  with ProgressBar1 do
  begin
    Min := 0;
    Max := Table1.RecordCount;
    Table1.First;
    for i := Min to Max do
    begin
      Position := i;
      Table1.Next;
      // do something with the current record
    end;
  end;}

with progressbar1 do
 begin
 min:=0;
 max:=filesize(inputfile);
   repeat
        BlockRead(inputfile, Buf, SizeOf(Buf), NumRead);
        {displaymemo.lines.Add(infilesize+':'+inttostr(filesize(outputfile)));}
        position:=filesize(outputfile);
        BlockWrite(outputfile, Buf, NumRead, NumWritten);
   until (NumRead = 0) or (NumWritten <> NumRead);
  end;
   closefile(inputfile);
   closefile(outputfile);

end;

end.
