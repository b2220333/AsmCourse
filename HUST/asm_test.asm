public _found
public _test_var
; 输出单个字符
__putc macro s
    mov dl, s
    mov ah, 2
    int 21h
endm

_DATA	segment word public 'DATA'
    _test_var label word
        db 10
        db 0
_DATA ends

_TEXT segment use16 byte public 'CODE'
    assume CS:_TEXT, DS:_DATA

_found proc near
    __putc 'a'
    mov word ptr _test_var, 20
    ret
_found endp
_TEXT ends
end