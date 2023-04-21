{$g+}

program Splitscreen;
var i : word;

begin
  asm
    cli
   @l0:
    mov dx,03dah
   @l1:
    in al,dx
    test al,8
    jnz @l1
   @l2:
    in al,dx
    test al,8
    jz @l2

    mov dx,03c8h
    xor al,al
    out dx,al
    inc dx
    mov al,0
    out dx,al
    mov al,10
    out dx,al
    mov al,40
    out dx,al

    mov cx,200
   @l3:

    mov dx,03dah
   @l4:
    in al,dx
    test al,1
    jnz @l4
   @l5:
    in al,dx
    test al,1
    jz @l5

    loop @l3

    {
    mov dx,03c8h
    xor al,al
    out dx,al
    inc dx
    mov al,0
    out dx,al
    mov al,10
    out dx,al
    mov al,40
    out dx,al
    }

    mov dx,03c8h
    xor al,al
    out dx,al
    inc dx
    out dx,al
    out dx,al
    out dx,al

    mov dx,60h
    in al,dx
    cmp al,1
    jne @l0
    sti
  end;
end.
