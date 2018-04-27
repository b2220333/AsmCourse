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
	?debug	C E9078D9B4C066D61696E2E63
	?debug	C E928BB894A18433A5C5443322E305C494E434C5544455C73746469+
	?debug	C 6F2E68
	?debug	C E928BB894A18433A5C5443322E305C494E434C5544455C5F646566+
	?debug	C 732E68
	?debug	C E928BB894A18433A5C5443322E305C494E434C5544455C5F6E756C+
	?debug	C 6C2E68
	?debug	C E928BB894A19433A5C5443322E305C494E434C5544455C73747269+
	?debug	C 6E672E68
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
_A1	label	word
	db	80
	db	69
	db	78
	db	36
	db	6 dup (0)
	db	35
	db	0
	db	56
	db	0
	db	70
	db	0
	db	25
	db	0
	db	2 dup (0)
_B1	label	word
	db	66
	db	79
	db	79
	db	75
	db	36
	db	5 dup (0)
	db	12
	db	0
	db	30
	db	0
	db	25
	db	0
	db	15
	db	0
	db	2 dup (0)
_C1	label	word
	db	66
	db	65
	db	71
	db	36
	db	6 dup (0)
	db	20
	db	0
	db	40
	db	0
	db	30
	db	0
	db	20
	db	0
	db	2 dup (0)
_A2	label	word
	db	80
	db	69
	db	78
	db	36
	db	6 dup (0)
	db	35
	db	0
	db	50
	db	0
	db	30
	db	0
	db	24
	db	0
	db	2 dup (0)
_B2	label	word
	db	66
	db	79
	db	79
	db	75
	db	36
	db	5 dup (0)
	db	12
	db	0
	db	28
	db	0
	db	20
	db	0
	db	5
	db	0
	db	2 dup (0)
_C2	label	word
	db	66
	db	65
	db	71
	db	36
	db	6 dup (0)
	db	18
	db	0
	db	42
	db	0
	db	32
	db	0
	db	20
	db	0
	db	2 dup (0)
_SHOP_NAME_1	label	word
	dw	DGROUP:s@
