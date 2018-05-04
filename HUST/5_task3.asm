.386

__puthex macro
    local START, PRINT
    mov ch, 2
START:
    mov cl, 4
    rol bl, cl
    mov al, bl
    and al, 0fh
    add al, 30h
    cmp al, 3ah
    jl PRINT
    add al, 07h
PRINT:
    mov dl, al
    mov ah, 2
    int 21h
    dec ch
    jnz START
endm

data segment use16
    ADDRESS DB 00h
data ends

code segment use16
    assume CS:code, SS:stack, DS:data
START:
    mov ax, data
    mov ds, ax

    mov byte ptr al, ADDRESS
    out 70h, al 

    in al, 71h
    mov bl, al
    __puthex

    mov ah, 4ch    
    int 21h
code ends

stack segment stack use16
    db 200 dup(0)
stack ends
end START
