MASM
MODEL	small
STACK	256
.data
;file 
handle dw 0
testfileName db 'pinput.txt', 0
;file name max length - 12 char + .txt
fileName db 12 DUP (0)
point_fileName dd fileName

newLine db 0ah,0dh,'$'
point_newLine dd newLine

;number that will print from proc printNum
pNum dw 0
;check if thre is prior digit when printing a zero
printNumBool db 0

;longest english word - 45 letters
;word that will be searched
search db 50 DUP (" ")
searchLength db 0

cmpWord db 50 DUP (" ")
cmpWordLength db 0

;word count and position
cowstatr db 'count:'
count dw 0
row dw 1
column dw 1

rowstatr db 'Row:'
positionColumn dw 256 DUP (0)
positionRow dw 500 DUP (0)



;numer of sentences

sentences dw 0
sentencesOutputString db 'Number of sentences is: ','$'

;string from file
output db 500 DUP (" ")
point_output dd output

;number of bytes/char in file
outputLenght dw 0

;instructions
fileInstructions db	'Enter the name of the file with .txt - Max length 12 char + .txt',0ah,0dh,'$'
instructions db	'Enter a word that will be searched. ',0ah,0dh, 'Or . , ! - ?',0ah,0dh, 'Enter # for number of sentences.',0ah,0dh, '$'

;print if word is not found
notFoundOutput db 'Error 404: Word was not found in text!','$'

;print position function
space db '       ','$'
outputCount db ' - number of occurrences: ','$'
outputPosition db 'row:    column: ',0ah,0dh,'$'

.code
	assume	ds:@data,es:@data
main:
	;point to data
	mov	ax,@data
	mov	ds,ax 
	mov	es,ax 
	xor cx,cx
	
	
	;print instructions
	mov	ah,09h
	lea	dx,fileInstructions
	int	21h
	;enter filename
	xor bx,bx
	mov	ah,01h
	int 21h
	enterFileName: 
	cmp AL, 0dh
	je openFile
	mov fileName[BX], AL
	cmp BX, 12
	je openFile
	int 21h
	inc BX
	jmp enterFileName
	
	openFile:
	;open file 
	xor dx,dx
	mov	al,02h 
	;test
	;lea dx,testfileName
	lds dx, point_fileName
	mov AH, 3dh
	int 21H	
	jc fileError
	mov handle, ax
	jmp enterWord
	
fileError:
		;TODO: print error
		jmp exit
	
enterWord:	
	mov	ah,09h
	lea	dx,instructions
	int	21h
	
	;input word for search
	mov AH, 01h
	int	21h
	xor BX,BX
write: 
	cmp AL, 0dh
	je readFile
	mov search[BX], AL
	cmp BX, 50
	je readFile
	int 21h
	inc BX
	jmp write
	
wordError:
	;TODO print Error
	jmp exit

	
readFile:	
	cmp bl,0
	je wordError
	mov searchLength, BL
	;read fron file
	mov	bx,handle
	 
	lea dx, output
	mov cx, 500
	mov	ah,3fh
	int 21h
	
	mov outputLenght, ax
	
	;close file
	mov	ah,3Eh
	int 21h
	
	;start main functionality of program
	;preparation for loop
	xor bx,bx
	xor cx,cx
	mov cx, outputLenght
	
	cmp searchLength, 1
	jne wordSearch
	
	;is it #?
	cmp search[0], '#'
	jne isLetter
	
	
numOfSentences:	
	cmp output[bx], '.'
	je icnSentences
	cmp output[bx], '!'
	je icnSentences
	cmp output[bx], '?'
	je icnSentences
	inc bx
	loop numOfSentences
	jmp printSentance
icnSentences:
	inc sentences
	inc bx
	loop numOfSentences

printSentance:
	mov	ah,09h
	lea	dx,sentencesOutputString
	int	21h	
	mov ax, sentences
	mov pNum, ax
	call printNum
	jmp exit
	
	
isLetter:	
		
	cmp search[bx], 41h
	jb punctuationMarks
	
	cmp search[bx], 5bh
	jb wordSearch
	
	cmp search[bx], 61h
	jb punctuationMarks
	
	cmp search[bx], 7bh
	jb wordSearch
		
punctuationMarks:
	call positionTracker
	mov al, search[0]
	cmp output[bx], al
	je foundPunctuationMark
	inc bx
	loop punctuationMarks
	jmp printMark
	
