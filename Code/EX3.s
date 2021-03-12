# INIT IN ASSEMBLY RISC V

.globl main 

.text 

print:
# input: a1 (what to print),a0 (address of where to print)
# output: none
addi sp,sp,-16
sw ra,0(sp)
sw a1, 0(a0) # print
lw ra,0(sp)
addi sp,sp,16
ret

keep_4_msbs:
# input:a0 (16 bits)
# output: a0: 4 MSBs of 16 bits

addi sp,sp,-16
sw ra,0(sp)

srli a0,a0,0x000C
andi a0,a0,15 # >>12 and keep 4 lsbs

lw ra,0(sp)
addi sp,sp,16
ret
sum_four_and_overflow:
# input:a0,a1 4 bit numbers in LSB to add
# output: a1: 4 LSB result or or overflow value at fifth bit
addi sp,sp,-16
sw ra,0(sp)
add t0,a0,a1 
li t1,0x000E # overflow edge val=14
bgeu t1,t0,oklimit # (if 14>=sum, limit is ok)
li t0,0x0010 # if overflow, then only 5th bit on
oklimit:
mv a1,t0
lw ra,0(sp)
addi sp,sp,16
ret


main: 
addi sp,sp,-16
sw ra, 0 ( sp )
sw s5, 4 ( sp )
sw s1,8(sp)
sw s2,12(sp)
# prologue end
# body
# set correct IO pins
li t0, 0x80001408 # save I/O control address on t0
li t1, 0x0000FFFF # mark LEDs as output
sw t1, 0(t0) # I/O =0x0000FFFF
# set correct IO pins
li s1, 0x80001404 # save LED address on s1
li s5, 0x80001400 # save SWitches address on s5
# static testing 
       li t5,0b00010101010101010000000000000000 
       sw t5,0(s5)
# end of testing
lw t0,0(s5)
srli t0,t0,16 
# switches value is at 16 LSBs now in t0
andi s2,t0,15  # 4_lsbs at s2 now
mv a0,t0 
jal keep_4_msbs # a0-> s3 holds MSBs
mv s3,a0 
mv a0,s3  # ofcourse this is not needed, just doing it for formality and convention
mv a1,s2 
jal sum_four_and_overflow
mv a0,s1 
jal print # a1 argument ready 
lw ra,0(sp)
lw s5,4( sp )
lw s1,8(sp)
lw s2,12(sp)
addi sp,sp,16
ret
.end