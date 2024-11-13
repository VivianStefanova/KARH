model small
stack 256
.data	
a	db	 0
b	db	 0		
.code
.386
main:	
	mov ax, @data
	mov ds, ax
	xor ax, ax
	
	mov AH, 01h
	int 21h
	
	
	mov a, AL
	
	mov AH, 01h
	int 21h
	
	
	mov b, AL
	
	mov AL, a
	not AL
	 
	or AL, b
	
	not AL
	
	xor AL, b
	
	or AL, a
	
	mov DL, b
	and DL, a
	
	xor AL, DL
		

exit:				
	mov ax, 4c00h
	int 21h
end	main
