masm
model small
.stack 256
	
.code
main:
	
	
	mov AH, 01h
	int 21h
	
	push AX
	int 21h
	
	push AX
	int 21h
	
	push AX
	
	mov DL, 10
	mov AH, 02h
	
	int 21h
	mov DL, 13
	int 21h
	
	
	pop DX
	
	
	
	int 21h
	pop DX
	
	
	int 21h
	pop DX
	int 21h
	
	
	mov AX, 4c00h
	int 21h
end main


	