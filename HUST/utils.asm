
; 输出换行
__crlf macro
    lea dx, CRLF
    mov ah, 9 
    int 21h
endm

; 输出单个字符
__putc macro s
    mov dl, s
    mov ah, 2
    int 21h
endm

; 计算字符串长度，结果存放在bx中
__strlen macro str
    local LOOP, EXIT
    push di
    push ax
    lea di, str
    mov cx, 0
LOOP:
    mov al, [di]
    cmp al, '$'
    je EXIT
    inc cx
    inc di
    jmp LOOP
EXIT:
    pop ax
    pop di
endm

; 输出字符串，以$结尾，传入地址
__output macro s
    lea dx, s
    mov ah, 9
    int 21h
endm

__outputreg macro s
    mov dx, s
    mov ah, 9
    int 21h
endm

; 输入字符串到s指定的地址， 会自动在末尾添加$符
__input macro s
    lea dx, s
    mov ah, 10 
    int 21h
    __crlf
    mov bl, s + 1
    mov bh, 0
    mov s + 2[bx], '$'
endm

; 比较两字符串，相同bx=0， 反之bx=-1
__cmps macro src, dst
    local STRING_NOT_EQUAL, STRING_EXIT
    push di
    __strlen src
    mov ax, cx
    __strlen dst
    cmp ax, cx
    jne STRING_NOT_EQUAL
    lea si, src
    lea di, dst
    repz cmpsb
    jnz STRING_NOT_EQUAL
    mov bx, 0
    jmp STRING_EXIT
STRING_NOT_EQUAL:
    mov bx, -1
STRING_EXIT:
    pop di
endm

; 计算利润率，入口为商品首地址(保存在di)
__calvalue macro
    mov ax, 12[di]
    imul ax, 16[di]
    mov bx, 10[di]
    imul bx, 14[di]
    sub ax, bx
    imul ax, 100
    cwd
    idiv bx
    mov 18[di], ax
endm

; 计算商品的平均利润率，参数di=shop1商品首地址，结果存放在shop1该商品的offset 18处
__calvalueplus macro
    __calvalue
    mov PR1, ax
    add di, N * 20
    __calvalue
    sub di, N * 20
    mov PR2, ax
    add ax, PR1
    sar ax, 1
    mov 18[di], ax
endm

;数字转字符串，数字在ax中
__itoa macro str
    local rem, write_tostr, dtoc_return
    push si  
    push cx
    push dx
    mov si,offset str 
    mov cx, 0   ;把0先压入栈底  
    push cx           
rem:    ;求余，把对应的数字转换成ASCII码  
    mov cx, 10
    cwd
    idiv cx
    add dx, 30H   
    push dx     ;把对应的ASCII码压入栈中  
    cmp ax, 0
    je write_tostr   ;商为0，表示除完  
    jmp rem
write_tostr:   ;把栈中的数据复制到string中  
    pop cx      ;ASCII码出栈  
    mov [si],cl
    jcxz dtoc_return    ;若0出栈，则退出复制  
    inc si  
    jmp write_tostr
dtoc_return:
    mov byte ptr [si],'$' ;最后写入结束符
    pop dx
    pop cx  
    pop si
endm

;字符串转数字,保存在eax中
__atoi macro str
    ;保存数据
    push ebx
    push cx
    push si
    __strlen str
    mov cx,bx ;cx保存字符串长度
    mov si,offset str
    mov eax,0
    mov bl,[si]
write_to_int:
    cmp bl,'0'
    jb error
    cmp bl,'9'
    ja error
    sub bl,30H
    movzx ebx,bl
    imul eax,10
    jo error
    add eax,ebx
    jo error
    js error
    jc error
    inc si
    mov bl,[si]
    loop write_to_int
    jmp itoc_return
error:
    mov eax,-1
    jmp itoc_return
itoc_return:
    pop si
    pop cx
    pop ebx
endm

__outputnum macro s
    push ax
    mov ax, [s]
    __itoa TEMP_OUT
    __output TEMP_OUT 
    pop ax
endm


__showitemsingle macro
    __outputreg di 
    __putc ','
    __outputnum di + 12
    __putc ','
    __outputnum di + 14
    __putc ','
    __outputnum di + 16
    __crlf
endm

__showitemall1 macro
    __outputreg di
    __putc ','
    __outputnum di + 12
    __putc ','
    __outputnum di + 14
    __putc ','
    __outputnum di + 16
    __putc ','
    __output NOTE_AVER_PROFIT
    __outputnum di + 18
    __crlf 
endm

__showitemall2 macro
    __outputreg di
    __putc ','
    __outputnum di + 12
    __putc ','
    __outputnum di + 14
    __putc ','
    __outputnum di + 16
    __putc ','
    __output NOTE_RANK
    __outputnum di + 18
    __crlf 
endm


__showitem macro
    __output SHOP_NAME_1
    __putc ','
    __showitemsingle
    __output SHOP_NAME_2
    __putc ','
    add di, N * 20
    __showitemsingle
endm    