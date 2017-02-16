TITLE  Assignment 4: Calculate sum of coins
		
; Don't forget this beginning documentation block
; Name: 
; Date: 

INCLUDE Irvine32.inc

COMMENT !
Question 1 (10pts): 
Write code for a coin counting machine at a bank. Customers dump their jars of coins
into the machine and it tells them the amount of money they've deposited.
a. To simulate the number of each type of coins that the machine receives, 
   call the randomRange procedure to get a random number.
   See the sample code below and run it to see how randomRange works. Each time 
   randomRange is called, it creates a random number between 0 - 9.
   Once you figure out how randomRange works, remove the sample code but
   keep the randomize procedure call.
b. Create a constant called MAX and set it to 10
c. Call randomRange 4 times, seting the random number limit to MAX, to generate
   the number of pennies, nickels, dimes, and quarters that the machine receives.
   Then print the number of each type of coins that the machine receives.
d. calculate the total amount of money from the coins
e. Print the total as number of dollars and number of cents
   Print text explanation in your output, such as:   5 dollars and 18 cents
   And the output line of text should have a newline at the end.

DON'T MISS these additional requirements :
1. Except for text string variables, the program should use NO memory variables
2. Given the range of data used in the program, use the *smallest* data size (not DWORD)
   in all your calculation.

Sample program output:
9 pennies
3 nickels
3 dimes
0 quarters
0 dollars and 54 cents
Press any key to continue . . .
!
MAX=10
w_pennies=1
w_nickel=5
w_dimes=10
w_quarters=25

d_dollar=100

.data
o_pennies BYTE " pennies",0
o_nickel BYTE " nickels",0
o_dimes BYTE " dimes",0
o_quarters BYTE " quarters",0

o_dollars BYTE " dollars and ", 0
o_cents BYTE " cents", 0

.code
main PROC

	COMMENT ! Register assignment:
		pennies=bl
		nickels=bh
		dimes=cl
		quarters=ch
	!
	call randomize			; generate a seed for the random number generator. This is done once in the program.

	mov eax, MAX				; set upper limit for random number to 10
	call randomRange		; random number is returned in eax, with a range of 0-9
	mov bl, al

	mov edx, OFFSET o_pennies
	call WriteDec
	call WriteString
	call crlf
	mov dl, w_pennies
	mul dl
	mov bl, al

	mov eax, MAX				; set upper limit for random number to 10
	call randomRange		; random number is returned in eax, with a range of 0-9
	call WriteDec

	mov dl, w_nickel
	mul dl
	mov bh, al

	mov edx, OFFSET o_nickel
	call WriteString
	call crlf

	mov eax, MAX				; set upper limit for random number to 10
	call randomRange		; random number is returned in eax, with a range of 0-9
	call WriteDec

	mov dl, w_dimes
	mul dl
	mov cl, al
	
	mov edx, OFFSET o_dimes
	call WriteString
	call crlf

	mov eax, MAX				; set upper limit for random number to 10
	call randomRange		; random number is returned in eax, with a range of 0-9
	call WriteDec
	
	mov dl, w_quarters
	mul dl
	mov ch, al

	mov edx, OFFSET o_quarters
	call WriteString
	call crlf

	;add together to get total cents

	movzx ax,bl

	movzx bx, bh
	add ax, bx

	movzx dx, cl
	add ax, dx

	movzx cx, ch
	add ax, cx

	;divide ax and dollars=quotient, cents=remainder

	mov cl, d_dollar
	div cl

	mov bl, ah
	movzx eax, al
	mov edx, OFFSET o_dollars
	call WriteDec
	call WriteString

	movzx eax, bl
	call WriteDec

	mov edx, OFFSET o_cents
	call WriteString
	exit	
main ENDP

END main


COMMENT !
Question 2 (5pts)
Assume ZF, SF, CF, OF are all clear at the start, and the 3 instructions below run one after another. 
a. fill in the value of all 4 flags after each instruction runs 
b. explain why CF and OF flags have that value 
   Your explanation should not refer to signed or unsigned data values, 
   the ALU doesn't differentiate signed vs. unsigned and yet it can set the flags.

mov al, 60h 

add al, 70h     
; a. ZF = 0  SF = 1  CF = 0  OF = 1
; b. explanation for CF: There is no carry out
;    explanation for OF: Two positive numbers were added and the resulting signed value is negative

sub al, 0A0h     
; a. ZF = 0  SF = 0  CF = 0  OF = 0
; b. explanation for CF: There is no carry out
;    explanation for OF: There is no carry out nor carry in

!