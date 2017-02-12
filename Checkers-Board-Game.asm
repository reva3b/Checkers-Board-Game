# 2 player Checkers Board Game

# Revathi Bhuvaneswari

# 05/24/2016

		.data
		.globl main
info1:	.asciiz "\n\n1. (0,0) starts at top left corner of board. "
info2:	.asciiz "\n2. Red Checkers - Top Half of Board. "
info3:	.asciiz "\n3. White Checkers - Bottom Half of Board.\n\n"
turnR:	.asciiz "\n\nPlayer RED's turn...\n\n"
turnW:	.asciiz "\n\nPlayer WHITE's turn...\n\n"
pmptr1:	.asciiz "\nEnter Value for r1 (source) : "
pmptc1:	.asciiz "\nEnter Value for c1 (source) : "
pmptr2:	.asciiz "\nEnter Value for r2 (destination) : "
pmptc2:	.asciiz "\nEnter Value for c2 (destination) : "
erLgl:	.asciiz "\n\nILLEGAL POSITION! Please enter valid value for row and column!\n\n"
winR:	.asciiz "\n\nCONGRATS Player RED! You WON!"
winW:	.asciiz "\n\nCONGRATS Player WHITE! You WON!"
jump:	.asciiz "\n\nVALID JUMP\n\n"
move:	.asciiz "\n\nVALID MOVE\n\n"
nl:    	.asciiz "\n"
bye:    .asciiz "\n\nBYE!"
		.code
	
main: 	addi $sp,$sp,-1212 # allocate space for board, valid moves/jumps, r1,c1,r2,c2, $raF1 - $raF7
		mov $t0,$sp 
		addi $t1,$sp,1212
		j Tst0
		li $f1,25

loop0:	sw $0,0($t0) # initialize stack to zero
		addi $t0,$t0,4 
Tst0:   blt $t0,$t1,loop0

		li $t0,0 # r = 0 - outer loop counter
		j TstR1
	
loopR1: li $t1,0 # c = 0 - inner loop counter
		j TstR2
loopR2: mov $a2,$t0 # row argument
		mov $a3,$t1 # column argument
		jal isLegalPosition
		bne $v0,1,incR2
		# Calculate offset value for red piece -> Offset = (r*10+c)*4+812
		mul $t5,$t0,10 # 10r
		add $t5,$t5,$t1 # 10r + c
		mul $t5,$t5,4 # (10r + c) * 4
		addi $t5,$t5,812 # (10r + c) * 4 + 812 -> offset value
		mov $s3,$sp # store the start address of array in $s3
		add $s3,$s3,$t5 # add offset to the start address of array
		li $t5,1
		sw $t5,0($s3) # add red game piece into the array
incR2:	addi $t1,$t1,1 # c++
TstR2:	blt $t1,10,loopR2 # while (c < 10)
incR1:	addi $t0,$t0,1 # r++
TstR1:	ble $t0,2,loopR1 # while (r <= 2)

		li $t0,7 # r = 7 - outer loop counter
		j TstW1
	
loopW1: li $t1,0 # c = 0 - inner loop counter
		j TstW2
loopW2: mov $a2,$t0 # row argument
		mov $a3,$t1 # column argument
		jal isLegalPosition
		bne $v0,1,incW2
		# Calculate offset value for red piece -> Offset = (r*10+c)*4+812
		mul $t5,$t0,10 # 10r
		add $t5,$t5,$t1 # 10r + c
		mul $t5,$t5,4 # (10r + c) * 4
		addi $t5,$t5,812 # (10r + c) * 4 + 812 -> offset value
		mov $s3,$sp # store the start address of array in $s3
		add $s3,$s3,$t5 # add offset to the start address of array
		li $t5,3
		sw $t5,0($s3) # add red game piece into the array
incW2:	addi $t1,$t1,1 # c++
TstW2:	blt $t1,10,loopW2 # while (c < 10)
incW1:	addi $t0,$t0,1 # r++
TstW1:	ble $t0,9,loopW1 # while (r <= 9)

		la $a0,info1
		syscall $print_string
		la $a0,info2
		syscall $print_string
		la $a0,info3
		syscall $print_string
		mov $a1,$sp
		addi $a1,$a1,812
		jal display_board
		
		li $t3,15 # redPieceCount = 15
		li $t4,15 # whitePieceCount = 15
		li $t5,0 # curColor = 0 -> red
		j Tst3
	
