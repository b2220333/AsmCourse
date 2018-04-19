
.386

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

data segment use16
    N EQU 30
    ITEM_A_1 DB 'PEN', '$', 6 DUP(0)
             DW 35, 56, 70, 25, ?
    ITEM_B_1 DB 'BOOK', '$', 5 DUP(0)
             DW 12, 30, 25, 15, ?
    ITEM_C_1 DB 'BAG', '$', 6 DUP(0)
             DW 20, 40, 30, 20, ?
    ITEM_OTHERS_1 DB N - 3 DUP('TEMPVALUE$', 15, 0, 20, 0, 30, 0, 2, 0, ?, ?)

    ITEM_A_2 DB 'PEN', '$', 6 DUP(0)
             DW 35, 50, 30, 24, ?
    ITEM_B_2 DB 'BOOK', '$', 5 DUP(0)
             DW 12, 28, 20, 5, ?
    ITEM_C_2 DB 'BAG', '$', 6 DUP(0)
             DW 18, 42, 32, 20, ?
    ITEM_OTHERS_2 DB N - 3 DUP('TEMPVALUE$', 15, 0, 20, 0, 30, 0, 2, 0, ?, ?)

    CRLF DB 0dh, 0ah, '$'
    DIVID_OUTPUT DB '->$'
    DEBUG_MSG DB 'DEBUG MESSAGE $'
    NOTE_USER_NAME DB 'Please input username:$'
    NOTE_USER_PWD DB 'Please input password:$'
    NOTE_INPUT_ITEM DB 'Please input item name:$'
    NOTE_SHOP_NAME DB 'Please input shop name:$'
    NOTE_AUTH_FAIL DB 'Wrong username/password, try again.$'
    NOTE_OPTION1 DB '1. Query item infomation', 0dh, 0ah, '$'
    NOTE_OPTION2 DB '2. Edit item infomation', 0dh, 0ah, '$'
    NOTE_OPTION3 DB '3. Calculate average profit', 0dh, 0ah, '$'
    NOTE_OPTION4 DB '4. Calculate profit rank', 0dh, 0ah, '$'
    NOTE_OPTION5 DB '5. Show all item infomation', 0dh, 0ah, '$'
    NOTE_OPTION6 DB '6. Exit', 0dh, 0ah, '$'
    NOTE_INVALID_NUM DB 'Invalid input! Try again.', 0dh, 0ah, '$'
    NOTE_AVER_PROFIT DB 'Average profit:$'
    NOTE_RANK DB 'Rank:$'
    B_NAME DB 'Wu Di', '$'
    PASSWORD DB 'qwerty', '$'

    SHOP_NAME_1 DB 'SHOP1', '$'
    SHOP_NAME_2 DB 'SHOP2', '$'
    PR1 DW ?
    PR2 DW ?
    IN_NAME DB 11
            DB ?
            DB 11 dup(0)
    IN_PWD DB 7
           DB ?
           DB 7 dup(0)
    IN_ITEM_NAME DB 11
                 DB ?
                 DB 11 dup(0)
    IN_SHOP_NAME DB 6
                 DB ?
                 DB 6 dup(0)
    AUTH DB 0
    TEMP_IN DB 10
            DB ?
            DB 10 DUP(0)
    TEMP_OUT DB 20 dup(0)
data ends

stack segment use16
    DB 200 dup(0)
stack ends

code segment use16 
    assume CS:code, DS:data, ES:data, SS:stack
START:
    mov ax, data
    mov ds, ax
    mov es, ax
    mov byte ptr AUTH, 1
    jmp FEAT_3 ; testing
INPUT_USERNAME:
    __output NOTE_USER_NAME
    __input IN_NAME

    mov dl, IN_NAME + 1
    cmp dl, 0
    jne CHECK_Q
    mov byte ptr AUTH, 0
    jmp FEAT_3
