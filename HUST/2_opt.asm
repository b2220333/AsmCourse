extrn disptime:far
.386

__crlf macro
    lea dx, CRLF
    mov ah, 9 
    int 21h
endm

__putc macro s
    mov dl, s
    mov ah, 2
    int 21h
    __crlf
endm

__strlen macro s
    local LOOP, EXIT
    push di
    push ax
    lea di, s
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

__output macro s
    lea dx, s
    mov ah, 9
    int 21h
endm

__input macro s
    lea dx, s
    mov ah, 10 
    int 21h
    __crlf
    mov bl, s + 1
    mov bh, 0
    mov s + 2[bx], '$'
endm

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

__calvalue macro s
    mov ax, 12[s]
    imul ax, 16[s]
    mov bx, 10[s]
    imul bx, 14[s]
    sub ax, bx
    imul ax, 100
    cwd
    idiv bx
    mov 18[s], ax
endm

__calvalueplus macro s
    __calvalue s
    mov dx, ax
    add s, N * 20
    __calvalue s
    sub s, N * 20
    add ax, dx
    sar ax, 1

    mov 18[s], ax

endm

__showtime macro
    call disptime
endm

data segment use16
    N EQU 30
    CRLF DB 0dh, 0ah, '$'
    NOTE_USER_NAME DB 'Please input username:$'
    NOTE_USER_PWD DB 'Please input password:$'
    NOTE_INPUT_ITEM DB 'Please input item name:$'
    NOTE_AUTH_FAIL DB 'Wrong username/password, try again.$'
    B_NAME DB 'Wu Di', '$'
    PASSWORD DB 'qwerty', '$'

    SHOP_NAME_1 DB 'SHOP1', '$'
    SHOP_NAME_2 DB 'SHOP2', '$'

    ITEM_A_1 DB 'PEN', '$', 6 DUP(0)
             DW 35, 56, 70, 25, ?
    ITEM_B_1 DB 'BOOK', '$', 5 DUP(0)
             DW 12, 30, 25, 5, ?
    ITEM_C_1 DB 'BAG', '$', 6 DUP(0)
             DW 20, 40, 0EFFFh, 0000h, ?
    ITEM_OTHERS_1 DB N - 3 DUP('TEMPVALUE$', 15, 0, 20, 0, 30, 0, 2, 0, ?, ?)

    ITEM_A_2 DB 'PEN', '$', 6 DUP(0)
             DW 35, 50, 30, 24, ?
    ITEM_B_2 DB 'BOOK', '$', 5 DUP(0)
             DW 12, 28, 20, 15, ?
    ITEM_C_2 DB 'BAG', '$', 6 DUP(0)
             DW 18, 42, 32, 8, ?
    ITEM_OTHERS_2 DB N - 3 DUP('TEMPVALUE$', 15, 0, 20, 0, 30, 0, 2, 0, ?, ?)

    IN_NAME DB 11
            DB ?
            DB 11 dup(0)
    IN_PWD DB 7
           DB ?
           DB 7 dup(0)
    IN_ITEM_NAME DB 11
                 DB ?
                 DB 11 dup(0)
    AUTH DB 0
data ends

stack segment use16
stack ends

code segment use16 
    assume CS:code, DS:data, ES:data, SS:stack
START:
    mov ax, data
    mov ds, ax
    mov es, ax
    jmp CAL_DATA
INPUT_USERNAME:
    __output NOTE_USER_NAME
    __input IN_NAME

    mov dl, IN_NAME + 1
    cmp dl, 0
    jne CHECK_Q
    mov byte ptr AUTH, 0
    jmp CAL_DATA
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
    jmp CAL_DATA
AUTH_FAIL:
    __output NOTE_AUTH_FAIL
    __crlf
    jmp INPUT_USERNAME
CAL_DATA:
    __showtime
    mov cx, 6666 / 2
FEAT_3:
    push cx
    lea di, ITEM_C_1 
    mov ax, 14[di]
    cmp ax, 16[di]
    jbe INPUT_USERNAME 
    inc 16[ITEM_C_1]

    lea di, ITEM_A_1
    lea si, ITEM_B_1
    mov cx, N / 2
CAL_VALUE_1:
    __calvalueplus di
    add di, 40
    __calvalueplus si
    add si, 40

    dec cx
    jnz CAL_VALUE_1

    lea di, ITEM_C_1 
     mov ax, 14[di]
    cmp ax, 16[di]
    jbe INPUT_USERNAME 
    inc 16[ITEM_C_1]

    lea di, ITEM_A_1
    lea si, ITEM_B_1
    mov cx, N / 2
CAL_VALUE_2:
    __calvalueplus di
    add di, 40
    __calvalueplus si
    add si, 40

    dec cx
    jnz CAL_VALUE_2

    pop cx
    dec cx
    jnz FEAT_3
    __showtime

EXIT:
    mov ah, 4ch
    int 21h
code ends
end START