loop3:	bne $t5,0,ELSET # if curColor = 0, player RED's turn 
		la $a0,turnR
		syscall $print_string
		j ENDT
ELSET:	la $a0,turnW # else player WHITE's turn	
		syscall $print_string
	
ENDT:	la $a0,pmptr1 # ask for r1
		syscall $print_string
		syscall $read_int
		sw $v0,28($sp) # store r1 in stack
	
		la $a0,pmptc1 # ask for c1
		syscall $print_string
		syscall $read_int
		sw $v0,32($sp) # store c1 in stack
		
		la $a0,pmptr2 # ask for r2
		syscall $print_string
		syscall $read_int
		sw $v0,36($sp) # store r2 in stack
		
		la $a0,pmptc2 # ask for c2
		syscall $print_string
		syscall $read_int
		sw $v0,40($sp) # store c2 in stack
		
		# Load value of piece in (r1,c1) -> Offset = (r1*10+c1)*4+812
		lw $t0,28($sp)# load value of r1 in t0
		lw $t1,32($sp) # load value of c1 in t1
		mul $t0,$t0,10 # 10r1
		add $t0,$t0,$t1 # 10r1 + c1
		mul $t0,$t0,4 # (10r1 + c1) * 4
		addi $t0,$t0,812 # (10r1 + c1) * 4 + 812 -> offset value
		mov $s3,$sp # store the start address of array in $s3
		add $s3,$s3,$t0 # add offset to the start address of array
		lw $t6,0($s3) # load value in (r1,c1) in t6
		
		srl $t7,$t6,1
		andi $t7,$t7,1 # t7 = 0 if red, t7 = 1 if white
		
		bne $t7,$t5,IFC # continue if piece color is curColor, else change player
	
IFM:	jal isValidMove
		bne $v1,1,IFJ # continue if valid move, else go to valid jump
	
		# calculate offset value for (r2,c2) -> Offset = (r2*10+c2)*4+812
		lw $s4,36($sp) # load r2 in $s4
		lw $s5,40($sp) # load c2 in $s5
		mul $s4,$s4,10 # 10r2
		add $s4,$s4,$s5 # 10r2 + c2
		mul $s4,$s4,4 # (10r2 + c2) * 4
		addi $s4,$s4,812 -> Offset Value
		mov $s5,$sp # store the start address of array in $s5
		add $s5,$s5,$s4 # add offset to the start address of array
		sw $t6,0($s5) # store value from (r1,c1) into (r2,c2)	
		
		# Calculate offset value for (r1,c1) -> Offset = (r1*10+c1)*4+812
		lw $t0,28($sp)# load value of r1 in t0
		lw $t1,32($sp) # load value of c1 in t1
		mul $t0,$t0,10 # 10r1
		add $t0,$t0,$t1 # 10r1 + c1
		mul $t0,$t0,4 # (10r1 + c1) * 4
		addi $t0,$t0,812 # (10r1 + c1) * 4 + 812 -> offset value
		mov $s3,$sp # store the start address of array in $s3
		add $s3,$s3,$t0 # add offset to the start address of array
		sw $0,0($s3) # remove piece from (r1,c1) i.e. insert 0
		
		la $a0,move
		syscall $print_string
		
		srl $t7,$t6,1
		andi $t7,$t7,1 # t7 = 0 if red, t7 = 1 if white
		lw $s4,36($sp) # load r2 in $s4
		
ifrk: 	bne $t7,0,ifwk # continue if piece is red ie t7 = 0
		bne $s4,9,ifwk # continue if index of row is 9 ie r2 = 9
		li $t0,5
		sw $t0,0($s5) # s5 is offset value for (r2,c2), store 5 - Red King in (r2,c2)
		j IFC
		
ifwk:	bne $t7,1,IFC # continue if piece is white ie t7 = 1
		bne $s4,0,IFC # continue if index of row is 0 ie r2 = 0
		li $t0,7
		sw $t0,0($s5) # s5 is offset value for (r2,c2), store 7 - White King in (r2,c2)
		j IFC
	
