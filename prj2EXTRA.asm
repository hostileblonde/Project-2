#Group #6 
#Group Eli Shelton, Bradyn Combs, Kaitlin Colvin
# Project 2 booths alg
.data
convert: .space 20 #convert array
errorMessage: .asciiz "input error!"
dashes: .asciiz "----------"
space: .asciiz " "
X: .asciiz "X"
newLineChar: .asciiz "\n"

.text

.globl main
main:
    jal stringIn
    addi $s0, $v0, 0 #saves first input into s0

    jal stringIn
    addi $s1, $v0, 0 #saves second input into s1

    li $v0, 4
    la $a0, space
    syscall #prints a space

    addi $a0, $s0, 0
    jal printBin #calls print bin with the first input

    li $v0, 4
    la $a0, newLineChar
    syscall #prints \n

    li $v0, 4
    la $a0, X
    syscall #prints a X

    addi $a0, $s1, 0
    jal printBin #calls print bin with second number

    li $v0, 4
    la $a0, newLineChar
    syscall #prints \n 

    li $v0, 4
    la $a0, dashes
    syscall #prints --------- 

    addi $a0, $s0, 0 #put first number in a0
    addi $a1, $s1, 0 #put second number in a1
    jal booths #call booths

    addi $s0, $v0, 0 #set s0 to v0
    addi $s1, $v1, 0 #set s1 to v1
    #the return from booths into s0 and s1

    li $v1, 0 #set v1 back to 0
    li $v0, 4 #set v0 to 4 for print syscall
    la $a0, newLineChar #load address for new line char
    syscall #print newline

    li $v0, 4 #for printing 
    la $a0, dashes #load the dashed
    syscall #print dashes for fomatting

    li $v0, 4 #set v0 to 4 for print syscall
    la $a0, newLineChar #load address for new line char
    syscall #print newline

    li $v0, 4 #set v0 to 4 for print syscall
    la $a0, space #loads the space
    syscall #prints a space

    add $a0, $s0, $zero #loads s0 first result into a0 for printing the binary
    jal printBin #call print bin

    add $a0, $s1, $zero #loads s1 second result into a0 for calling print bin
    jal printBin

    li $v0, 4 #set v0 to 4 for print syscall
    la $a0, newLineChar #load address for new line char
    syscall #print newline

    j end #ends the program

stringIn:
    addi $v0, $zero, 8 #string input syscall
    la $a0, convert #get the array
    addi $a1, $zero, 20
    syscall #get the input
    addi $t1, $a0, 0 # move input to t1

    addi $t2, $zero, 10 #newline ascii
    addi $s2, $zero, 10 #base 10 for decimal conversion
    addi $s3, $zero, 0 #start of conversion result

    addi $t3, $zero, 45 #ascii code for -
    
    lb $t4, 0($t1) #load the first byte of input into t4
    bne $t4, $t3, loopPositive #checks to see if first byte is the - for negative calculation
    addi $t1, $t1, 1 #increases byte by 1 skipping first element which is the -
    lb $t4, 0($t1) #loads next byte 
    beq $t4, $t2, error #sends to error if the input is "-" only
    j loopNegative
loopPositive:
    lb $t7, 0($t1) #loads 1 byte of the input into t7

    beq $t7, $t2, result #ends loop if newline char is reached, i.e the end of the string
    addi $t7, $t7, -48 #subtract 48 for string to int conversion

    blt $t7, $zero, error #errors if the input is not in the ascii range 
    bge $t7, $s2, error #errors if the input is not in the ascii range

    mul $s3, $s3, $s2 #mul by 10 for decimal total
    addu $s3, $s3, $t7 #add the converted input to running total

    blt $s3, $zero, error #error check for overflow into negative

    addi $t1, $t1, 1 #increment by 1 byte in input 
    j loopPositive

loopNegative:
    lb $t7, 0($t1) #loads 1 byte from input into t7

    beq $t7, $t2, result #ends loop if newline char is reached, i.e the end of the string
    addi $t7, $t7, -48 #subtract 48 for string to int conversion

    blt $t7, $zero, error #errors if the input is not in the ascii range
    bge $t7, $s2, error #errors if the input is not in the ascii range

    mul $s3, $s3, $s2 #mul by 10 for decimal total
    subu $s3, $s3, $t7 #subtract converted input from total to keep negative

    bgt $s3, $zero, error #error check for overflow into positive

    addi $t1, $t1, 1 #increment by 1 byte in input 
    j loopNegative

