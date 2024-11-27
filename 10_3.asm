MASM
MODEL	small
STACK	256
.data
reverse	db  30 DUP (' ')
sourse	db	30 DUP (' ')
words   db  0
symbols db  2 DUP (0)

.code
	assume	ds:@data,es:@data
main:	

	mov	ax,@data
	mov	ds,ax 
	mov	es,ax

	mov AH, 01h
	int	21h
	xor BX,BX
	xor CX,CX
write: mov sourse[BX], AL
		cmp AL, 20h
		jne spaceCheck
		je spaceCheck2

cycl:		

		cmp BX, 29
		je exit
		int 21h
		cmp AL, 0Dh
		je exit
		inc BX
		jmp write
		
here: inc BX
	
	


spaceCheck: 
		cmp CX, 0h
		je startWord
		jmp cycl
	
startWord: inc words
		   inc CX
		   jmp cycl
spaceCheck2: 
		cmp CX, 1h
		je endWord
		jmp cycl
		
endWord: 
		dec CX	
		jmp cycl
		
exit:
	xor AX,AX
	mov AL, words
	mov DL, 10
	div DL
	mov DL, AL
	add DL, 30h
	mov CL, AH
	add CL, 30h
	mov AH , 02h
	int 21h
	mov DL, CL
	int 21h
	



	mov	ax,4c00h
	int	21h
end	main

