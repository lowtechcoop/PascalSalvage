@echo off
tasm 3d.asm
if errorlevel 1 then goto end:
tlink /t 3d.obj

:end
del *.bak
del *.obj
del *.map
