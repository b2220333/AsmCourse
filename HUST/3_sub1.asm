.386
include utils.asm
public calRank, editItem
extrn ITEM_A_1:byte, ITEM_A_2:byte, IN_ITEM_NAME:byte, IN_SHOP_NAME:byte, ITEM_B_1:byte, ITEM_B_2:byte, ITEM_C_1:byte, ITEM_C_2:byte, ITEM_OTHERS_1:byte, ITEM_OTHERS_2:byte, TEMP_IN:byte, SHOP_NAME_1:byte, SHOP_NAME_2:byte, TEMP_OUT:byte, DIVID_OUTPUT:byte, CRLF:byte
data segment use16 para public 'data'

data ends

code segment use16 para public 'code'
    assume CS:code, DS:data, ES:data

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

end