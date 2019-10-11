

## ** NOTE: For easier visualization on Mars, the program is set to work only with 8 disks (the pointers
## start messing up with each other because they are set up to hold only 8 bytes), if you want to use a
## bigger n (disks), use different initial memory addresses for $s1, $s2, and $s3.


.text

	addi $s0, $s0, 0x10010000	#Limit of memory
	addi $s1, $s1, 0x10010060	#Limit of memory
	
initZero:
	beq $s0, $s1, cleanRegister 	#if the limits are the same, branch to cleanRegister
	sw $zero, ($s0)			#Initialization of zeros
	addi $s0, $s0, 4		#move to next byte
	j initZero			#loop
	
cleanRegister:				#clean the registers used
	sub $s0, $s0, $s0
	sub $s1, $s1, $s1
		
initMemo:
	addi $s0, $s0, 3 		# numero de discos n (used only for initial storage)
	add $a0, $a0, $s0		# copy of n (used for the recursive function and through program)
	addi $s1, $s1, 0x10010000	# loading initial torre1 pointer value	(initial)
	addi $s2, $s2, 0x10010020	# loading initial torre2 pointer value	(aux)
	addi $s3, $s3, 0x10010040	# loading initial torre3 pointer value  (dest)
	
fill:
	sw $s0, ($s1)			# put disk in tower 1 (initial)
	addi $s0, $s0, -1		# substract 1 from n
	addi $s1, $s1, 4		# initial tower 1 pointer + 4, to load next byte
	bne $s0, $zero, fill		# loop to fill if there are still disks to be added


#Check if it would do the first case or the other steps	
ifElse: 	
	bne $a0, 1, algorithm		# if there are disks on tower1 go to algorithm
	lw $t0, ($s1)			# load tower1's first value to v0

storeFirst:
	bne $t0, $zero, moveByte	# If current value is not zero, jump to moveByte to get a zero
	addi $s1, $s1, -4		# go to the position before a zero that was obtained in moveByte, here is the first disk
	lw $t0, ($s1)			# load the value of the first disk in t0
	sub $s1, $s1, $s1		# delete value from top of first tower
	
	# check if theres anything in destiny tower
checkDest:	
	lw $t0, ($s3)			# load value from $s3(tower3) in $t0
	beq $t0, 0, saveDest		# if $s3 is 0, branch to saveDest
	addi $s3, $s3, 4		# if $s3 has values, move pointer
	j storeFirst			# jump to beginning to check again
	
saveDest:	  
	sw $t0, ($s3)			# store tower1's(init) value in tower3(dest)
	jr $ra				# return to main function
	
	# this function goes to the last value of the data
moveByte:
	addi $s1, $s1, 4		# increments tower1 pointer by 4 to get next value
	lw $t0, ($s1)			# loads the value in $t0
	bne $t0, $zero, moveByte	# if the position has value, move again
	j storeFirst			# if the position has 0 go to the beginning

algorithm:
	# move the stack to store data
	addi $sp, $sp, -20
	
	# store the number of disks, the tower positions and the address to return
	
	sw $ra, 0($sp)			# store ra
	sw $s3, 4($sp)			# tower3 (dest)
	sw $s2, 8($sp)			# tower2 (aux)
	sw $s1, 12($sp)			# tower1 (init)
	sw $a0, 16($sp)			# number of disks
	
# 	Hanoi algorithm with n-1 instead of n, based on C recursive algorithm
	addi $a0, $a0, -1		# decrease n as the case n-1 is done
	lw $t1, ($s3)			#load s3 on t1 to save this data
	addi $s3, $s2, 0		# move what is in aux tower ot dest tower
	sw $t1, ($s2)			# move what was on dest (temporal) to aux
	jal ifElse			# call function
	
	# store the number of disks, the tower positions and the address to return again, as a new step is done
	sw $ra, 0($sp)			# store ra
	sw $s3, 4($sp)			# tower3 (dest)
	sw $s2, 8($sp)			# tower2 (aux)
	sw $s1, 12($sp)			# tower1 (init)
	sw $a0, 16($sp)			# number of disks
	
