assume cs:code

code segment
    mov ax,4240h
    mov dx,000fh
    mov cx,0ah
    call divdw

    mov ax,4c00h
    int 21h

divdw:
    push bx
    mov bx,ax
    mov ax,dx
    mov dx,0
    div cx ;ax stores int , dx stores rem
    push ax
    mov ax,bx
    div cx
    mov cx,dx
    pop dx

    pop bx
    ret
code ends

end
