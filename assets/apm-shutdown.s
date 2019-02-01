mov ax,5301h
xor bx,bx
int 15h

mov ax,530eh
xor bx,bx
mov cx,0102h
mov ax,5307h
mov bx,1
mov cx,3
int 15h

times 510-($-$$) db 0
db 0x55,0xAA