result:
    addi $v0, $s3, 0 #set the return to result 
    jr $ra #reutrn to main
booths:
    addi $sp, $sp -4 #makes space on the stack
    sw $ra 0($sp) #stores return address on stack

    addi $t9, $zero, 32 # set t9 to 32 since there will be 32 operations

    #AQQ-1 M

    addi $s2, $a0, 0 #s2 gets a0 which is M multiplicand
    add $s0, $zero, $zero #s0 gets 0 which is A
    add $s1, $a1, $zero #set s1 to Q which is second input a1 multiplier
    
    addi $t4, $zero, 1 #set t4 to 1 for A=A+M
    addi $t5, $zero, 2 #set t5 to 2 for A=A-M

    lui $s6, 32768 #convert binary
    ori $s6, $s6, 0

    boothsLoop:
    andi $t2, $s1, 1 #QQ-1 in t2
    sll $t2, $t2, 1 #
    add $t2, $t2, $t1 #adds qq-1 like number

    beq $t9, 0, boothsExitLoop #if counter t9 gets to 0 end loop
    beq $t2, $t5, subtract #check if QQ-1 is 2 for A=A-M
    beq $t2, $t4 addition #check if QQ-1 is 1 for A=A+M
    j shiftRight #go to shift case of A=A

    subtract:#A-M
    sub $s0, $s0, $s2 #subtract M in s2 from s0 A
    j shiftRight #now shift right
    addition:#A+M
    add $s0, $s0, $s2 #add M+A s0+s2
    j shiftRight #shift right

    shiftRight: #shift right case
    andi $t0, $s0 1 #gets right most bit in t0
    andi $t1, $s1, 1 #gets rightmost bit in t1

    sra $s0, $s0, 1 #shift right A s0
    srl $s1, $s1, 1 #shift right Q s1

    mul $t0, $t0, $s6 #multiply by conversion

    addu $s1, $s1, $t0 #add rightmost bit 

    li $v0, 4 #set v0 to 4 for print syscall
    la $a0, newLineChar #load address for new line char
    syscall #print newline

    li $v0, 4
    la $a0, space
    syscall #prints a space

    add $a0, $s0, $zero
    jal printBin #call print bin for A

    add $a0, $s1, $zero    
    jal printBin #call printbin for Q

    #result printed for this iteration

    addi $t9, $t9, -1 #decrament counter
    j boothsLoop #loop

    boothsExitLoop:
    lw $ra, 0($sp) #load return address from stack
    addi $ra, $ra, 4 #reset stack pointer

    addi $v0, $s0, 0 #set reuturn registers to s1 and s2
    addi $v1, $s1, 0

    jr $ra #return to main


printBin: #take an argument a0 and print the binary for it
    addi $sp, $sp -12 #make space on the stack pointer to save
    sw $t0, 0($sp) #save t1 t2 and t3 so we can use them after the method and their values
    sw $t1, 4($sp)
    sw $t2, 8($sp) 

    addi $t0, $a0, 0 #set t0 to a0 the input

    addi $t1, $zero, 32 # set t1 to 32
    lui $t2, 32768 # load upper bits of t2 to 32768 
    ori $t2, $t2, 0 # or them with 0 

    binLoop:
    and $a0, $t0, $t2 #store t2 and t0 in a0
    divu $a0, $a0, $t2 #a0/t2 
    #we are printing a0 at this moment

    li $v0, 1 #print int syscall
    syscall 
    
    #after print
    addi $t1, $t1, -1 #subtract 1 from t1
    sll $t0, $t0, 1 #shift bits by 1 to left 

    bne $t1, $zero, binLoop #if t1 is = 0 end loop

    lw $t0, 0($sp) #reload t1 t2 and t3 with original values
    lw $t1, 4($sp)
    lw $t2, 8($sp) 
    addi $sp, $sp, 12 #reset stack pointer
    jr $ra #jump with return back to main
    
error:
    li $v0, 4
    la $a0, errorMessage
    syscall #set up print string and error string to print
end:
    li $v0, 10 #syscall for ending program
    syscall