begin;
asm
         mov     dx,03c4h
         mov     ax,0100h
         out     dx,ax
         mov     dx,03c4h
         mov     ax,0301h
         out     dx,ax
         mov     dx,03c2h
         mov     al,063h
         out     dx,al
         mov     dx,03c4h
         mov     ax,0300h
         out     dx,ax
         mov     dx,03d4h
         mov     ax,4f09h
         out     dx,ax

end;
end.

