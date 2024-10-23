masm
model small
.stack 256
	
.code
main:
	
	
	mov AH, 01h
	int 21h
	
	mov AH, 20h
	
	push '$'
	
	push AX
	mov AH, 01h
	int 21h
	mov AH, 20h
	
	
	push AX
	mov AH, 01h
	int 21h
	mov AH, 20h
	push AX
	
	
	mov DL, 10
	mov AH, 02h
	
	int 21h
	mov DL, 13
	int 21h
	
	mov	ax,@stack
	mov	ds,ax
	
	mov	AH,9
	mov	DX, SP
	int	21h	
	
	
	mov AX, 4c00h
	int 21h
end main


	