CHECK_Q:
    cmp dl, 1
    jne CMP_NAME
    cmp IN_NAME + 2, 'q'
    jne CMP_NAME
    jmp EXIT
CMP_NAME:
    __cmps IN_NAME + 2, B_NAME
    cmp bx, 0
    jne AUTH_FAIL
INPUT_PASSWD:
    __output NOTE_USER_PWD
    __input IN_PWD
CMP_PASSWD:
    __cmps IN_PWD + 2, PASSWORD
    cmp bx, 0
    jne AUTH_FAIL
    mov byte ptr AUTH, 1
    jmp FEAT_3
AUTH_FAIL:
    __output NOTE_AUTH_FAIL
    __crlf
    jmp INPUT_USERNAME

FEAT_3:
    __output NOTE_OPTION1
    mov bh, AUTH
    cmp bh, 1
    jne OPTION6
    __output NOTE_OPTION2
    __output NOTE_OPTION3
    __output NOTE_OPTION4
    __output NOTE_OPTION5
OPTION6:
    __output NOTE_OPTION6
    mov ah, 1
    int 21h
    __crlf
    cmp al, '6'
    je EXIT
    cmp al, '1'
    je QUERY_ITEM
    cmp bh, 1
    je VALID_AUTH
INVALID_AUTH:
    __output NOTE_INVALID_NUM
    jmp FEAT_3

VALID_AUTH:
    cmp al, '2'
    je EDIT_ITEM_INFO
    cmp al, '3'
    je CAL_AVER_PROFIT
    cmp al, '4'
    je CAL_PROFIT_RANK
    cmp al, '5'
    je OUTPUT_ALL_ITEMS
    jmp INVALID_AUTH
QUERY_ITEM:
    __output NOTE_INPUT_ITEM
    __input IN_ITEM_NAME
    mov dl, IN_ITEM_NAME + 1
    cmp dl, 0
    je FEAT_3
    __cmps IN_ITEM_NAME + 2, ITEM_A_1
    lea di, ITEM_A_1
    cmp bx, 0
    je SHOW_ITEM_INFO
    __cmps IN_ITEM_NAME + 2, ITEM_B_1
    lea di, ITEM_B_1
    cmp bx, 0
    je SHOW_ITEM_INFO
    __cmps IN_ITEM_NAME + 2, ITEM_C_1
    lea di, ITEM_C_1
    cmp bx, 0
    je SHOW_ITEM_INFO
    jmp QUERY_ITEM

SHOW_ITEM_INFO:
    __showitem 
    jmp FEAT_3
EDIT_ITEM_INFO:
    __output NOTE_SHOP_NAME
    __input IN_SHOP_NAME
    __output NOTE_INPUT_ITEM
    __input IN_ITEM_NAME
    call editItem
    jmp FEAT_3
CAL_AVER_PROFIT:
    lea di, ITEM_A_1
    mov cx, 3
CAL_ITEM_AVER_PROFIT:
    __calvalueplus 
    add di, 20
    dec cx
    jnz CAL_ITEM_AVER_PROFIT
    jmp FEAT_3
CAL_PROFIT_RANK:
    call calRank
    jmp FEAT_3
OUTPUT_ALL_ITEMS:
    lea di, ITEM_A_1
    __output SHOP_NAME_1
    __crlf
    mov cx, 3
SHOW_ITEM_ALL_1:
    __showitemall1
    add di, 20
    dec cx
    jnz SHOW_ITEM_ALL_1
    lea di, ITEM_A_2
    __output SHOP_NAME_2
    __crlf
    mov cx, 3
SHOW_ITEM_ALL_2:
    __showitemall2
    add di, 20
    dec cx
    jnz SHOW_ITEM_ALL_2
    jmp FEAT_3

EXIT:
    mov ah, 4ch
    int 21h


