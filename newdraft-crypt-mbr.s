; This file is responsible for get input and Encrypt Data
; Location: FDD,0,0,2
; initial input:     decrypt 1 / encrypt 0
; initial input:     password (len<=8)  512/8=64
;     Note: if first method bit is input wrongly, MBR will encrypted twice.
;     Note: if the password is tested to be correct it should be fine.
; Test String 12345678 will be used for password check.
; MBR: Stored in 0,0,3,HDD1

start:



encrypt:


; Data region
Note2: 
    db "Input Password: "
LenNote2 equ ($-Note2)

Note4: 
    db "Encrypt Done. Halt Now."
LenNote4 equ ($-Note4)

; End of Data Region

 times 510-($-$$) db 0    ; 1 Sector
 db 0x55,0xAA           ; bootable flag
