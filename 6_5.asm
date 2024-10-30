model small
.stack	100h
.data
stack_size db 0
.code
	assume DS:@data
start:
	mov AH, 01h
	int 21h
	
	sub AL, 30h
	mov stack_size, AL
	mov CL, AL
		
cycl:
	int 21h
	push AX
	;inc stack_size
	loop cycl
here:
	;xor ch,ch
	mov CL,	stack_size
	mov AH, 02h
cyc2:
	pop DX
	int 21h
	loop cyc2
exit:
	mov ax, 4c00h
	int 21h
end	start
