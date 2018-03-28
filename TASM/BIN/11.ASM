assume cs:codesg

datasg segment
    db "Beginner's All-purpose Symbolic Intruction Code.",0
datasg ends

codesg segment
begin:
    mov ax,datasg
    mov ds,ax
    mov si,0
    call letterc

    mov ax,4c00h
    int 21h
    
letterc:
    push ax
    push bx
    push cx
    mov bh,'a'
    mov bl,'z'
    mov ch,0
s:  mov al,[si]
    mov cl,al
    jcxz o
    cmp al,bh
    jb o1
    cmp al,bl
    ja o1
    and al,11011111b
    mov [si],al
o1: inc si
    jmp short s
o:  pop cx
    pop bx
    pop ax

    ret
codesg ends

end begin
