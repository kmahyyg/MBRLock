; This file is responsible for get input and Decrypt Data.
; Location: FDD,0,0,1


Note2: 
    db "Input Password: "
LenNote2 equ ($-Note2)

Note3: 
    db "Incorrect."
LenNote3 equ ($-Note3)

Note4: 
    db "Decrypt Done. Reboot Now."
LenNote4 equ ($-Note4)

TestStr:
    db "12345678"   ; Test string should be write to FDD,0,0,10
LenTestStr equ ($-TestStr)


;Padding with 0
times 512-($-$$) db 0 
;db 0x55,0xAA    ; Buggy Preset
