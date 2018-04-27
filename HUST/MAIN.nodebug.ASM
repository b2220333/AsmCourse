	ifndef	??version
?debug	macro
	endm
$comm	macro	name,dist,size,count
	comm	dist name:BYTE:count*size
	endm
	else
$comm	macro	name,dist,size,count
	comm	dist name[size]:BYTE:count
	endm
	endif
	?debug	S "main.c"
	?debug	C E9B2759B4C066D61696E2E63
	?debug	C E928BB894A18433A5C5443322E305C494E434C5544455C73746469+
	?debug	C 6F2E68
	?debug	C E928BB894A18433A5C5443322E305C494E434C5544455C5F646566+
	?debug	C 732E68
	?debug	C E928BB894A18433A5C5443322E305C494E434C5544455C5F6E756C+
	?debug	C 6C2E68
_TEXT	segment byte public 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
_BSS	ends
_DATA	segment word public 'DATA'
_global_init	label	word
	db	10
	db	0
static_init	label	word
	db	232
	db	3
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	int main() {
   ;	
	assume	cs:_TEXT
_main	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	    static_var = 100;
   ;	
	mov	word ptr DGROUP:static_var,100
   ;	
   ;	    printf("this is a format string: %d %d", static_init, static_var);
   ;	
	push	word ptr DGROUP:static_var
	push	word ptr DGROUP:static_init
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr _printf
	add	sp,6
   ;	
   ;	    found();
   ;	
	call	near ptr _found
   ;	
   ;	    return 0;
   ;	
	xor	ax,ax
	jmp	short @1@58
@1@58:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_main	endp
_TEXT	ends
_BSS	segment word public 'BSS'
static_var	label	word
	db	2 dup (?)
_global	label	word
	db	2 dup (?)
	?debug	C E9
_BSS	ends
_DATA	segment word public 'DATA'
s@	label	byte
	db	'this is a format string: %d %d'
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
_TEXT	ends
	public	_main
_static_var	equ	static_var
_static_init	equ	static_init
	public	_global
	public	_global_init
	extrn	_found:near
	extrn	_printf:near
_s@	equ	s@
	end
