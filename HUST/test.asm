.386
code segment use16
    assume cs:code
START:
    mov eax, 5
    sal eax, 2
    mov edx, eax
    lea edx, [edx + 8 * eax]
    sal eax, 4 
    lea edx, [edx + eax]
    mov ah, 4ch
    int 21h
code ends
end START