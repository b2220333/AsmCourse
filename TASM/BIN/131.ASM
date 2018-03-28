assume cs:code

code segment
    mov ax,cs
    mov ds,ax
    mov si,offset show_str
    mov ax,0
    mov es,ax
    mov di,200h
    mov cx,offset showend - offset show_str
    cld
    rep movsb

    mov ax,0
    mov ds,ax
    mov word ptr ds:[7ch * 4],200h
    mov word ptr ds:[7ch * 4 + 2],0
    
    mov ax,4c00h
    int 21h

show_str:
    push es
    push ax
    push bx
    push cx 
    push di
    mov ax,0b800h
    mov es,ax

    mov al,dh
    mov ah,160
    mul ah
    mov bx,ax
    
    mov ch,0
    mov al,0
    or al,cl
    mov dh,0
    add dx,dx
    mov di,dx
s:  mov cl,[si]
    jcxz o 
    mov es:[bx+di],cl
    mov es:[bx+di+1],al
    add di,2
    inc si
    jmp short s
o:  pop di
    pop cx
    pop bx
    pop ax
    pop es
    iret
showend:
    nop

code ends

end