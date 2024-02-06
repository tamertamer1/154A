##############################################################################
# File: mult.s
# Skeleton for ECE 154a project
##############################################################################

	.data
student:
	.asciz "Marco Mora, Tamer Tamer" 	# Place your name in the quotations in place of Student
	.globl	student
nl:	.asciz "\n"
	.globl nl


op1:	.word 12			# change the multiplication operands
op2:	.word 12			# for testing.


	.text

	.globl main
main:					# main has to be a global label
	addi	sp, sp, -4		# Move the stack pointer
	sw 	ra, 0(sp)		# save the return address

	mv	t0, a0			# Store argc
	mv	t1, a1			# Store argv

# a7 = 8 read character
#  ecall
				
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
	jal	multiply		# go to multiply code

	jal	print_result		# print operands to the console




					# Usual stuff at the end of the main
	lw	ra, 0(sp)		# restore the return address
	addi	sp, sp, 4
	
	li      a7, 10
	ecall


multiply:
##############################################################################
# Your code goes here.
# Should have the same functionality as running 
#	mul	a2, a1, a0
# assuming a1 and a0 stores 8 bit unsigned numbers
##############################################################################
	
#a0 = multiplicand, a1 = multiplier, s0 = i, 
	add t4,a0,zero	#t4 = a0 //To preserve a0
	add t5,a1,zero	#t5 = a1 //To preserve a1
	addi a6,zero,0	#a6 = 0 //Base case of for loop
	addi t3,zero,8  #t3 = 8 //Used for condition of for loop

for :
	bge a6,t3,DONE     #if (a6 >= t3) then jump to done
	andi t6, t5,1      #t6 = (t5 & 0x1)
	beqz t6, MAIN_LOOP #if (t6 == 0) jump to MAIN_LOOP
	add a2, a2, t4  # a2 += 4

MAIN_LOOP:
	slli t4,t4,1 #t4 = t4 << 1
	srai t5,t5,1 #t5 = t5 >> 1
	addi a6, a6, 1 #a6 += 1
	j for  # repeat for loop
	
DONE: #finish loop

##############################################################################
# Do not edit below this line
##############################################################################
	jr	ra


print_result:

# print string or integer located in a0 (code a7 = 4 for string, code a7 = 1 for integer) 
	mv	t0, a0
	li	a7, 4
	la	a0, nl
	ecall
	
# print integer
	mv	a0, t0
	li	a7, 1
	ecall
# print string
	li	a7, 4
	la	a0, nl
	ecall
	
# print integer
	li	a7, 1
	mv	a0, a1
	ecall
# print string	
	li	a7, 4
	la	a0, nl
	ecall
	
# print integer
	li	a7, 1
	mv	a0, a2
	ecall
# print string	
	li	a7, 4
	la	a0, nl
	ecall

	jr      ra