IFJ:	jal isValidJump
		bne $v1,1,IFC # continue if valid jump, else change player
	
		# calculate offset value for (r2,c2) -> Offset = (r2*10+c2)*4+812
		lw $s4,36($sp) # load r2 in $s4
		lw $s5,40($sp) # load c2 in $s5
		mul $s4,$s4,10 # 10r2
		add $s4,$s4,$s5 # 10r2 + c2
		mul $s4,$s4,4 # (10r2 + c2) * 4
		addi $s4,$s4,812 -> Offset Value
		mov $s5,$sp # store the start address of array in $s5
		add $s5,$s5,$s4 # add offset to the start address of array
		mov $s2,$s5 # mov offset value of (r2,c2) into s2
		sw $t6,0($s5) # store value from (r1,c1) into (r2,c2)	
 		
		# Calculate offset value for (r1,c1) -> Offset = (r1*10+c1)*4+812
		lw $t0,28($sp)# load value of r1 in t0
		lw $t1,32($sp) # load value of c1 in t1
		mul $t0,$t0,10 # 10r1
		add $t0,$t0,$t1 # 10r1 + c1
		mul $t0,$t0,4 # (10r1 + c1) * 4
		addi $t0,$t0,812 # (10r1 + c1) * 4 + 812 -> offset value
		mov $s3,$sp # store the start address of array in $s3
		add $s3,$s3,$t0 # add offset to the start address of array
		sw $0,0($s3) # remove piece from (r1,c1) i.e. insert 0
		
		# calculate offset value for (rm,cm) -> Offset = (rm*10+cm)*4+812
		mov $s4,$a2 # load rm in $s4
		mov $s5,$a3 # load cm in $s5
		mul $s4,$s4,10 # 10rm
		add $s4,$s4,$s5 # 10rm + cm
		mul $s4,$s4,4 # (10rm + cm) * 4
		addi $s4,$s4,812 -> Offset Value
		mov $s5,$sp # store the start address of array in $s5
		add $s5,$s5,$s4 # add offset to the start address of array
		lw $t9,0($s5) # load value that is to be removed
		sw $0,0($s5) # remove piece from (rm,cm) i.e. insert 0
				
		srl $t7,$t6,1
		andi $t7,$t7,1 # t7 = 0 if red, t7 = 1 if white
		lw $s4,36($sp) # load r2 in $s4
		
ifRk: 	bne $t7,0,ifWk # continue if piece is red ie t7 = 0
		bne $s4,9,ifWk # continue if index of row is 9 ie r2 = 9
		li $t0,5
		sw $t0,0($s2) # s2 is offset value for (r2,c2), store 5 - Red King in (r2,c2)
		j remr
		
ifWk:	bne $t7,1,remr # continue if piece is white ie t7 = 1
		bne $s4,0,remr # continue if index of row is 0 ie r2 = 0
		li $t0,7
		sw $t0,0($s2) # s2 is offset value for (r2,c2), store 7 - White King in (r2,c2)
	
remr:	bne $t9,1,remw # if $t9 == 1, redPieceCount--
		addi $t3,$t3,-1
		beq $t3,0,end3 # if redPieceCount == 0, exit loop 
		la $a0,jump
		syscall $print_string
		j IFC

remw: 	bne $t9,3,IFC # else if $t9 == 3, whitePieceCount--
		addi $t4,$t4,-1
		beq $t4,0,end3 # if whitePieceCount == 0, exit loop 
		la $a0,jump
		syscall $print_string
		
IFC:	bne $t5,0,ELSEC # if curColor == 0, set it to 1
		li $t5,1
		j ENDFC
ELSEC:	li $t5,0 # else set curColor to 0
	
ENDFC:	mov $a1,$sp
		addi $a1,$a1,812
		jal display_board
	
Tst3:	bne $0,1,loop3 # while (0 != 1) --> infinite loop
end3:	# end of loop3

		la $a0,nl
		syscall $print_string
		mov $a1,$sp
		addi $a1,$a1,812
		jal display_board

ifWIN:	bne $t3,0,elseWIN # if redPieceCount == 0, winner is red
		la $a0,winW
		syscall $print_string
		j exit

elseWIN: bne $t4,0,exit # else if whitePieceCount == 0, white is the winner
		la $a0,winR
		syscall $print_string
	
exit:	la $a0,bye
		syscall $print_string
		syscall $exit
	
