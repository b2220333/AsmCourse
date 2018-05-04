.386
include utils.asm
extrn calRank:near, editItem:near
public ITEM_A_1, ITEM_A_2, IN_ITEM_NAME, IN_SHOP_NAME, ITEM_B_1, ITEM_B_2, ITEM_C_1, ITEM_C_2, ITEM_OTHERS_1, ITEM_OTHERS_2, TEMP_IN, SHOP_NAME_1, SHOP_NAME_2, TEMP_OUT, DIVID_OUTPUT, CRLF


data segment use16 para public 'data'
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

code segment use16 para public 'code'
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

code ends
end START



