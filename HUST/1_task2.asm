.386

stack segment use16 stack
        db 200 dup(0)
stack ends

data segment use16
text    db 'Press any key to begin!','$'
buf1    db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
buf2    db 10 dup (0)
buf3    db 10 dup (0)
buf4    db 10 dup (0)
data ends

code segment use16
        assume cs:code, ds:data, ss:stack
start:  mov ax, data
        mov ds, ax
        mov si, offset buf1
        mov di, offset buf2
        mov bx, offset buf3
        mov bp, offset buf4
        mov cx, 10
        mov dx, offset text
        mov ah, 9h
        int 21h
        mov ah, 1h
        int 21h
lopa:   mov al, [si]
        mov [di], al
        inc al
        mov [bx], al
        add al, 3
        mov ds:[bp], al
        inc si
        inc di
        inc bp
        inc bx
        dec cx
        jnz lopa
        mov ah, 4ch
        int 21h
code ends
end start
