unit filedownload;

interface

uses
  Classes;

type
  Ttransferfile = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

{ Important: Methods and properties of objects in VCL or CLX can only be used
  in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure Ttransferfile.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ Ttransferfile }

procedure Ttransferfile.Execute;
begin
  { Place thread code here }
  with Clientform.progressbar1 do
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
  {end thread code}
end;

end.
 