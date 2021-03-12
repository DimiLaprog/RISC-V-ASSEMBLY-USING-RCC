# INIT IN ASSEMBLY RISC V

.globl main 
.equ N,6 
.data
A: .word 48,64,56,80,96,48
.bss
B: .space 4*N


.text 


multiple_of_sixteen:
# input: a0 (number to examine if multiple)
# output: a0 (1= true, 0=false)
# prologue
# li a0,0xF1 --> uncomment and alter this line to test function as a module
addi sp,sp,-16
sw ra,0(sp)
sw s1,4(sp)
# a/b results in quotient of euclidean div
mv s1,a0        # s1--> number under examination
srli t0,s1,4    # number/16, t0 holds 
slli t0,t0,4    # 16 * quotient of (number/16)
sub t0,s1,t0    # number -16*number/16 = remainder  
bne t0,zero,noped     # if remainder is not zero a0=0 
li a0,1
j teliwse
noped:
li a0,0
teliwse:
# epilogue 
lw ra,0(sp)
lw s1,4(sp)
addi sp,sp,16
ret


a1_greater_than_a0:
# the comparison is unsigned since A[i] is positive for every i
# input: a0 (1st number),a1 (second number)
# output: a1 (1= true, 0=false)
# testing
# li a0,25
# li a1,0x8000
# end of testing
# prologue
addi sp,sp,-16
sw ra,0(sp)
sw s1,4(sp)
sw s2,8(sp)
mv s1,a1
mv s2,a0 
bgtu s1,s2,greater
less_than:
li a1,0
j telosugkrisis
greater:
li a1,1
telosugkrisis:
# epilogue 
lw ra,0(sp)
lw s1,4(sp)
lw s2,8(sp)
addi sp,sp,16
ret


myFilter:
# input: a0 (1st number),a1 (second number)
# output: a0 (1= true, 0=false)
# testing
li a0,241
li a1,242
# testing
addi sp,sp,-16
sw ra,0(sp)
sw s1,4(sp)
sw s2,8(sp)
mv s1,a1
mv s2,a0
jal multiple_of_sixteen
mv t0,a0   # result of multiple
mv a1,s1
mv a0,s2 
jal a1_greater_than_a0
and t0,t0,a1 # check if both functions returned 1
mv a0,t0
lw ra,0(sp)
lw s1,4(sp)
lw s2,8(sp)
addi sp,sp,16
ret
fill_operation:
# input: a1=A[i],a2=A[i+1] , pending store in memory
# output: a0=B[j]
# testing
# li a1,3213
# li a2,23
# testing end
addi sp,sp,-16
sw ra,0(sp)
sw s1,4(sp)
sw s2,8(sp)  
mv s2,a1
mv s1,a2 
add t0,s2,s1    # A[i] + A[i+1] = mid
addi t0,t0,2    # mid+ 2
mv a0,t0 
lw ra,0(sp)
lw s1,4(sp)
lw s2,8(sp)
addi sp,sp,16
ret


main:
# prologue
addi sp,sp,-32
sw ra,0(sp)
sw s1,4(sp)
sw s2,8(sp)
sw s3,12(sp)
sw s4,16(sp)
# t4 is i
# t5 is j
li t4,N-1
la s1,A
la s2,B
loopA:
lw s3,0(s1) # A[i]
lw s4,4(s1) # A[i+1]
mv a0,s3
mv a1,s4 
jal myFilter # return val in a0
beq a0,zero,false
true:
mv a1,s3 
mv a2,s4 
jal fill_operation
sw a0,0(s2) # return val, B[j] in a0
addi s2,s2,1 
false:
addi s1,s1,4 # frame++
addi t4,t4,-1 # i--
bne t4,zero,loopA
# epilogue 
lw ra,0(sp)
lw s1,4(sp)
lw s2,8(sp)
lw s3,12(sp)
lw s4,16(sp)
addi sp,sp,32
ret
.end
