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
    push bp
    mov bp,sp
    dec cx
    jcxz o
    add [bp+2],bx
o:  pop bp
    iret
showend:
    nop

code ends

end