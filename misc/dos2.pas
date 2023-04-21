{$M $4000,0,0}
{$N+,E+}
{$g+}
   { 16K stack, no heap }
uses Dos;
var
  ProgramName, CmdLine: string;
begin
  Write('Program to Exec (full path): ');
  ReadLn(ProgramName);
  Write('Command line to pass to ',
        ProgramName, ': ');
  ReadLn(CmdLine);
  WriteLn('About to Exec...');
  SwapVectors;
  Exec(ProgramName, CmdLine);
  SwapVectors;
  WriteLn('...back from Exec');
  if DosError <> 0 then{ Error? }
    WriteLn('Dos error #', DosError)
  else
    WriteLn('Exec successful. ',
            'Child process exit code = ',
            DosExitCode);
end.