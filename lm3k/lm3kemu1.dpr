program lm3kemu1;

uses
  Forms,
  TcpSrv1 in 'TcpSrv1.pas' {TcpSrvForm};

{$R *.RES}

begin
  Application.Title := 'lm3k emu 1.0.4a';
  Application.CreateForm(TTcpSrvForm, TcpSrvForm);
  Application.Run;
end.
