; New empty MBR for initialize Protect System
; This file is responsible for get input and test password, if Passed, Goto Decrypt.
; Location: MBR, HDD, 0,0,1
; 
;
; CAUTION: THE DATA WILL NOT BE RECOVEABLE, PLEASE USE IT AT YOUR OWN RISK.

org 7c00h

sTart:


getInput:


checkChoice:


callEncrypter:


callDecrypter:


callDirectBoot:


Note1:
    db "MBR Protect System: 1.Encrypt 2.Decrypt 3.Direct Boot"
LenNote1 equ ($-Note1)

ChoiceSaver:
    db 0

times 510-($-$$) db 0
db 0x55,0xAA ; Bootable Flag