foundPunctuationMark:
	call foundWord
	inc BX
	loop punctuationMarks
	jmp printMark
	
wordSearch:	

	cmp output[bx], 41h
	jb notLetter
	
	cmp output[bx], 5bh
	jb letter
	
	cmp output[bx], 61h
	jb notLetter
	
	cmp output[bx], 7bh
	jb letter

letter:
; add to cmpWord
	
	xor dx,dx
	mov dl, cmpWordLength
	xor si,si
	mov si,dx
	mov dl , output[bx]
	mov cmpWord[si], dl
	inc cmpWordLength
	jmp wordSearchContinue
	
notLetter:
	push cx
	call compareStrings
	pop cx

wordSearchContinue:		
	call positionTracker
	inc bx
	loop wordSearch
	
		
printMark:
	cmp count,0
	je notFound
	call printPosition

	
exit:
		
	mov	ax,4c00h
	int	21h
;ERROR
notFound:
	mov	ah,09h
	lea	dx,notFoundOutput
	int	21h
	jmp exit
	
;FUNCTIONS
	
;print 3-digit number from pNum
;IMP:: AX and DX is changed
printNum proc 
		;check for three digits
		
		xor AX,AX
		mov printNumBool,0
		mov ax, pNum
		mov DL, 100
		div DL
		cmp AL, 0
		je secondDigit
		
		
		;print digit
		mov	dl,al
		xor al,al
		ROL ax, 8
		mov pNum,ax
		mov	ah,02h 
		add dl, 30h
		int	21h 
		inc printNumBool
	secondDigit:
		xor AX,AX
		mov ax, pNum
		mov DL, 10
		div DL
		
		cmp printNumBool, 1
		je printDigit
	
		cmp AL, 0
		je oneDigit
		
	printDigit:
		
		;print digit
		mov	dl,al
		xor al, al
		ROL ax, 8
		mov pNum,ax
		mov	ah,02h 
		add dl, 30h
		int	21h
	oneDigit:
		mov	dx,pNum
		mov	ah,02h 
		add dl, 30h
		int	21h
		
		ret
printNum endp		

;change:ax dx
printNewLine proc
		mov	ah,09h
		xor dx,dx
		lds	dx,point_newLine
		int	21h
		ret
printNewLine endp	

printPosition proc
		;print search
		xor cx,cx
		xor bx,bx
		xor dx,dx
		mov cl , searchLength
		mov	ah,02h
	printSearch:	
		mov dl, search[bx]
		int	21h
		inc BX
		loop printSearch
		
		;print count
		mov	ah,09h
		lea	dx,outputCount
		int	21h	
		mov ax, count
		mov pNum, ax
		call printNum
		call printNewLine
		mov	ah,09h
		lea	dx,outputPosition
		int	21h
		
		xor si,si
		xor bx,bx
		xor cx,cx
		mov cx , count
		
	print:
		mov si,bx
		SAL si,1
		mov ax, positionRow[si]
		mov pNum, ax
		call printNum
		mov	ah,09h
		lea	dx,space
		int	21h
		mov ax, positionColumn[si]
		mov pNum, ax
		call printNum
		call printNewLine
		inc bx
		loop print
			
		ret
printPosition endp	

positionTracker proc
		cmp output[bx], ' '
		je incColumn
		cmp output[bx], 0dh
		je incRow
		mov al, search[0]
		jmp finish
		
	incColumn: 
		inc column
		jmp finish
		
	incRow:
		inc row
		mov column,1

	finish:
		ret
positionTracker endp

foundWord proc
		xor si,si
		mov si, count
		SAL si, 1
		mov dx, column
		mov positionColumn[si], dx
		mov dx, row
		mov positionRow[si], dx
		inc count
		ret
foundWord endp

compareStrings proc
		xor ax,ax
		mov al, searchLength
		cmp al, cmpWordLength
		jne clearCmpWord
		
		cld	
		xor si,si
		xor di,di
		lea	si,search 
		lea	di,cmpWord 
		xor cx,cx
		mov	cl,searchLength 
	check:
		repe	cmps	search,cmpWord
		;for 1 letter search
		jne	clearCmpWord
		jcxz	equal  
	equal: 
		call foundWord
	
	clearCmpWord:
		mov cmpWordLength,0
		
		ret
compareStrings endp
		
end	main
