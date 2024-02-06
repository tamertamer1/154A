##############################################################################
# File: sort.s
# Skeleton for ECE 154A
##############################################################################

	.data
student:
	.asciz "Marco Mora, Tamer Tamer:\n" 	# Place your name in the quotations in place of Student
	.globl	student
nl:	.asciz "\n"
	.globl nl
sort_print:
	.asciz "[Info] Sorted values\n"
	.globl sort_print
initial_print:
	.asciz "[Info] Initial values\n"
	.globl initial_print
read_msg: 
	.asciz "[Info] Reading input data\n"
	.globl read_msg
code_start_msg:
	.asciz "[Info] Entering your section of code\n"
	.globl code_start_msg

key:	.word 268632064			# Provide the base address of array where input key is stored(Assuming 0x10030000 as base address)
output:	.word 268632144			# Provide the base address of array where sorted output will be stored (Assuming 0x10030050 as base address)
numkeys:	.word 6				# Provide the number of inputs
maxnumber:	.word 11			# Provide the maximum key value


## Specify your input data-set in any order you like. I'll change the data set to verify
data1:	.word 7
data2:	.word 2
data3:	.word 4
data4:	.word 1
data5:	.word 9
data6:	.word 3

	.text

	.globl main
main:					# main has to be a global label
	addi	sp, sp, -4		# Move the stack pointer
	sw 	ra, 0(sp)		# save the return address
			
	li	a7, 4			# print_str (system call 4)
	la	a0, student		# takes the address of string as an argument 
	ecall	

	jal process_arguments
	jal read_data			# Read the input data

	j	ready

process_arguments:
	
	la	t0, key
	lw	a0, 0(t0)
	la	t0, output
	lw	a1, 0(t0)
	la	t0, numkeys
	lw	a2, 0(t0)
	la	t0, maxnumber
	lw	a3, 0(t0)
	jr	ra	

### This instructions will make sure you read the data correctly
read_data:
	mv t1, a0
	li a7, 4
	la a0, read_msg
	ecall
	mv a0, t1

	la t0, data1
	lw t4, 0(t0)
	sw t4, 0(a0)
	la t0, data2
	lw t4, 0(t0)
	sw t4, 4(a0)
	la t0, data3
	lw t4, 0(t0)
	sw t4, 8(a0)
	la t0, data4
	lw t4, 0(t0)
	sw t4, 12(a0)
	la t0, data5
	lw t4, 0(t0)
	sw t4, 16(a0)
	la t0, data6
	lw t4, 0(t0)
	sw t4, 20(a0)

	jr	ra


counting_sort:
######################### 
## your code goes here ##
#########################

	#a0 = keys base arr address, a1 = output arr base address
	#a2 = numkeys, a3 = maxnumber
	#s2 = n, s3 = count base address
	addi t0, a3, 1 #t0 = maxnumber + 1 for array size
	slli t0, t0, 2 #multiply array size by 4 to account for maxnumber + 1 words
	sub sp, sp, t0 #make space on the stack for maxnumber + 1 array locations
	addi s2, zero, 0 #set n = 0 for for1
for1:	
	blt a3, s2, end1 #if maxNumber < n then jump to end1
	slli t0, s2, 2 #increasing the address offset of count[n] by 4 each iteration
	add t0, t0, sp #address of count[n] in t0
	lw t1, 0(t0) #t1 = count[n]
	addi t1, zero, 0 #count[n] = 0
	sw t1, 0(t0) #count[n] = t1
	addi s2, s2, 1 #n = n + 1
	j for1	#repeat for1 loop
	
end1:
	addi s2, zero, 0 #set n = 0 for for2
for2:
	bge s2, a2, end2 #if n >= numkeys then jump to end2
	slli t2, s2, 2 #increasing the address offset of keys[n] by 4 each iteration
	add t2, t2, a0 # address of keys[n] in t2
	lw t3, 0(t2) #t3 = keys[n]
	slli t0, t3, 2 #increasing the address offset of count[n] by keys[n] * 4 each iteration
	add t0, t0, sp #address of count[keys[n]] in t0
	lw t1, 0(t0) #t1 = count[keys[n]]
	addi t1, t1, 1 #count[keys[n]]++
	sw t1, 0(t0) #count[keys[n]] = t1
	addi s2, s2, 1 #n++
	j for2 # repeat loop