;计算平均利润率的排名
calRank proc
    ;数据保存
    push ax
    push di
    push si
    push dx
    push cx
    push bx

    mov bx,1
    mov cx,offset ITEM_A_1+18
    add cx,3*20
    mov si,offset ITEM_A_1+18
    mov di,offset ITEM_A_2+18
    mov ax,[si]
    mov dx,1
compare_item:
    cmp si,cx
    ja change_item
    cmp ax,[si]
    jl increase_rank
    add si,20
    jmp compare_item
increase_rank:
    inc dx
    add si,20
    jmp compare_item
change_item:
    mov [di],dx
    cmp bx,3
    ja btoc_return
    mov ax,bx
    mov si,20
    imul si
    mov si,offset ITEM_A_1+18
    add si,ax
    mov ax,[si]
    mov si,offset ITEM_A_1+18
    add di,20
    mov dx,1
    inc bx
    jmp compare_item
btoc_return:
    pop bx
    pop cx
    pop dx
    pop si
    pop di
    pop ax
    ret
calRank endp

;修改商品信息
;出口参数在ax中，dx=-1,只输入了回车；dx=0，未找到商品;dx=1,修改成功
editItem proc
    push bx
    push cx
    push bp
    push si
    push di
    mov dx,0
    mov si,offset IN_SHOP_NAME
    mov di,offset IN_ITEM_NAME
    mov al,IN_SHOP_NAME+1
    cmp al,0
    je enter_input
    mov al,IN_ITEM_NAME+1
    cmp al,0
    je enter_input
    __cmps SHOP_NAME_1,IN_SHOP_NAME+2
    cmp bx,0
    je edit_shop1
    __cmps SHOP_NAME_2,IN_SHOP_NAME+2
    cmp bx,0
    je edit_shop2
    jmp not_found

edit_shop1:
    __cmps IN_ITEM_NAME+2,ITEM_A_1
    lea di,ITEM_A_1
    cmp bx,0
    je edit_info
    __cmps IN_ITEM_NAME+2,ITEM_B_1
    lea di,ITEM_B_1
    cmp bx,0
    je edit_info
    __cmps IN_ITEM_NAME+2,ITEM_C_1
    lea di,ITEM_C_1
    cmp bx,0
    je edit_info
    __cmps IN_ITEM_NAME+2,ITEM_OTHERS_1
    lea di,ITEM_OTHERS_1
    cmp bx,0
    je edit_info
    jmp not_found

edit_shop2:
    __cmps IN_ITEM_NAME+2,ITEM_A_2
    lea di,ITEM_A_2
    cmp bx,0
    je edit_info
    __cmps IN_ITEM_NAME+2,ITEM_B_2
    lea di,ITEM_B_2
    cmp bx,0
    je edit_info
    __cmps IN_ITEM_NAME+2,ITEM_C_2
    lea di,ITEM_C_2
    cmp bx,0
    je edit_info
    __cmps IN_ITEM_NAME+2,ITEM_OTHERS_2
    lea di,ITEM_OTHERS_2
    cmp bx,0
    je edit_info
    jmp not_found

edit_info:
    mov cx,8

edit_info_loop:
    add cx,2
    cmp cx,14
    ja edit_success
    add di,cx
    mov ax,[di]
    sub di,cx
    __itoa TEMP_OUT
    __output TEMP_OUT
    __output DIVID_OUTPUT
    __input TEMP_IN
    mov al,TEMP_IN+1
    cmp al,0
    je edit_info_loop
    __atoi TEMP_IN+2
    cmp ax,-1
    je edit_again
    add di,cx
    mov [di],ax
    sub di,cx
    jmp edit_info_loop

edit_again:
    sub cx,2
    jmp edit_info_loop

enter_input:
    mov dx,-1
    jmp etoc_return

not_found:
    mov dx,0
    jmp etoc_return

edit_success:
    mov dx,1
    jmp etoc_return
etoc_return:
    pop di
    pop si
    pop bp
    pop cx
    pop bx
    ret
editItem endp

code ends
end START



