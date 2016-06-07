# Author: RAHUL VERMA
.text

la $a0, BOARD
li $a1, 0
li $a2, -1
jal sudoku
li $v0, 10
syscall


	
#	
# Helper function for solving sudoku
# public boolean isSolution (int row, int col)
#
isSolution:
	li $t0, 8
	bne $t0, $a0, false
	bne $t0, $a1, false
	li $v0, 1
	jr $ra
	
false:	
	li $v0, 0
	jr $ra	
	

	jr $ra

#
# Helper function for solving sudoku
# public void printSolution (byte[][] board)
#
printSolution:
	
	move $t0, $a0		#address of board is now in $t0
	
	la $a0, solution
	li $v0, 4
	syscall
	li $a0, 10
	li $v0, 11
	syscall
	
	li $t1, 8
	li $t2, 8
top:	
	bltz, $t2, done
	bltz $t1, newline
	
	lb $a0, ($t0)
	li $v0, 1
	syscall
	
	li $a0, 32
	li $v0, 11
	syscall
	
	addi $t0, $t0,1
	addi $t1, $t1, -1
	j top
newline:	
	li $a0, 10
	li $v0, 11
	syscall
	addi $t2, $t2, -1
	li $t1, 8
	j top
done:	
	
	
	jr $ra

#
# Helper function for solving sudoku
# public int gridSet (byte[] board, int row, int col)
#
gridSet:
	
	move $t0, $a0		#$t0 has the start address of the board
	move $t1, $a1		#$t1 has int row
	move $t2, $a2		#t2 has int col
	la $t8, gSet
	
	li $t3, 3
	li $t4, 0		#the counter
	
	div $t1, $t3
	mflo $t1
	mult $t1, $t3
	mflo $t1		#start row
	
	div $t2, $t3
	mflo $t2
	mult $t2, $t3
	mflo $t2		#start column
	
	li $t5, 3
	li $t6, 3
	
	li $t7, 9
	mult $t1, $t7
	mflo $t7
	add $t0,$t0,$t7
	add $t0, $t0, $t2	#start address of where to begin testing
mLoop:	
	beqz $t5, gotGrid
	beqz $t6, newRow
	
	lb $t7, ($t0)	
	beqz $t7, nextVal
	sb $t7, ($t8)
	addi $t8,$t8,1
	addi $t4, $t4, 1

nextVal:		
	addi $t0, $t0, 1
	addi $t6, $t6, -1
	j mLoop
	
newRow:
	addi $t0, $t0, 6
	addi $t5, $t5, -1
	li $t6, 3
	j mLoop
gotGrid:
	move $v0, $t4			
	jr $ra

#
# Helper function for solving sudoku
# public int colSet (byte[] board, int col)
#	
colSet:
	move $t0, $a0		#starting address of the board
	move $t1, $a1		#column number
	
	li $t6, 0
	li $t4, 0
	li $t2, 9
	li $t3, 8
	la $t5, cSet
	add $t0, $t0, $t1
	
reloop:
	bltz $t3, return1	
	lb $t4, ($t0)
	
	beqz $t4, next
	sb $t4, ($t5)
	addi $t5, $t5, 1
	addi $t6, $t6, 1
next:	
	add $t0, $t0, $t2
	addi $t3, $t3, -1
	
	j reloop
	
return1:	
	move $v0, $t6
	jr $ra

#
# Helper function for solving sudoku
# public int rowSet (byte[] board, int row)
#		
rowSet:

	move $t0, $a0
	move $t1, $a1
	
	li $t8, 0
	li $t2, 9
	mult $t1,$t2
	mflo $t1
	li $t2, 9
	la $t4, rSet
	
	
	add $t0, $t0, $t1
top1:	
	beqz  $t2, foundrSet
	lb $t3, ($t0)
	beqz $t3, nextnumb
	sb $t3, ($t4)
	addi $t4, $t4, 1
	addi $t0, $t0,1
	addi $t2,$t2,-1	
	addi $t8, $t8, 1
	j top1
	
nextnumb:
	addi $t0, $t0,1
	addi $t2,$t2,-1	
	j top1
	
foundrSet:
	move $v0, $t8
	jr $ra
	
#
# Helper function for solving sudoku
# public int constructCandidates (byte[][] board, int row, int col, byte[] candidates)
#			
constructCandidates:
	
	addi $sp, $sp, -20
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	move $s0, $a0		#address of board
	move $s1, $a1		#int row
	move $s2, $a2		#int column	
	move $s3, $a3		#address of candidates
	
	
	
	
	jal rowSet
	
	move $t1, $v0
	addi $sp, $sp, -4
	sw $t1, ($sp)
	
	move $a0, $s0
	move $a1, $s2
	jal colSet
	
	move $t2, $v0
	addi $sp, $sp, -4
	sw $t2, ($sp)
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal gridSet
	
	move $t3, $v0		#glength is now in $t3
	lw $t2, ($sp)		#clength is now in $t2
	lw $t1, 4($sp)		#rlength is now in $t1
	
	li $t4, 0
	
	li $t7, 9
