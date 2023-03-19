# Group 6
# Kaitlin Colvin 1527861 hostileblonde
# Bradyn Combs TU NUMBER GITHUB-NAME
# Eli Shelton TU NUMBER GITHUB-NAME

#data for return err statement
.data
errorString: .asciiz "input error!\n"
spaceString: .asciiz " "
endString: .asciiz "\n"
xString: .asciiz "X"
lineString: .asciiz "----------\n"

.text
.globl main

# s0 is multiplicand, s1 is multiplier
main:
#protect the ra in stack
addi $sp, $sp, -4
sw $ra, 0($sp)

#parsing str1 (s0) from the console
addi $a0, $gp, 4 #set string 1 byte away from gp
addi $a1, $zero, 15 #set string length to 15 
addi $v0, $zero, 8 # 8 syscall code for reading string
syscall

#str1 to integer and place in s0
addi $a0, $zero, 4 
jal signedStringConversion #returns thing in v0
beq $v0, -1, returnError #if val is -1 then return an error
add $s0, $v0, $zero #s0 now holds the return val

#str1 stored 1 byte away from the gp

#parsing str2 (s1) from the console
addi $a0, $gp, 72 #set str2 18 bytes away from the gp
addi $a1, $zero, 15 #str2 length is set to 15
addi $v0, $zero, 8 #syscall 8 code reads str
syscall

#str2 stored 18 bytes away from the gp

#single check for negative sign
#checkers for non numerical ascii values, break to input error return

#str2 to integer and place in s1
addi $a0, $zero, 72 
jal signedStringConversion 
beq $v0, -1, returnError 
add $s1, $v0, $zero #s1 now holds the return val

#print the inputs
la $a0, spaceString #loads str into a0
addi $v0, $zero, 4 #syscall 4 to print str
syscall

#print multicands (s0) bits
add $a0, $s0, $zero
jal printBits

la $a0, endString #load in endString
addi $v0, $zero, 4 
syscall

la $a0, xString #load in xString
addi $v0, $zero, 4 
syscall

#print multiplier (s1) bits
add $a0, $s1, $zero
jal printBits

la $a0, endString
addi $v0, $zero, 4 
syscall

la $a0, lineString
addi $v0, $zero, 4 
syscall

#load s0 in a0 and s1 in a1
add $a0, $s0, $zero
add $a1, $s1, $zero
jal booths
add $t0, $v0, $zero #temp register has v0

la $a0, lineString #load in lineString
addi $v0, $zero, 4 
syscall

la $a0, spaceString #load spaceString into a0
addi $v0, $zero, 4 
syscall

add $a0, $t0, $zero #set high register as input
jal printBits
add $a0, $v1, $zero #set low register as input
jal printBits

la $a0, endString
addi $v0, $zero, 4 
syscall

#restoring stack and exit main
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

returnError:
la $a0, errorString #load err into a0
addi $v0, $zero, 4 
syscall
#restoring stack and exit main
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra


#returns a signed integer in v0/-1 if input err, also takes arg a0 (distance from string to pointer)
#uses s7 as a bool val
signedStringConversion:

#protecting stack
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $s0, 4($sp) 

add $s7, $zero, $zero #s7 is now zero
add $t0, $gp, $a0 #t0 points to the string
addi $s0, $zero, 10 #s0 is ten for the mult
add $v0, $zero, $zero #return val v0 is zero
lbu $t1, 0($t0) #loading first byte in t1
beq $t1, 45, negative #if negative, goto negative
beq $t1, 10, errorReturn #if ten (which is zero), goto err
j checked #if not, jump to loops second line

#checking if there is non numerical chars
load:
lbu $t1, 0($t0) #str byte loaded into t1
checked:
beq $t1, 10, stringDone #see if the str is done
slti $t4, $t1, 48 #if byte is less than 49, return 1
beq $t4, 1, errorReturn #if ascii value is more than 10 but less than 32, goto err
slti $t4, $t1, 58 #if curr byte less than 58, return 1
beq $t4, $zero, errorReturn #if byte greater than 58, return err
mult $v0, $s0 #v0 times 10
#check if high is greater than zero
mfhi $t3 #high reg into t3
slt $t4, $zero, $t3 
bne $t4, $zero, errorReturn #if reg has overflow, goto err
mflo $v0 #move product into v0 
addi $t2, $t1, -48 #t2 is nums decimal val
addu $v0, $v0, $t2 #add byte value into v0
addi $t0, $t0, 1 #incrument gp pointer
beq $v0, 2147483648, checkNeg
j load

#checking for output overflow (hint use high low)

#see if unsigned v0 stays in neg max or return err for post. overflow
checkNeg:
bne $s7, 1, errorReturn
#restoring stack and return
lw $ra, 0($sp)
lw $s0, 4($sp)
addi $sp, $sp, 8
jr $ra


#if num is negative, s7 is one
negative:
addi $s7, $zero, 1 #set bool s7 to one 
addi $t0, $t0, 1 #incrument gp pointer 
lbu $t1, 0($t0) #load str byte in t1 
beq $t1, 10, errorReturn #if the next byte is endstring return err 
j checked #jump to load

