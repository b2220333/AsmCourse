assume cs:code

data segment
    db 10 dup (0)
data ends

code segment

start:
    mov ax,31239
    mov bx,data
    mov ds,bx
    mov si,0
    call dtoc

    mov dh,8
    mov dl,3
    mov cl,2
    call show_str

    mov ax,4c00h
    int 21h

dtoc:
    push si
    push bx
    push dx
    push cx
    mov bx,0
    push bx
    mov bx,10
sdtoc:
    mov dx,0
    div bx ;ax stores int , dx stores rem
    mov cx,ax
    add dx,30h
    push dx
    jcxz odtoc
    jmp short sdtoc
odtoc:  pop cx
    mov [si],cl
    jcxz o1
    inc si
    jmp short odtoc
o1: pop cx
    pop dx
    pop bx
    pop si
    ret

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
