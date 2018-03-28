assume cs:code,ss:data

code segment
    mov ax,0b800h
    mov ds,ax
    mov bx,1760

    mov ax,data
    mov ss,ax
    mov si,0

    mov bp,0
    mov cx,3
s1: mov ss:[19],cx
    mov si,0
    mov cx,16
s2: mov di,si
    add di,di
    mov al,ss:[si]
    mov [bx+64+di],al
    mov al,ss:[16+bp]
    mov [bx+65+di],ax
    inc si
    loop s2
    inc bp
    add bx,160
    mov cx,ss:[19]
    loop s2
    mov ax,4c00h
    int 21h
code ends

data segment
    db 'welcome to masm!'
    db 00000010b,00100100b,01110001b
    dw 0
data ends

end
