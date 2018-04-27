; 输出单个字符
.386
public _cal
public _calRank
extrn _items:byte
__calvalue macro
    push bx
    mov ax, 12[di]
    imul ax, 16[di]
    mov bx, 10[di]
    imul bx, 14[di]
    sub ax, bx
    imul ax, 100
    cwd
    idiv bx
    mov 18[di], ax
    pop bx
endm

__calvalueplus macro
    __calvalue
    mov bx, ax
    add di, 3 * 20
    __calvalue
    sub di, 3 * 20
    add ax, bx
    sar ax, 1
    mov 18[di], ax
endm
_TEXT segment use16 byte public 'CODE'
    assume CS:_TEXT

_cal proc near
    lea di, _items
    mov cx, 3
CAL_ITEM_AVER_PROFIT:
    __calvalueplus 
    add di, 20
    dec cx
    jnz CAL_ITEM_AVER_PROFIT
    ret
_cal endp

_calRank proc near
    ;数据保存
    push ax
    push di
    push si
    push dx
    push cx
    push bx

    mov bx,1
    mov cx,offset _items+18
    add cx,3*20
    mov si,offset _items+18
    mov di,offset _items+78
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
    mov si,offset _items+18
    add si,ax
    mov ax,[si]
    mov si,offset _items+18
    add di,20
    mov dx,1
    inc bx
    jmp compare_item
btoc_return:
    mov word ptr offset _items+78, 3
    pop bx
    pop cx
    pop dx
    pop si
    pop di
    pop ax
    ret
_calRank endp


_TEXT ends
end