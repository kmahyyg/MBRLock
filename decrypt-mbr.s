; This file is responsible for get input and Decrypt Data.
; Location: FDD,0,0,1


int 19h ; for reboot

Note2: 
    db "Input Password: ",10,13
LenNote2 equ ($-Note2)

Note3: 
    db "Incorrect.",10,13
LenNote3 equ ($-Note3)

Note4: 
    db "Decrypt Done. Reboot Now."
LenNote4 equ ($-Note4)

TestStr:
    db "12345678"   ; Test string should be write to FDD,0,0,10
LenTestStr equ ($-TestStr)

;Padding with 0
times 512-($-$$) db 0 

