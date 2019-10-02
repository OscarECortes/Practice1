

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
		
init:
	addi $s0, $s0, 3 		# numero de discos n (used only for initial storage)
	add $a0, $a0, $s0		# copy of n (used for the recursive function and through program)
	addi $s1, $s1, 0x10010000	# loading initial torre1 pointer value	(initial)
	addi $s2, $s2, 0x10010020	# loading initial torre2 pointer value	(aux)
	addi $s3, $s3, 0x10010040	# loading initial torre3 pointer value  (dest)



