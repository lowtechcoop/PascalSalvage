Unit limems;

Interface

function emsINSTALLED:boolean;
function emsSTATUS:boolean;
procedure emsPAGES(var totalpages,pagesavailable:word);
procedure emsGETMEM(pagesneeded:word;var handle:word);
procedure emsMAP(handle,logicalpage,physicalpage:word);
procedure emsADDRESS(var address:word);
procedure emsFREEMEM(handle:word);
procedure emsVERSION(var st:string);

implementation

Uses Dos;

var
  regs : registers;

function hc(number:byte):char;
begin
   if number<10
      then hc := chr(number+48)
      else hc := chr(number+65);
end;


function hexstring(num:word):string;
begin
   hexstring := hc(hi(num)shr 4)+hc(hi(num) and $f)+hc(lo(num)shr 4)+hc(lo(num)and $f);
end;


function emsinstalled:boolean;
var
   s : string[8];
begin
   with regs do
      begin
         ah := $35;
         al := $67;
         msdos(regs);
         move(mem[es:$0a],s[1],8);
         s[0] := chr(8);
         emsinstalled := (s='EMMXXXX0');
      end;
end;


function emsstatus:boolean;
begin
   with regs do
      begin
         ah := $40;
         intr($67,regs);
         emsstatus := (ah=0);
      end;
end;


procedure emsaddress(var address:word);
begin
   with regs do
      begin
         ah := $41;
         intr($67,regs);
         address := bx;
      end;
end;


procedure emsPAGES(var totalpages,pagesavailable:word);
begin
   with regs do
      begin
         ah := $42;
         intr($67,regs);
         pagesavailable := bx;
         totalpages := dx;
      end;
end;


procedure emsgetmem(pagesneeded:word;var handle:word);
begin
   with regs do
      begin
         ah := $43;
         bx := pagesneeded;
         intr($67,regs);
         handle := dx;
      end;
end;


procedure emsmap(handle,logicalpage,physicalpage:word);
begin
   with regs do
      begin
         ah := $44;
         al := physicalpage;
         bx := logicalpage;
         dx := handle;
         intr($67,regs);
      end;
end;


procedure emsfreemem(handle:word);
begin
   with regs do
      begin
         ah := $45;
         dx := handle;
         intr($67,regs);
      end;
end;


procedure emsversion(var st:string);
begin
   with regs do
      begin
         ah := $46;
         intr($67,regs);
         st := chr(al shr 4+48)+'.'+chr(al and $f+48);
      end;
end;


end.