##################################################################################################
# Function: isLegalPosition	 
# Description: Checks if the user is placing the checker in the legal position	 
# Parameters: int row (a2), int column (a3)	 
# Returns: 1 - legal position, 0 - illegal position (row/column not in range or if black square) 
##################################################################################################
isLegalPosition: sw $ra,24($sp)
		li $v0,0 # return 0
		bltz $a2,endF1 # row >= 0
		bltz $a3,endF1 # column >= 0
		bgt $a2,9,endF1 # row <= 9
		bgt $a3,9,endF1 # column <=9
		# check if black square
		li $t7,0 # for calculation
		add $t7,$a2,$a3 # k = row + column
		div $t7,2 # k / 2
		mfhi $t7 # Holds result of k % 2
		bnez $t7,endF1 # if k % 2 != 0, illegal position   
		li $v0,1 # return 1
		j endF1
endF1:	lw $ra,24($sp)
		jr $ra

#######################################################################
# Function: display_board	      
# Description: Prints the current state of the board                  
# Parameters: BoardObject board --> board state passed by reference   
# Returns: none --> prints the board	      
#######################################################################

display_board:	sw $ra,20($sp)
		li $t9,0 # i = 0
		li $t8,0 # j = 0
		mov $t0,$a1 
		addi $t1,$a1,1212
		j Tst2
	
loop2:	lw $s0,0($t0) # store the value from array in $s0 
		addi $t0,$t0,4
		j Print
Tst2:  	blt $t0,$t1,loop2

Print:	j TstI
loopI:	j TstJ

loopJ:	add $t7,$t9,$t8 # k = i + j
		div $t7,2 # k / 2
		mfhi $t7 # Holds result of k % 2
	
if0:	beqz $t7,if1 # if k % 2 != 0 print black square   
		li $a0,219 # print black square
		syscall $print_char
		j incJ	
if1:	bne $s0,0,if2
		li $a0,32 # print empty space
		syscall $print_char
		j incJ
if2:	bne $s0,1,if3
		li $a0,114 # print r
		syscall $print_char
		j incJ
if3:	bne $s0,3,if4
		li $a0,119 # print w
		syscall $print_char
		j incJ
if4:	bne $s0,5,if5
		li $a0,82 # print R
		syscall $print_char
		j incJ
if5:	bne $s0,7,default
		li $a0,87 # print W
		syscall $print_char
		j incJ
default: li $a0,32 # print empty space if number out of range
		syscall $print_char	
incJ:	addi $t8,$t8,1 # j++
		j Tst2 # go back to loop2 to get new value
TstJ:	blt $t8,10,loopJ # while (j < 10)
incI:	la $a0,nl
		syscall $print_string
		addi $t9,$t9,1 # i++
		li $t8,0 # j = 0
TstI:	blt $t9,10,loopI # while (i < 10)
endF2:	lw $ra,20($sp)
		jr $ra

##########################################################################################################################
# Function: isValidMove	 
# Description: Checks if a particular move is valid or not	 
# Parameters: int *board (board position), int r1, int c1, int r2, int c2                                                
# Returns: 1 - legal move, 0 - illegal move (returns 0 if isLegalPosition returns 0, It doesn't take jumps into account) 
##########################################################################################################################
isValidMove: sw $ra,16($sp) 
		li $v1,1
	
		lw $a2,28($sp) # load r1 into $a2
		lw $a3,32($sp) # load c1 into $a2
		jal isLegalPosition
		mov $s2,$v0
	
		lw $a2,36($sp) # load r2 into $a2
		lw $a3,40($sp) # load c2 into $a3
		jal isLegalPosition
		mov $s3,$v0
	
if7:	bnez $s2,if8 # if s2 = 0, exit function by returning 0 
		li $v1,0
		j endF3
	
if8:	bnez $s3,else7 # if s3 = 0, exit function by returning 0
		li $v1,0
		j endF3	
	
