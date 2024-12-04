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
.code
	assume	ds:@data,es:@data
main:	

	mov	ax,@data
	mov	ds,ax 
	
	mov AH, 01h
	int	21h
	sub AL, 30h
	mov a, AL
	
	
	int 21H
	sub AL, 30h
	mov b, AL
	
	mov bl, a
	sub BL, b
	mov asubb, BL
	
	xor cx,cx
	lds dx, point_name1
	mov AH, 3CH
	int 21H	
	mov handle1, ax
	
	
	
	mov	bx,handle1 
	mov	cx,1
	add asubb, 30h
	lds	dx,point_asubb
	mov	ah,40h 
	int	21h 
	
	
	
	
	
	


exit:
	mov	ax,4c00h
	int	21h
end	main

