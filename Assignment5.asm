TITLE Assignment 5: This program will calculate the difference between two date inputs

COMMENT !
	Name: Arushi Rai
	Date: 2/14/2017
!

INCLUDE Irvine32.inc

.data

monthPrompt BYTE "Enter month: ", 0
dayPrompt BYTE "Enter day: ", 0
yearPrompt BYTE "Enter year: ",0
finalPrompt BYTE "This is the difference: ", 0
invalidResultPrompt BYTE "Invalid Result, enter valid input", 0ah, 0dh, 0

.code
MAIN PROC
	mov esi, 0
	monthInputPrompt: mov edx, OFFSET monthPrompt
	call WriteString
	call ReadDec
		
	; check validity of result and move to bl (month) and set cl as flag for 30 or 31 days
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	cmp al, 1
		jl errorRedo
		cmp al, 12
		jg errorRedo ;if al is not less than 12 then redo
		;result is valid, move month into bl
		mov bl, al
		cmp bl, 7
		jle firstHalfMonth
			inc eax
			mov cl, 2
			div cl
			mov cl, ah
			
			jmp dateInputPrompt
			firstHalfMonth: 			
				mov cl, 2
				div cl
				mov cl, ah

	jmp dateInputPrompt
	errorRedo: 
		mov edx, OFFSET invalidResultPrompt
		call WriteString
		jmp monthInputPrompt

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	dateInputPrompt: mov edx, OFFSET dayPrompt
	call WriteString
	call ReadDec

	;bh is MAX
	cmp bl, 2
	je L1					;if bl is 2, then day max is 28
		mov bh, 30
		add bh, cl
	jmp dayValidityCheck
		L1: mov bh, 28

	dayValidityCheck: 
		cmp al, 1
		jl errorRedo2
		cmp al, bh
		jg errorRedo2 ;if al is not less than MAX then redo
		;result is valid, move day into bh
		mov bh, al

	jmp yearInputPrompt
	errorRedo2: 
		mov edx, OFFSET invalidResultPrompt
		call WriteString
		jmp dateInputPrompt

	yearInputPrompt:
		mov edx, OFFSET yearPrompt
		call WriteString
		call ReadDec

 
		cmp eax, 1752
			jl errorRedo3
			cmp eax, 9999
				jg errorRedo3 ;if al is not less than MAX then redo
				;convert to days

			jmp looping
	
	errorRedo3: 
		mov edx, OFFSET invalidResultPrompt
		call WriteString
		jmp yearInputPrompt


	COMMENT !
	    m = (m + 9) % 12
		y = y - m/10
		day_num = 365*y + y/4 - y/100 + y/400 + (m*306 + 5)/10 + (d - 1)
	!

	looping:
		add bl, 9		;adds 9 to the month
		mov edi, eax	;moves year to edi, temporarily while eax is in usage when dividing for the remainder
		movzx eax, bl	;after saving the year in edi, move the month into eax for division calculation
		mov bl, 12		;moves divisor into bl
		div bl			;ax/bl -> ah:al
		mov bl, ah		;put the remainder (mod) into the bl register, which is storing our m value
		movzx eax, ah	;extend ah into the full eax register, to prepare for division by 10
		mov cl, 10		
		div cl			;divides eax by 10, so the month by ten
		movzx eax, al	;extend quotient into full register
		sub edi, eax	;subtract saved year by eax
		dec bh			;decrease number of days by one
		mov cx, 365		;move the multiplicand into the cx register
		mov eax, edi	;move the year into the eax
		mul cx			;dx:ax=365*edi

		;retreive dx:ax and put it in ebp
			push dx
			push ax
			pop ebp

		mov eax, edi	;move year into eax, to perform a series of calculations
		mov edx, 0		;clear edx
		mov ecx, 4		;move divisor of four into ecx
		div ecx			;edx:eax/ecx with eax storing quotient
		add ebp, eax	;add quotient to sumTotal
		mov eax, edi	;move year into eax
		mov edx, 0		;zero out edx
		mov ecx, 400	;move divisor of 400 into ecx
		div ecx			
		add ebp, eax	;add resulting eax (quotient) into ebp
		mov edx, 0		;zero out edx
		mov eax, edi	;put year into eax
		mov ecx, 100	;put 100 (divisor) into ecx
		div ecx			;year/100 = edx:eax

		sub ebp, eax	;ebp - (y/100)
		movzx ecx, bh	;mov day into 32-bit register
		add ebp, ecx	;add the day-1 into ebp
		mov eax, 306	;mov 306 in 16-bit cx
		movzx cx, bl	;mov the new month value into eax 
		mul cx			;store product into dx:ax, but value should only cover ax

		add ax, 5		;add 5 to 306*m
		mov ecx, 10
		mov edx, 0
		div ecx
		add ebp, eax

		cmp esi, 0
		jne finalComparison
			xchg esi, ebp
			jmp monthInputPrompt

			finalComparison: 
				sub ebp, esi
				mov eax, ebp
				mov edx, OFFSET finalPrompt
				call WriteString
				call WriteInt
	exit	
main ENDP
END main