else7:	# calculate offset value for (r1,c1) -> Offset = (r1*10+c1)*4+812
		lw $s4,28($sp) # load r1 in $s4
		lw $s5,32($sp) # load c1 in $s5
		mul $s4,$s4,10 # 10r1
		add $s4,$s4,$s5 # 10r1 + c1
		mul $s4,$s4,4 # (10r1 + c1) * 4
		addi $s4,$s4,812 -> Offset Value
		mov $s5,$sp # store the start address of array in $s5
		add $s5,$s5,$s4 # add offset to the start address of array
		lw $t7,0($s5) # load value in (r1,c1) in $t7
		
		# calculate offset value for (r2,c2) -> Offset = (r2*10+c2)*4+812
		lw $s4,36($sp) # load r2 in $s4
		lw $s5,40($sp) # load c2 in $s5
		mul $s4,$s4,10 # 10r2
		add $s4,$s4,$s5 # 10r2 + c2
		mul $s4,$s4,4 # (10r2 + c2) * 4
		addi $s4,$s4,812 -> Offset Value
		mov $s5,$sp # store the start address of array in $s5
		add $s5,$s5,$s4 # add offset to the start address of array
		lw $t9,0($s5) # load value in (r2,c2) in $t9	
	
if9:	beqz $t9,else9 # continue if value in destination is zero, else exit function
		li $v1,0
		j endF3
	
else9:	lw $s4,28($sp) # load r1 in $s4
		lw $s5,36($sp) # load r2 in $s5
		sub $t0,$s4,$s5 # $t0 = r1 - r2
		
		lw $s4,32($sp) # load c1 in $s4
		lw $s5,40($sp) # load c2 in $s5
		sub $t8,$s4,$s5 # $t8 = c1 - c2
		abs $t8,$t8 # $t8 = abs(c1 - c2)
		
		srl $t9,$t7,1
		andi $t9,$t9,1 # t9 = 0 if red, t9 = 1 if white
		beq $t9,0,S0
		beq $t9,1,S1
	
S0:		beq $t7,1,caser1 # switch case
		beq $t7,5,caseR1
		li $v1,0
		j endF3
	
S1:		beq $t7,3,casew1
		beq $t7,7,caseW1
		j default1 # if no value in source, exit by returning 0	
	
caser1:	bne $t0,-1,sw1
		bne $t8,1,sw1
		li $v1,1
		j endF3
casew1:	bne $t0,1,sw1 
		bne $t8,1,sw1
		li $v1,1
		j endF3
caseR1:	
caseW1:	abs $t0,$t0 # $t0 = abs(r1 - r2)
		bne $t0,1,sw1
		bne $t8,1,sw1
		li $v1,1
		j endF3
default1: li $v1,0 
sw1:	li $v1,0
endF3:	lw $ra,16($sp)
		jr $ra

##########################################################################################################################
# Function: isValidJump	 
# Description: Checks if a particular jump is valid or not	 
# Parameters: int *board (board position), int r1, int c1, int r2, int c2	 
# Returns: 1 - valid jump, 0 - invalid jump (returns 0 if isLegalPosition returns 0, It doesn't take moves into account) 
##########################################################################################################################
isValidJump: sw $ra,4($sp) 
		li $v1,1
		
		lw $a2,28($sp) # load r1 into $a2
		lw $a3,32($sp) # load c1 into $a2
		jal isLegalPosition
		mov $s2,$v0
		
		lw $a2,36($sp) # load r2 into $a2
		lw $a3,40($sp) # load c2 into $a3
		jal isLegalPosition
		mov $s3,$v0	
	
if19:	bnez $s2,if20 # if a2 = 0, exit function by returning 0 
		li $v1,0
		j endF6
	
if20:	bnez $s3,else19 # if a3 = 0, exit function by returning 0
		li $v1,0
		j endF6
	
