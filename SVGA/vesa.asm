.model tpascal
.386
.DATA

 FALSE EQU 0
 TRUE EQU 1

 EXTRN Sega000:word
 EXTRN CurWriteBank:word
 EXTRN BankVals[20]:word
 EXTRN LineOffsets[1024]:dword
 EXTRN SwitchBank:dword
 EXTRN CurReadBank:word
 EXTRN ReadWindow:word
 EXTRN XRes:word
 EXTRN YRes:word
 colour db ?
 ChangedBank db ?
.CODE
LOCALS

public putpixel
public getpixel
public putpixel24

absval MACRO ; eax on input, returns the absolute value in eax, destroys edx
        cdq
        xor     eax,edx
        sub     eax,edx
endm

Rep_MovsWB MACRO
        shr     cx,33               ; cx:=cx div 2 (carry:=cx mod 2)
        rep     movsw               ; blast the pixels
        adc     cx,cx               ; this is *SO* absurd
        rep     movsb               ; but you cannot use a macro that
ENDM                                ; has a jump in it more than once in a
                                    ; procedure

Rep_StosWB MACRO
        shr     cx,33
        rep     stosw
        adc     cx,cx
        rep     movsb
ENDM

;{===============================vvvvvvvvvvvv================================}
;{==============================>  PUTPIXEL  <===============================}
;{===============================^^^^^^^^^^^^================================}

putpixel proc
arg @@x:word,@@y:word,@@colour:byte

        mov     es,SegA000

        mov     bx,@@y
        shl     bx,2
        mov     edi,LineOffsets[bx]
        movzx   eax,@@x
        add     edi,eax
        shld    ebx,edi,16

        cmp     bx,CurWriteBank
        je      short @@ppix

;   { change page; call VESA }
        xor     dx,dx
        mov     CurWriteBank,bx  ; { reset to new page }
        add     bx,bx
        mov     dx,BankVals[bx]
        xor     bx,bx
        call    dword ptr switchbank
@@ppix:
        mov     al,@@colour
        mov     es:[di],al

        mov     ax,ReadWindow
        test    ax,ax
        jnz     @@DiffBank
        mov     ax,CurWriteBank
        mov     CurReadBank,ax
@@DiffBank:
        ret
putpixel endp

;{===============================vvvvvvvvvvvv================================}
;{==============================>  GETPIXEL  <===============================}
;{===============================^^^^^^^^^^^^================================}

getpixel proc
arg @@x:word,@@y:word

        mov     es,SegA000

        mov     bx,@@y
        shl     bx,2
        mov     edi,LineOffsets[bx]
        movzx   eax,@@x
        add     edi,eax
        shld    ebx,edi,16

        cmp     bx,CurReadBank
        je      short @@readpix

        xor     dx,dx
        mov     CurReadBank,bx  ; { reset to new page }
        add     bx,bx
        mov     dx,BankVals[bx]
        mov     bx,ReadWindow
        call    dword ptr SwitchBank

@@readpix:
        mov     al,es:[di]

        mov     bx,ReadWindow
        test    bx,bx
        jnz     @@DiffBank
        mov     bx,CurReadBank
        mov     CurWriteBank,bx
@@DiffBank:

        ret
getpixel endp

putpixel24 proc
arg @@x:word,@@y:word,@@red:byte,@@green:byte,@@blue:byte

        mov     es,SegA000

        mov     bx,@@y
        shl     bx,2
        mov     edi,LineOffsets[bx]
        mov     ax,@@x
        and     eax,0ffffh
        add     ax,@@x
        add     ax,@@x

        add     edi,eax
        shld    ebx,edi,16

        cmp     bx,CurWriteBank
        je      short @@ppix

;   { change page; call VESA }
        xor     dx,dx
        mov     CurWriteBank,bx  ; { reset to new page }
        add     bx,bx
        mov     dx,BankVals[bx]
        xor     bx,bx
        call    dword ptr switchbank
@@ppix:
        mov     al,@@blue
        mov     es:[di],al
        mov     al,@@green
        mov     es:[di+1],al
        mov     al,@@red
        mov     es:[di+2],al

        mov     ax,ReadWindow
        test    ax,ax
        jnz     @@DiffBank
        mov     ax,CurWriteBank
        mov     CurReadBank,ax
@@DiffBank:
        ret
putpixel24 endp

CODE ENDS
     END

