; Test string
; Note: Test string "12345678" should be written to FDD 1,0,0,4
; Note: It is used for test before decrypting MBR

teststr: db "12345678"
lenteststr: equ ($-teststr)

times 512-($-$$) db 0 
