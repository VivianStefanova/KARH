MASM
MODEL	small
STACK	256
.data
reverse	db  30 DUP (' ')
sourse	db	30 DUP (' ')
.code
	assume	ds:@data,es:@data
main:	

	mov	ax,@data
	mov	ds,ax 
	mov	es,ax

	mov AH, 01h
	int	21h
	xor BX,BX
write: mov sourse[BX], AL
		cmp BX, 30
		je here
		int 21h
		cmp AL, 0Dh
		je here
		inc BX
		jmp write
		
here: inc BX
	mov CX, BX
	dec BX
	xor SI,SI
	

rev:    mov AL, sourse[BX]
		mov reverse[SI], AL
		inc SI
		dec BX
		loop rev
		
next:
	inc SI
	mov CX, SI
	cld		
	lea	si,sourse 
	lea	di,reverse 
cycl:
	repe	cmps	sourse,reverse
	jcxz	equal	;cx=0 
	jne	not_match 
equal: 
	mov	ah,02h 
	mov	dx,'Y'
	int	21h
	jmp	exit 
not_match: 
	mov	ah,02h
	mov	dx,'N'
	int	21h 

exit:
	mov	ax,4c00h
	int	21h
end	main