else19:	# calculate rm 
		lw $s4,28($sp) # load r1 in $s4
		lw $s5,36($sp) # load r2 in $s5
		add $t0,$s4,$s5 # $t0 = r1+r2
		div $t0,2 # $t0 = (r1+r2) / 2 = rm
		mflo $t0 # $t0 = (r1+r2) / 2 = rm
		mov $a2,$t0 # move value of rm into a2
		
		# calculate cm
		lw $s4,32($sp) # load c1 in $s4 
		lw $s5,40($sp) # load c2 in $s5
		add $t8,$s4,$s5 # $t8 = c1+c2
		div $t8,2 # $t8 = (c1+c2) / 2 = cm
		mflo $t8 # $t8 = (c1+c2) / 2 = cm
		mov $a3,$t8 # move value of cm into a3
		
		# calculate offset value for (rm,cm) -> Offset = (rm*10+cm)*4+812
		mov $s4,$t0 # load rm in $s4
		mov $s5,$t8 # load cm in $s5
		mul $s4,$s4,10 # 10rm
		add $s4,$s4,$s5 # 10rm + cm
		mul $s4,$s4,4 # (10rm + cm) * 4
		addi $s4,$s4,812 -> Offset Value
		mov $s5,$sp # store the start address of array in $s5
		add $s5,$s5,$s4 # add offset to the start address of array
		lw $s3,0($s5) # load value in (rm,cm) in $s3
		
		# calculate offset value for (r1,c1) -> Offset = (r1*10+c1)*4+812
		lw $s4,28($sp) # load r1 in $s4
		lw $s5,32($sp) # load c1 in $s5
		mul $s4,$s4,10 # 10r1
		add $s4,$s4,$s5 # 10r1 + c1
		mul $s4,$s4,4 # (10r1 + c1) * 4
		addi $s4,$s4,812 -> Offset Value
		mov $s5,$sp # store the start address of array in $s5
		add $s5,$s5,$s4 # add offset to the start address of array
		lw $t8,0($s5) # load value in (r1,c1) in $t8
		
		# calculate offset value for (r2,c2) -> Offset = (r2*10+c2)*4+812
		lw $s4,36($sp) # load r2 in $s4
		lw $s5,40($sp) # load c2 in $s5
		mul $s4,$s4,10 # 10r2
		add $s4,$s4,$s5 # 10r2 + c2
		mul $s4,$s4,4 # (10r2 + c2) * 4
		addi $s4,$s4,812 -> Offset Value
		mov $s5,$sp # store the start address of array in $s5
		add $s5,$s5,$s4 # add offset to the start address of array
		lw $t9,0($s5) # load value in (r2,c2) in $t9
	
if21a:	bnez $s3,if21b # continue if value in [rm][cm] is not zero, else exit function
		li $v1,0
		j endF6
	
if21b:	beqz $t9,else21 # continue if value in [r2][c2] is zero, else exit function
		li $v1,0
		j endF6
	
else21:	lw $s4,28($sp) # load r1 in $s4
		lw $s5,36($sp) # load r2 in $s5
		sub $s6,$s4,$s5 # $s6 = r1 - r2
	
		lw $s4,32($sp) # load c1 in $s4
		lw $s5,40($sp) # load c2 in $s5
		sub $t7,$s4,$s5 # $t7 = c1 - c2
		abs $t7,$t7 # $t7 = abs(c1 - c2)
	
		srl $t9,$t8,1
		andi $t9,$t9,1 # t9 = 0 if red, t9 = 1 if white
	
		beq $t9,0,T0
		beq $t9,1,T1
	
T0:		beq $t8,1,caser2 # switch case
		beq $t8,5,caseR2
		li $v1,0
		j endF6
		
T1:		beq $t8,3,casew2
		beq $t8,7,caseW2
		j default2 # if no value in source, exit by returning 0
	
caser2:	bne $s6,-2,sw2
		bne $t7,2,sw2
		bne $s3,3,else22
		li $v1,1
		j endF6
	
else22:	bne $s6,-2,sw2
		bne $t7,2,sw2
		bne $s3,7,sw2
		li $v1,1
		j endF6
	
casew2:	bne $s6,2,sw2
		bne $t7,2,sw2
		bne $s3,1,else23
		li $v1,1
		j endF6
	
else23:	bne $s6,2,sw2
		bne $t7,2,sw2
		bne $s3,5,sw2
		li $v1,1
		j endF6
	
caseR2:	abs $s6,$s6 # $s6 = abs(r1 - r2)
		bne $s6,2,sw2
		bne $t7,2,sw2
		bne $s3,3,else24
		li $v1,1
		j endF6
	
else24:	bne $s6,2,sw2
		bne $t7,2,sw2
		bne $s3,7,sw2
		li $v1,1
		j endF6
	
caseW2:	abs $s6,$s6 # $s6 = abs(r1 - r2)
		bne $t6,2,sw2
		bne $t7,2,sw2
		bne $s3,1,else25
		li $v1,1
		j endF6
	
else25:	bne $s6,2,sw2
		bne $t7,2,sw2
		bne $s3,5,sw2
		li $v1,1
		j endF6
	
default2: li $v1,0 

sw2:	li $v1,0

endF6:	lw $ra,4($sp)
		jr $ra	
		jr $ra	