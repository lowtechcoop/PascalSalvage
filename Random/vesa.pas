program VESA;

var
  VESAsignature : string [4] absolute $BA00:0000;
  MinorVersion : byte absolute $BA00:0004;
  MajorVersion : byte absolute $BA00:0005;

begin
  asm
    mov ax,$BA00;
    mov es,ax;
    mov di,1;
    mov ah,4fh;
    mov al,0;
    int 10h;
  end;
  if (VESAsignature [1] <> 'V') and
     (VESAsignature [2] <> 'E') and
     (VESAsignature [3] <> 'S') and
     (VESAsignature [4] <> 'A') then
  begin
    Write('No VESA BIOS detected.');
    Halt;
  end;
  Write('VESA BIOS version ', MajorVersion, '.', MinorVersion, ' detected.');
end.