#place signed int in v0 and return
stringDone:
#check if either string is negative
#change binary to be twos complement if yes 
#print out binary of the 32 bit s0 and s1
bne $s7, 1, nonneg #if s7 is 0 then it is not negative
#twos complment conversion
not $v0, $v0
addi $v0, $v0, 1
nonneg:
#restoring stack and return
lw $ra, 0($sp)
lw $s0, 4($sp)
addi $sp, $sp, 8
jr $ra


#if error return -1
errorReturn: 
addi $v0, $zero, -1
#restoring stack and quit
lw $ra, 0($sp)
lw $s0, 4($sp)
addi $sp, $sp, 8
jr $ra


#v0 is high register and v1 is low register 

booths:
#protect in stack
addi $sp, $sp, -4
sw $ra, 0($sp)

#set up s0, s1
add $s0, $zero, $zero #A zero
addi $s1, $zero, 32 #count is 32
add $s2, $zero, $zero #q-1 is 0

#check (q plus q-1)s last bit
#get qs last bit
loop:
and $t0, $a1, 1 #t0 is last bit
sll $t0, $t0, 1 #shifting q by one
add $t0, $t0, $s2 #t0 is tq0 val, q-1
beq $t0, 2, minusM
beq $t0, 1, addM
aritShift:
#arithm. shift right code, carryout is t1

#a reg, perserve as last bit and check a1s first bit 
and $t1, $s0, 1 #A first bit
and $t2, $s0, 2147483648 #t2 is As last bit
srl $t2, $t2, 31 #shift As last bit to t2s first bit
beq $t2, 1, oneShift
srl $s0, $s0, 1 #A shifted one bit, new bit is zero
#done shifting A
shiftQ:
#first step shift Q
and $s2, $a1, 1 #qs last bit into q-1
srl $a1, $a1, 1 #shift Q by one 
beq $t1, 1, shiftOne

#print bits

addi $sp, $sp, -4
sw $a0, 0($sp) #protect stack and store a0

la $a0, spaceString #load in spaceString
addi $v0, $zero, 4 
syscall

add $a0, $s0, $zero #put A in arg
jal printBits #call printBits

add $a0, $a1, $zero #put Q in arg
jal printBits 

la $a0, endString
addi $v0, $zero, 4 
syscall

lw $a0, 0($sp)
addi $sp, $sp, 4 #restore stack and a0

addi $s1, $s1, -1 #decrease count
beq $s1, $zero, finished
j loop


#A shift
oneShift:
srl $s0, $s0, 1 #A shifts right by one
or $s0, $s0, 2147483648 #make one as the last bit to follow shift right
j shiftQ

#QShift
shiftOne: 
or $a1, $a1, 2147483648  #add 1 in qs last bit

#print bits

addi $sp, $sp, -4
sw $a0, 0($sp) #protect stack and store a0

la $a0, spaceString #load spaceString
addi $v0, $zero, 4 
syscall

add $a0, $s0, $zero #put A in arg
jal printBits #call printBits

add $a0, $a1, $zero #put Q in arg
jal printBits 

la $a0, endString
addi $v0, $zero, 4 
syscall

lw $a0, 0($sp)
addi $sp, $sp, 4 #restore stack and a0

addi $s1, $s1, -1 #decrease count
beq $s1, $zero, finished
j loop

minusM:
sub $s0, $s0, $a0 #A <- A - M
j aritShift

addM:
add $s0, $s0, $a0 #A <- A + M
j aritShift

#v0 as high register, v1 as low register 
finished: 
add $v0, $s0, $zero #v0 is high (A)
add $v1, $a1, $zero #v1 is low (B)

#return stack
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

#a0 is a int, then prints ints bits
#uses t1 and other temps through both loops 

printBits:
#protect stack
addi $sp, $sp, -20
sw $ra, ($sp)
sw $v0, 4($sp) 
sw $t0, 8($sp)
sw $t1, 12($sp)
sw $t2, 16($sp)

add $t0, $zero, $zero #incrementer is now zero
addi $v0, $zero, 1 #sets syscall value to print int

bitLoop:
and $t1, $a0, 2147483648 #load a0s last bit 
srl $t1, $t1, 31 #shift the bit to first bit
add $t2, $a0, $zero #set t2 to a0
add $a0, $t1, $zero #set a0 to inputs last bit
syscall
add $a0, $t2, $zero #a0 back to input
sll $a0, $a0, 1 #shifts a0 one bit left
addi $t0, $t0, 1 #incrument t0
beq $t0, 32, procDone #if 32 bits loaded,procedure is done
j bitLoop #if not loop again

procDone:
#restore stack and return
lw $ra, 0($sp)
lw $v0, 4($sp)
lw $t0, 8($sp)
lw $t1, 12($sp)
lw $t2, 16($sp)
addi $sp, $sp, 20
jr $ra
