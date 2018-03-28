assume cs:code
data segment
    db 'Welcome to masm!',0
data ends

code segment
start:
    mov dh,8
    mov dl,3
    mov cl,2
    mov ax,data
    mov ds,ax
    mov si,0
    call show_str

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
    ret

code ends
end start