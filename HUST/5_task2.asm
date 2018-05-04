.386
code segment use16
    assume CS:code, SS:stack
STAY:
    jmp BEGIN
    OLD DD ?
EXIT_:
    jmp dword ptr CS:OLD
BEGIN:
    cmp ah, 0h
    je H_0_10
    cmp ah, 10h
    je H_0_10
    cmp ah, 2h
    je H_2_12
    cmp ah, 12h
    je H_2_12 
    jmp EXIT_
    
H_0_10:
    pushf
    call dword ptr CS:OLD
    cmp al, 'a'
    jl EXIT
    cmp al, 'z'
    jg EXIT
    sub al, 20h
    jmp EXIT

H_2_12:
    jmp EXIT_

EXIT:
    iret
STAY_END:
    nop

START:
    xor ax, ax
    mov ds, ax
    mov ax, ds:[16h * 4]
    mov word ptr OLD, ax
    mov ax, ds:[16h * 4 + 2]
    mov word ptr OLD[2], ax
    
    cli
    mov word ptr ds:[16h * 4], offset STAY
    mov word ptr ds:[16h * 4 + 2], CS
    sti

    mov dx, ((offset STAY_END - offset STAY) + 15) / 16 + 10h
    mov ah, 31h
    mov al, 0h
    int 21h
code ends

stack segment stack use16
    db 200 dup(0)
stack ends
end START
