_TEXT	segment byte public 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public 'DATA'
_DATA	ends
_BSS	segment word public 'BSS'
_BSS	ends
_DATA	segment word public 'DATA'
_global_init	label	word
	db	10
	db	0
static_init	label	word
	db	232
	db	3
_string	label	word
	dw	DGROUP:s@
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	int main() {
   ;	
	assume	cs:_TEXT
_main	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
   ;	
   ;	    int value = 666;
   ;	
	mov	word ptr [bp-2],666
   ;	
   ;	    test_fun(&value);
   ;	
	lea	ax,word ptr [bp-2]
	push	ax
	call	near ptr _test_fun
	pop	cx
   ;	
   ;	    printf("var from asm:%d\n", var_from_asm);
   ;	
	push	word ptr DGROUP:_var_from_asm
	mov	ax,offset DGROUP:s@+12
	push	ax
	call	near ptr _printf
	pop	cx
	pop	cx
   ;	
   ;	    printf("assign from asm:%d\n", global);
   ;	
	push	word ptr DGROUP:_global
	mov	ax,offset DGROUP:s@+29
	push	ax
	call	near ptr _printf
	pop	cx
	pop	cx
   ;	
   ;	    printf("value passed by stack:%d\n", global_init);
   ;	
	push	word ptr DGROUP:_global_init
	mov	ax,offset DGROUP:s@+49
	push	ax
	call	near ptr _printf
	pop	cx
	pop	cx
   ;	
   ;	    return 0;
   ;	
	xor	ax,ax
	jmp	short @1@58
@1@58:
   ;	
   ;	}
   ;	
	mov	sp,bp
	pop	bp
	ret	
_main	endp
_TEXT	ends
_BSS	segment word public 'BSS'
static_var	label	word
	db	2 dup (?)
_global	label	word
	db	2 dup (?)
_BSS	ends
_DATA	segment word public 'DATA'
s@	label	byte
	db	'test string'
	db	0
	db	'var from asm:%d'
	db	10
	db	0
	db	'assign from asm:%d'
	db	10
	db	0
	db	'value passed by stack:%d'
	db	10
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
_TEXT	ends
	public	_main
	public	_string
_static_var	equ	static_var
_static_init	equ	static_init
	public	_global
	public	_global_init
	extrn	_var_from_asm:word
	extrn	_test_fun:near
	extrn	_printf:near
_s@	equ	s@
	end
