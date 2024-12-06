MASM
MODEL	small
STACK	256
.data
handle1 dw 0
handle2 dw 0
name1 db 'sub.txt', 0
point_name1 dd name1
name2 db 'sum.txt', 0
point_name2 dd name2
a db 0
b db 0
asumb db 0
point_asumb dd asumb
asubb db 0
point_asubb dd asubb
minus db '-',0
point_minus dd minus
.code
	assume	ds:@data,es:@data
main:	

	mov	ax,@data
	mov	ds,ax 
	xor cx,cx
	;enter a and b
	mov AH, 01h
	int	21h
	sub AL, 30h
	mov a, AL
	
	
	int 21H
	sub AL, 30h
	mov b, AL
	
	; sub a b
	
	mov bl, a
	sub BL, b
	mov asubb, BL
	
	;open file sub.txt
	mov	al,02h 
	lds dx, point_name1
	mov AH, 3CH
	int 21H	
	mov handle1, ax
	
	;start writing sub.txt
	mov	bx,handle1
	mov	ah,40h 
	
	js negative
	;positive sub
	lds	dx,point_asubb
	mov	cx,1
	add asubb, 30h
	int	21h 
	
	jmp second 
	
negative:
	mov	ah,40h
	lds	dx,point_minus
	mov	cx,1
	int	21h 

	mov	ah,40h
	mov	cx,1
	not asubb
	add asubb,1
	add asubb, 30h
	lds	dx,point_asubb
	int	21h 
	
second:	
	;close sub.txt
	mov	ah,3Eh
	int 21h
	
	; sum a b
	mov BL, a
	add BL, b
	mov asumb, BL
	
	;open file sum.txt
	mov	al,02h 
	lds dx, point_name2
	mov AH, 3CH
	int 21H	
	mov handle2, ax
	
	;start writing sum.txt
	mov	bx,handle2
	
	;check for two digits
	xor AX,AX
	mov AL, asumb
	mov DL, 10
	div DL
	
	cmp AL, 1
	je double
	
	; write sum
	mov	ah,40h
	lds	dx,point_asumb
	mov	cx,1
	add asumb, 30h
	int	21h 
	
	jmp exit
	
	
double:	
	;write sum
	mov asubb , AL
	mov asumb , AH 
	mov	ah,40h
	lds	dx,point_asubb
	mov	cx,1
	add asubb, 30h
	int	21h 
	
	mov	ah,40h
	lds	dx,point_asumb
	mov	cx,1
	add asumb, 30h
	int	21h 

exit:
	;close sum.txt
	mov	ah,3Eh
	int 21h
	
	mov	ax,4c00h
	int	21h
end	main

