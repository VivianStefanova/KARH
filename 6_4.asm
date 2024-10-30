masm
model small
.data
.stack 256	
.code
main:

	mov AH, 01h
	int 21h
	

	
	mov AH, 02h
	mov DL, 10
	int 21h
	mov DL, 13
	int 21h
	
	
	cmp AL, 30h
	jb el
	
	cmp AL, 3Ah
	jb num
	
	cmp AL, 41h
	jb el
	
	cmp AL, 5Bh
	jb let
	
	cmp AL, 61h
	jb el
	
	cmp AL, 7Bh
	jb let
	
	jmp el
let:mov DL, 31h
 	jmp exit	
	
	
num:mov DL, 32h
 	jmp exit
el: mov DL, 33h	
	
exit:mov AH, 02h
	int 21h
	mov AX, 4c00h
	int 21h
end main


	