construct:	
	beqz $t7, constructed
	
	beqz $t1, checkcset
	la $t6, rSet
	move $t5, $t1
checkrset:	
	beqz $t5, checkcset
	lb $t8, ($t6)	
	
	beq $t8, $t7, alreadyfound
	addi $t6, $t6, 1
	addi $t5,$t5, -1
	j checkrset
	
	
	
	
checkcset:
	
	beqz $t2, checkgset
	la $t6, cSet
	move $t5, $t2
checkc:	
	beqz $t5, checkgset
	lb $t8, ($t6)	
	
	beq $t8, $t7, alreadyfound
	addi $t6, $t6, 1
	addi $t5,$t5, -1
	j checkc	
	
			
checkgset:
	
	beqz $t3, foundone
	la $t6, gSet
	move $t5, $t3
checkg:	
	beqz $t5, foundone
	lb $t8, ($t6)	
	
	beq $t8, $t7, alreadyfound
	addi $t6, $t6, 1
	addi $t5,$t5, -1
	j checkg

		
alreadyfound:
	addi $t7, $t7, -1	
	j construct

foundone:
	sb $t7, ($s3)
	addi $s3, $s3, 1
	addi $t7, $t7, -1
	addi $t4, $t4, 1	
	j construct		
constructed:

	lw $ra, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	addi $sp, $sp, 28
	move $v0, $t4
	jr $ra

#
# sudoku solver function
# public void sudoku (byte[][] board, int x, int y)
#	
sudoku:

	addi $sp, $sp, -40
	sw $ra, ($sp)
	sw $fp, 4($sp)
	
	sw $s0, 24($sp)
	sw $s1, 28($sp)
	sw $s2, 32($sp)
	
	move $s0, $a0		#the starting address of the board
	move $s1, $a1		#int x
	move $s2, $a2		#int y
	
	addi $fp, $sp, 12
	
	la $a0, sdku
	li $v0, 4
	syscall
	
	move $a0, $s1
	li $v0, 1
	syscall
	
	la $a0, bkts
	li $v0, 4
	syscall
	
	move $a0, $s2
	li $v0, 1
	syscall
	
	la $a0, bkts2
	li $v0, 4
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	
	
	move $a0, $s1
	move $a1, $s2
	
	jal isSolution
	
	beqz $v0, else4
	
	li $t0, 1
	la $t2, FINISHED
	sb $t0, ($t2)
	move $a0, $s0
	jal printSolution
	
else4:
	addi $s2,$s2, 1
	li $t1,8
	ble $s2, $t1, next1
	addi $s1,$s1,1
	andi $s2,$s2,0
next1:
	li $t3, 9
	mult $s1, $t3
	mflo $t4
	add $t4, $s0,$t4
	add $t4, $t4, $s2
	lb $t5, ($t4)
	
	beqz $t5, else5
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal sudoku
	j ret
	
else5:	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $fp
	
	jal constructCandidates
	move $t7, $v0
	beqz $t7, ret
	li $t8, 0
	
forl:	
	sw $t7, -4($fp)
	sw $t8, 24($fp)
	
	bge $t8, $t7, ret	
	add $t9, $t8,$fp
	li $t1, 9
	mult $s1, $t1
	mflo $t1
	add $t1, $t1, $s0
	add $t1, $t1, $s2
	lb $t2, ($t9)
	sb $t2, ($t1)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal sudoku
	
	li $t1, 9
	mult $s1, $t1
	mflo $t1
	add $t1, $t1, $s0
	add $t1, $t1, $s2
	li $t2, 0
	sb $t2, ($t1)
	addi $t8, $t8,1
	lb $t2, FINISHED
	bnez $t2, ret
	j forl
	
	
	
ret:
	lw $ra, ($sp)
	lw $fp, 4($sp)
	
	lw $s0, 24($sp)
	lw $s1, 28($sp)
	lw $s2, 32($sp)
	beqz $fp, cont
	lw $t7, -4($fp)
	lw $t8, 24($fp)
cont:	
	addi $sp, $sp, 40		
	jr $ra


.data
Ffunc: .asciiz "F: "
Mfunc: .asciiz "M: "
sdku: .asciiz "Sudoku ["
bkts: .asciiz "]["
bkts2: .asciiz "]"
solution: .asciiz "Solution:"
rSet: 		.byte 0:9
cSet: 		.byte 0:9
gSet: 		.byte 0:9
FINISHED: 	.byte 0
BOARD: .byte 0,3,0,4,7,0,9,0,1,0,0,7,0,5,2,0,8,3,0,0,9,0,0,1,0,0,4,0,7,0,1,4,3,0,0,0,0,0,0,6,0,9,0,0,0,0,0,0,5,8,7,0,3,0,7,0,0,8,0,0,4,0,0,6,9,0,7,3,0,8,0,0,5,0,1,0,9,4,0,7,0