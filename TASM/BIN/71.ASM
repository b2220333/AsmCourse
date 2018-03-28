assume cs:code,ds:data,ss:table

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5653,8226
    dw 11542,14430,15257,17800

data ends

table segment
    db 21 dup ('year sumn ne ?? ')
table ends

code segment

start:
    mov ax,table
    mov ss,ax
    mov bp,0

    mov ax,data
    mov ds,ax

    mov si,0 ;table:0 10h 20h
    mov bx,0
    mov cx,21
s:  mov ax,[0+bx]
    mov ss:[si+0],ax
    mov ax,[2+bx]
    mov ss:[si+2],ax
    mov ax,' '
    mov ss:[si+4],ax

    mov ax,[84+bx]
    mov ss:[si+5],ax
    mov ax,[86+bx]
    mov ss:[si+7],ax
    mov ax,' '
    mov ss:[si+9],ax
    mov ax,bx
    mov dl,2
    div dl 
    mov di,ax
    mov ax,[168+di]
    mov ss:[si+10],ax
    mov ax,' '
    mov ss:[si+12],ax
    mov ax,ss:[si+5]
    mov dx,ss:[si+7]
    div word ptr ss:[si+10]
    mov ss:[si+13],ax
    mov ax,' '
    mov ss:[si+15],ax

    add bx,4
    add si,16
    loop s

    mov ax,4c00h
    int 21h

code ends

end start

        

        