assume cs:code

code segment
    mov ax,0
    mov es,ax
    push es:[4*9]
    pop es:[200]
    push es:[4*9+2]    
    pop es:[202]

    push cs
    pop ds
    mov si,offset int9start
    mov di, 204h
    mov cx,offset int9end - offset int9start
    cld
    rep movsb
    
    cli
    mov word ptr es:[4*9],204h
    mov word ptr es:[4*9+2],0
    sti
    
    mov ax,4c00h
    int 21h

int9start:
    push ax
    push es
    push cx
    push bx
    in al,60h

    pushf
    call dword ptr cs:[200]

    cmp al,1eh+80h
    jne int9out
    
    mov ax,0b800h
    mov es,ax
    mov cx,2000
    mov bx,0
int9s:
    mov byte ptr es:[bx],'A'
    add bx,2
    loop int9s
int9out:
    pop bx
    pop cx
    pop es
    pop ax
    iret
int9end:
    nop

code ends
end

