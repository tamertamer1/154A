##############################################################################
# File: div.s
# Skeleton for ECE 154a project
##############################################################################

	.data
student:
	.asciz "Marco Mora, Tamer Tamer" 	# Place your name in the quotations in place of Student
	.globl	student
nl:	.asciz "\n"
	.globl nl


op1:	.word 7	# divisor for testing
op2:	.word 19	# dividend for testing


	.text

	.globl main
main:					# main has to be a global label
	addi	sp, sp, -4		# Move the stack pointer
	sw 	ra, 0(sp)		# save the return address

	mv	t0, a0			# Store argc
	mv	t1, a1			# Store argv
				
	li	a7, 4			# print_str (system call 4)
	la	a0, student		# takes the address of string as an argument 
	ecall	

	slti	t2, t0, 2		# check number of arguments
	bne     t2, zero, operands
	j	ready

operands:
	la	t0, op1
	lw	a0, 0(t0)
	la	t0, op2
	lw	a1, 0(t0)
		

ready:
	jal	divide			# go to divide code

	jal	print_result		# print operands to the console

					# Usual stuff at the end of the main
	lw	ra, 0(sp)		# restore the return address
	addi	sp, sp, 4

	li      a7, 10
	ecall


divide:
##############################################################################
# Your code goes here.
# Should have the same functionality as running
#	divu	a2, a1, a0
# 	remu    a3, a1, a0 
# assuming a1 is unsigned divident, and a0 is unsigned divisor
##############################################################################
 
#a0 = divisor, a1 = dividend, a2 = quotient, a3 = remainder
	beqz a0,DONE # if a0==0, go to DONE (check if divisor is 0)
	lui a3,0  #initialize a3 with value of 0 (a3==0)
	add a3, a3, a1 # a3 remainder - store a1 divident , rem = dividend  (a3=a1)
	add t3, t3, a0 #temp to store a0 (t3=a0)
	slli t3, t3, 8 #shifting the divisor by 8 bits (t3 << 8)
	addi t4, zero, 0 #iterative for loop (t4=0)
	addi t5, zero, 9 #counter for the algo (t4<=9)
		
for:
	bge t4, t5, DONE #finishes loop (if t4<=9)
	sub a3, a3, t3 # remainder = rem - divisor (a3=a3-t3)
	blt a3, zero, ELSE # check remainder < 0 (if a3<0 then ELSE)
	#>= 0   case 
	slli a2, a2, 1 # shift quotient by 1 left (a2 << 1)
	ori a2, a2, 1 #setting lsb to 1 
	j MAIN_LOOP #jump to MAIN_LOOP

# < 0	
ELSE:
	#stroire we add divisor to remainder	
	add a3, a3, t3 #a3+=t3
	#shift quotient left b y 1
	slli a2, a2, 1 #a2 << 1
	#setting least sign bit to 0
	andi a2, a2, 0xFE 
	
MAIN_LOOP: 
	srai t3, t3, 1 #divisor shift by 1 
	addi t4, t4, 1 # counter total repetition t4+=1
	j for 
	
DONE:

##############################################################################
# Do not edit below this line
##############################################################################
	jr	ra


# Prints a0, a1, a2, a3
print_result:
	mv	t0, a0
	li	a7, 4
	la	a0, nl
	ecall

	mv	a0, t0
	li	a7, 1
	ecall
	li	a7, 4
	la	a0, nl
	ecall

	li	a7, 1
	mv	a0, a1
	ecall
	li	a7, 4
	la	a0, nl
	ecall

	li	a7, 1
	mv	a0, a2
	ecall
	li	a7, 4
	la	a0, nl
	ecall

	li	a7, 1
	mv	a0, a3
	ecall
	li	a7, 4
	la	a0, nl
	ecall

	jr ra
