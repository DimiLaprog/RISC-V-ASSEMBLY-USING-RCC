# INIT IN ASSEMBLY RISC V

.globl main 

.equ N, 10 

.data 
A: .word 0,1,2,7,-8,4,5,-12,11,-2 
B: .word 0,1,2,7,-8,4,5,12,-11,-2 

.bss 
C:.space 4*N 

.text 

add_to_C:
addi sp , sp , - 16
sw ra, 0 ( sp )
sw s1, 4(sp)
sw s2, 8(sp)
sw s3, 12(sp)

# prologue


# body
lw s2,0(a2)
lw s3,0(a3)
add s1,s2,s3
mv a0,s1 
jal abs_val
mv s1,a0 
sw s1,0(a1)

# epilogue

lw ra, 0 ( sp )
lw s1, 4(sp)
lw s2, 8(sp)
lw s3, 12(sp)
addi sp ,sp,16


ret

abs_val:
addi sp , sp , - 16
sw ra, 0 ( sp )
bge a0,zero,nochange
sub a0,zero,a0
nochange:
lw ra,0(sp)
addi sp,sp,16
ret

main:

# prologue

add sp , sp , - 16
sw ra, 0 ( sp )

# code -BODY

la a2, A # t0 pointer to first element of A 
la a3, B 
la a1, C
addi a3, a3, 4*(N-1) # t1 pointer to last element of B
li t0,N
loopa:

jal add_to_C

addi a2,a2,4
addi a3,a3,-4
addi a1,a1,4
# loop stuff


addi t0,t0,-1
bne t0,zero,loopa
label_check:
add t1,t1,zero # does absolutely nothing
# epilogue
lw ra,0(sp)
addi sp,sp,16
ret



.end
