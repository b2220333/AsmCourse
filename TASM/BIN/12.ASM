assume cs:code

code segment

    mov ax,0
    mov es,ax
    mov di,200h
    mov ax,cs
    mov ds,ax
    mov si,offset s
    mov cx,offset send - offset s
    cld
    rep movsb
    
    mov ax,0
    mov ds,ax
    mov word ptr ds:[0],200h
    mov word ptr ds:[2],0
    
    mov ax,1000h
    mov bh,1
    div bh
    mov ax,4c00h
    int 21h

s:  jmp short start
    db "divide error!"
start:
    push ax
    push es
    push di
    push ds
    push si
    push cx
    mov ax,0b800h
    mov es,ax
    mov di,12*160+33*2
    
    mov ax,cs
    mov ds,ax
    mov si,202h
    mov cx,13
f:  mov al,ds:[si]
    mov es:[di],al
    inc si
    add di,2
    loop f
    pop cx
    pop si
    pop ds
    pop di
    pop es
    pop ax

    mov ax,4c00h
    int 21h
send:
    nop

code ends

end
