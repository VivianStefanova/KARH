masm
model	small
stack	256
.data 
len	equ	2	;разрядност на числото
b	db	 0
c	db	 0	
sum	db	2 dup (0)
.code
main:
	
	mov	ax,@data
	mov	ds,ax
	
	mov AH, 01h
	int 21h
	sub AL, 30h
	
	mov b, AL
	
	mov AH, 01h
	int 21h
	sub AL, 30h
	
	mov c, AL
	
	xor	bx,bx
	mov	cx,len
	
	mov	al,b
	adc	al,c
	aaa
	;add AL, 30h
	mov	sum[bx],al
	inc	bx
	adc	sum[bx],0
	
	

	mov AH, 02h
	
m1:
	add sum[BX],30h
	mov DL, sum[BX]
	
	
	int 21h
	dec BX
	loop	m1
	

	mov	ax,4c00h	
	int	21h
end main		
