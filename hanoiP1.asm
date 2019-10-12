
# Author: Sergio Méndez, Oscar Cortés
# Date: Oct 12, 2019

# Registers:

# Hanoi towers code using recursive instructions and limited instruction set
# It uses a variable for number of disks in tower 1, pointers to the first direction of the towers and a counter
# to the total of elements in each tower multipled by 4 to serve as a couter

.data

.text 
	addi $a0, $zero, 8		# Number of disks
	addi $a1, $zero, 0x10010000	# Address of init tower
	addi $a2, $zero, 0x10010020     # Address of aux tower
	addi $a3, $zero, 0x10010040	# Address of dest tower
	
	addi $s1, $zero, -4		# Indication of no disks is -4 on number of disks' pointer
	addi $s2, $zero, -4
	addi $s3, $zero, -4

	add $t0, $zero, $a0		# t0 = number of disks, serves as counter
	addi $t1, $zero, 0x10010000	# t1 = pointer to the first tower
	
initial:	#Loading of disks to init tower
	beq $t0, $zero, main	# If tower is full, go to main
	sw $t0, 0($t1)		# Saves the disk in it's current postion
	addi $t1, $t1, 4	# Increment tower address pointer to go to next position
	addi $s1, $s1, 4	# Increase the number of disks in initial tower
	addi $t0, $t0, -1	# Decrement value of t0 to add the next value
	j initial		# Loop the instrucion
		
main:				
	jal hanoi		# Go to the code	
	j end			# End the code

hanoi:  # Non-recursive section
	addi $t0, $zero, 1	# Increase t0 in 1, t0 starts in 0 after filling
	bne $a0, $t0, else	# If n = 1, moves the first disk ot dest, if not do the algorithm in else
	add $t1, $zero, $ra	# load in t1 the return address
	jal firstCase		# jump to the first case, moving a1(init) to a3(aux)
	jr $t1
	
else:	# Recursive section
	addi $sp, $sp, -20	# Push arguments and $ra to the stack
	sw $a0, 0($sp)		# number of disks
	sw $a1, 4($sp)		# pointer to init tower
	sw $a2, 8($sp)		# pointer to aux tower 
	sw $a3, 12($sp)		# pointer to dest tower
	sw $ra, 16($sp)		# return address

	add $t1, $zero, $a2	# put a2(aux) pointer value on t1
	add $a2, $zero, $a3	# put a3(dest) pointer value on a2(aux)
	add $a3, $zero, $t1	# put t1(original a2) pointer value on a3(dest), swap of a2 and a3
	add $t2, $zero, $s2	# we also swap in the same logic the s2 and s3 values
	add $s2, $zero, $s3
	add $s3, $zero, $t2
	addi $a0, $a0, -1	# Decrement number of disks for the next step in algorithm
	jal hanoi		# hanoi(n - 1, init, dest, aux)
				# Based on the recursive C code

	add $t2, $zero, $s2	# unswap $s2 and $s3, needed so that the tower pointer always matches 
	add $s2, $zero, $s3	# number of disks' pointer
	add $s3, $zero, $t2			
				# load arguments from stack
	lw $a0, 0($sp)		# number of disks
	lw $a1, 4($sp)		# pointer to init tower
	lw $a2, 8($sp)		# pointer to aux tower
	lw $a3, 12($sp)		# pointer to destiny tower
	lw $ra, 16($sp)		# return adress
	jal firstCase		# go to the first case non-recursive algorithm 

	add $t1, $zero, $a2	# put a2(aux) to t1
	add $a2, $zero, $a1	# put a1(init) to a2(aux)
	add $a1, $zero, $t1	# put t1 (origial a2) to a1, swapping of a2 and a1
	add $t2, $zero, $s2	# same process but with s1(init) and s2(aux)
	add $s2, $zero, $s1	# so it can keep this values
	add $s1, $zero, $t2	
	addi $a0, $a0, -1	#reduce number of disks in init by 1
	jal hanoi 		# hanoi(n - 1, aux, init, dest)
				# Based on C recursive code

	add $t2, $zero, $s2	# unswap $s2 and $s3, needed so that the tower pointer always matches 
	add $s2, $zero, $s1	# number of disks' pointer
	add $s1, $zero, $t2

	lw $ra, 16($sp)		# Get the last return adress from the stack
	addi $sp, $sp, 20	# Move to the previous value of the stack
	jr $ra			# Go to the return address


firstCase:  # Hanoi(n, init, aux, dest) First case of C recurisve code, wich does a basic move from init to dest
	add $t0, $a1, $s1 	# t0 becomes a pointer to disk on top of init tower
	sw $zero, 0($t0)	# Removes the disk from top of the tower
	addi $s1, $s1, -4	# We remove 1 disk from the number of disks pointer

	addi $s3, $s3, 4	# Add one value to the distiny tower disks' number pointer
	add $t0, $a3, $s3	# t0 becomes a pointer to the top of the tower
	sw $a0, 0($t0)		# store in top of destiny tower the disk removed from init tower
	jr $ra			# Return to the stored address

end: 