end2:
	addi s2, zero, 1 #set n = 1 for for3
for3:
	blt a3, s2, end3 #if maxNumber < n then jump to end3
	slli t0, s2, 2 #increasing the address offset of count[n] by 4 each iteration
	add t0, t0, sp #address of count[n] in t0
	lw t1, 0(t0) #t1 = count[n]
	addi t2, t0, -4 #store address of count[n-1] in t2
	lw t3, 0(t2) #t3 = count[n-1]
	add t1, t1, t3 #t1 = count[n] + count[n-1]
	sw t1, 0(t0) #count[n] = t1
	addi s2, s2, 1 #n++
	j for3 # repeat loop
end3:
	addi s2, zero, 0 #set n = 0 for for4
for4:
	bge s2, a2, end4 #if n >= numKeys then jump to end4
	slli t2, s2, 2 #increases the address offset of keys[n] by 4 each iteration
	add t2, t2, a0 #address of keys[n] in t2
	lw t3, 0(t2) #t3 = keys[n]
	slli t0, t3, 2 #increases the address offset of count[keys[n]] by 4 each iteration
	add t0, t0, sp #address of count[keys[n]] in t0
	lw t1, 0(t0) #t1 = count[keys[n]]
	addi t1, t1, -1 #t1 = count[keys[n]] - 1
	sw t1, 0(t0) #count[keys[n]]--
	slli t4, t1, 2 #increases address offset of output[count[keys[n]]-1] by 4 each iteration
	add t4, t4, a1 #address of output[count[keys[n]]-1] in t4
	lw t5, 0(t4) #t5 = output[count[n]]-1]
	add t5, zero, t3 #t5 = keys[n]
	sw t5, 0(t4) #output[count[keys[n]]-1] = t5
	addi s2, s2, 1 # n++
	j for4 #repeat loop for4
	
end4:
	addi t0, a3, 1 #t0 = maxnumber + 1 for array size
	slli t0, t0, 2 #multiply array size by 4 to account for maxnumber + 1 words
	add sp, sp, t0 #deallocating memory on stack
#########################
 	jr ra
#########################


##################################
#Dont modify code below this line
##################################
ready:
	jal	initial_values		# print operands to the console
	
	mv 	t2, a0
	li 	a7, 4
	la 	a0, code_start_msg
	ecall
	mv 	a0, t2

	jal	counting_sort		# call counting sort algorithm

	jal	sorted_list_print


				# Usual stuff at the end of the main
	lw	ra, 0(sp)		# restore the return address
	addi	sp, sp, 4
	
	li a7, 10
	ecall
	
	#jr	ra			# return to the main program

print_results:
	add t0, zero, a2 # No of elements in the list
	add t1, zero, a0 # Base address of the array
	mv t2, a0    # Save a0, which contains base address of the array

loop:	
	beq t0, zero, end_print
	addi, t0, t0, -1
	lw t3, 0(t1)
	
	li a7, 1
	mv a0, t3
	ecall

	li a7, 4
	la a0, nl
	ecall

	addi t1, t1, 4
	j loop
end_print:
	mv a0, t2 
	jr ra	

initial_values: 
	mv 	t2, a0
        addi	sp, sp, -4		# Move the stack pointer
	sw 	ra, 0(sp)		# save the return address

	li a7, 4
	la a0, initial_print
	ecall
	
	mv 	a0, t2
	jal print_results
 	
	lw	ra, 0(sp)		# restore the return address
	addi	sp, sp, 4

	jr ra

sorted_list_print:
	mv 	t2, a0
	addi	sp, sp, -4		# Move the stack pointer
	sw 	ra, 0(sp)		# save the return address

	li a7,4
	la a0,sort_print
	ecall
	
	mv a0, t2
	
	#swap a0,a1
	mv t2, a0
	mv a0, a1
	mv a1, t2
	
	jal print_results
	
    #swap back a1,a0
	mv t2, a0
	mv a0, a1
	mv a1, t2
	
	lw	ra, 0(sp)		# restore the return address
	addi	sp, sp, 4	
	jr ra
