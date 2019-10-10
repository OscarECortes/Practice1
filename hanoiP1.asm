

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


#Check if it would do the firtst case or the other steps	
ifElse: 	
	bne $a0, 1, algorithm		# if there are disks on tower1 go to else
	lw $v0, ($s1)			# load tower1's first value to v0

storeFirst:
	bne $v0, $zero, moveByte	# If current value is not zero, jump to moveByte to get a zero
	addi $s1, $s1, -4		# take the byte before (tracklastbyte left the pointer in a 0 value)
	lw $v0, ($s1)			# load definite store value in v0
	sw $zero, ($s1)			# delete value from tower1
	
	# check if theres anything in destiny tower
checkDest:	
	lw $t0, ($s3)			# load value from $s3(tower3) in $t0
	beq $t0, 0, storeDest		# if $s3 was empty, branch to storedest
	addi $s3, $s3, 4		# if $s3 had something, go to next data place
	j storeSum			# jump to storesum, to check next byte
	
storeDest:	  
	sw $v0, ($s3)			# store tower1's(init) value in tower3(dest)
	jr $ra				# return to main function
	
	# this function goes to the last value of the data
moveByte:
	addi $s1, $s1, 4		# increments tower1 pointer by 4 to get next value
	lw $v0, ($s1)			# loads the value in $v0
	bne $v0, $zero, moveByte	# if current byte has a value, branch to moveByte again
	j storeFirst			# otherwise, get back to storeFirst

algorithm:
	# move the stack to store data
	addi $sp, $sp, -20
	
	# store the number of disks, the tower positions and the address to return
	sw $a0, 16($sp)			# number of disks
	sw $s1, 12($sp)			# tower1 (init)
	sw $s2, 8($sp)			# tower2 (aux)
	sw $s3, 4($sp)			# tower3 (dest)
	sw $ra, 0($sp)			# store ra