_SHOP_NAME_2	label	word
	dw	DGROUP:s@+7
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void printf_(char *out) {
   ;	
	assume	cs:_TEXT
_printf_	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
	mov	di,word ptr [bp+4]
   ;	
   ;	    int i = 0;
   ;	
	xor	si,si
	jmp	short @1@142
@1@58:
   ;	
   ;	    while(out[i] != '$') {
   ;	        putchar(*(out + i++));
   ;	
	inc	word ptr DGROUP:__streams+16
	jge	short @1@114
	mov	bx,si
	inc	si
	mov	al,byte ptr [bx+di]
	mov	bx,word ptr DGROUP:__streams+26
	inc	word ptr DGROUP:__streams+26
	mov	byte ptr [bx],al
	mov	ah,0
	jmp	short @1@142
@1@114:
	mov	ax,offset DGROUP:__streams+16
	push	ax
	mov	bx,si
	inc	si
	mov	al,byte ptr [bx+di]
	push	ax
	call	near ptr __fputc
	pop	cx
	pop	cx
@1@142:
	mov	bx,si
	cmp	byte ptr [bx+di],36
	jne	short @1@58
   ;	
   ;	    }
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_printf_	endp
   ;	
   ;	void scanf_(char *in) {
   ;	
	assume	cs:_TEXT
_scanf_	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	    scanf("%s", in);
   ;	
	push	word ptr [bp+4]
	mov	ax,offset DGROUP:s@+14
	push	ax
	call	near ptr _scanf
	pop	cx
	pop	cx
   ;	
   ;	    len = strlen(in_item);
   ;	
	mov	ax,offset DGROUP:_in_item
	push	ax
	call	near ptr _strlen
	pop	cx
	mov	word ptr DGROUP:_len,ax
   ;	
   ;	    in_item[len] = '$';
   ;	
	mov	bx,word ptr DGROUP:_len
	mov	byte ptr DGROUP:_in_item[bx],36
   ;	
   ;	    in_item[len + 1] = 0;    
   ;	
	mov	bx,word ptr DGROUP:_len
	mov	byte ptr DGROUP:_in_item[bx+1],0
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_scanf_	endp
   ;	
   ;	int feat_1() {
   ;	
	assume	cs:_TEXT
_feat_1	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	    printf("Please input item name:");
   ;	
	mov	ax,offset DGROUP:s@+17
	push	ax
	call	near ptr _printf
	pop	cx
   ;	
   ;	    return 0;
   ;	
	xor	ax,ax
	jmp	short @3@58
@3@58:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_feat_1	endp
   ;	
   ;	int main() {
   ;	
	assume	cs:_TEXT
_main	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	    feat_1();
   ;	
	call	near ptr _feat_1
   ;	
   ;	    return 0;
   ;	
@4@58:
	xor	ax,ax
	jmp	@4@730
@4@86:
   ;	
   ;	START:
   ;	    do {
   ;	        printf("1. Query item infomation\n");
   ;	
	mov	ax,offset DGROUP:s@+41
	push	ax
	call	near ptr _printf
	pop	cx
   ;	
   ;	        printf("2. Edit item infomation\n");
   ;	
	mov	ax,offset DGROUP:s@+67
	push	ax
	call	near ptr _printf
	pop	cx
   ;	
   ;	        printf("3. Calculate average profit\n");
   ;	
	mov	ax,offset DGROUP:s@+92
	push	ax
	call	near ptr _printf
	pop	cx
   ;	
   ;	        printf("4. Calculate profit rank\n");
   ;	
	mov	ax,offset DGROUP:s@+121
	push	ax
	call	near ptr _printf
	pop	cx
   ;	
   ;	        printf("5. Show all item infomation\n");
   ;	
	mov	ax,offset DGROUP:s@+147
	push	ax
	call	near ptr _printf
	pop	cx
   ;	
   ;	        printf("6. Exit\n");
   ;	
	mov	ax,offset DGROUP:s@+176
	push	ax
	call	near ptr _printf
	pop	cx
   ;	
   ;	    } while (((in_char = getchar()) < '1' || in_char > '6') && getchar());
   ;	
	dec	word ptr DGROUP:__streams
	jl	short @4@170
	mov	bx,word ptr DGROUP:__streams+10
	inc	word ptr DGROUP:__streams+10
	mov	al,byte ptr [bx]
	jmp	short @4@198
@4@170:
	mov	ax,offset DGROUP:__streams
	push	ax
	call	near ptr __fgetc
	pop	cx
@4@198:
	mov	byte ptr DGROUP:_in_char,al
	cmp	al,49
	jl	short @4@254
	cmp	byte ptr DGROUP:_in_char,54
	jle	short @4@366
@4@254:
	dec	word ptr DGROUP:__streams
	jl	short @4@310
	mov	bx,word ptr DGROUP:__streams+10
	inc	word ptr DGROUP:__streams+10
	mov	al,byte ptr [bx]
	mov	ah,0
	jmp	short @4@338
@4@310:
	mov	ax,offset DGROUP:__streams
	push	ax
	call	near ptr __fgetc
	pop	cx
@4@338:
	or	ax,ax
	je	@@0
	jmp	@4@86
@@0:
@4@366:
   ;	
   ;	    switch (in_char) {
   ;	
	mov	al,byte ptr DGROUP:_in_char
	cbw	
	dec	ax
	mov	bx,ax
	cmp	bx,5
	ja	short @4@702
	shl	bx,1
	jmp	word ptr cs:@4@C754[bx]
@4@450:
   ;	
   ;	    case 1:
   ;	        if (feat_1()) {
   ;	
	call	near ptr _feat_1
	or	ax,ax
	je	short @4@506
   ;	
   ;	            goto START;
   ;	
	jmp	@4@86
@4@506:
   ;	
   ;	        }
   ;	        break;
   ;	
	jmp	short @4@702
@4@534:
   ;	
   ;	    case 2:
   ;	        break;
   ;	
	jmp	short @4@702
@4@562:
   ;	
   ;	    case 3:
   ;	        break;
   ;	
	jmp	short @4@702
@4@590:
   ;	
   ;	    case 4:
   ;	        break;
   ;	
	jmp	short @4@702
@4@618:
   ;	
   ;	    case 5:
   ;	        break;
   ;	
	jmp	short @4@702
@4@646:
   ;	
   ;	    case 6:
   ;	        return 0;
   ;	
	jmp	@4@58
   ;	
   ;	        break;
   ;	
	jmp	short @4@702
@4@702:
	jmp	@4@58
@4@730:
   ;	
   ;	    }
   ;	    return 0;
   ;	}
   ;	
	pop	bp
	ret	
_main	endp
@4@C754	label	word
	dw	@4@450
	dw	@4@534
	dw	@4@562
	dw	@4@590
	dw	@4@618
	dw	@4@646
_TEXT	ends
_BSS	segment word public 'BSS'
_p	label	word
	db	2 dup (?)
_len	label	word
	db	2 dup (?)
_in_item	label	byte
	db	11 dup (?)
_in_char	label	byte
	db	1 dup (?)
	?debug	C E9
_BSS	ends
_DATA	segment word public 'DATA'
s@	label	byte
	db	'shop1$'
	db	0
	db	'shop2$'
	db	0
	db	'%s'
	db	0
	db	'Please input item name:'
	db	0
	db	'1. Query item infomation'
	db	10
	db	0
	db	'2. Edit item infomation'
	db	10
	db	0
	db	'3. Calculate average profit'
	db	10
	db	0
	db	'4. Calculate profit rank'
	db	10
	db	0
	db	'5. Show all item infomation'
	db	10
	db	0
	db	'6. Exit'
	db	10
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
_TEXT	ends
	public	_main
	public	_p
	public	_feat_1
	public	_scanf_
	public	_printf_
	public	_len
	public	_in_item
	public	_in_char
	public	_SHOP_NAME_2
	public	_SHOP_NAME_1
	public	_C2
	public	_B2
	public	_A2
	public	_C1
	public	_B1
	public	_A1
	extrn	_strlen:near
	extrn	__fputc:near
	extrn	__fgetc:near
	extrn	_scanf:near
	extrn	_printf:near
	extrn	__streams:word
_s@	equ	s@
	end
