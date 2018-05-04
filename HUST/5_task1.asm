.386
code segment use16
START: 
    xor ax, ax
    mov ds, ax
    mov ax, 3501h
    int 21h

    mov ax, 3510h
    int 21h

    mov ax, ds:[1h * 4]
    mov bx, ds:[1h * 4 + 2]

    mov ax, ds:[10h * 4]
    mov bx, ds:[10h * 4 + 2]

    mov ah, 4ch
    int 21h
code ends
end START