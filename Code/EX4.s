# INIT IN ASSEMBLY RISC V

.globl main 
.equ N,16 
.text 

count_ones:
# input: a0 (inverse of leds)
# output: a1 (number of ones)
addi sp,sp,-16
sw ra,0(sp)
sw s5,4(sp)
sw s1,8(sp)
sw s2,12(sp)
mv s5,a0        # 16 bits in s5
li t2,16
li t1,1
li s1,0
loopare:
andi t0,s5,1    # LSB
bne t0,t1,skip  # if lsb is not 1, skip (don't count ones!)
addi s1,s1,1    # ones++ (s1++)
skip:
srli s5,s5,1    # bits>>1
addi t2,t2,-1
bgtu t2,zero,loopare
mv a1,s1 
# epilogue 
lw ra,0(sp)
lw s5,4(sp)
lw s1,8(sp)
lw s2,12(sp)
addi sp,sp,16
ret

flash:
# input: a0(where to flash (leds but you have to specify)),a1 (inverse of leds),a2 (number of ones)
# output: none
addi sp,sp,-16
sw ra,0(sp)
sw s5,4(sp)
sw s1,8(sp)
mv s1,a1
mv s5,a0
mv t0,a2        # counter for flashing
flash_again:
mv a1,s1
jal print
mv a0,s5 
mv a1,zero 
jal print
addi t0,t0,-1
bgtu t0,zero,flash_again 
# epilogue 
lw ra,0(sp)
lw s5,4(sp)
lw s1,8(sp)
addi sp,sp,16
ret
wait_msb_change:
# input: a1(MSBprevious)
# output: none
addi sp , sp , - 16
sw ra, 0 ( sp )
sw s5, 4 ( sp )
sw s1,8(sp)
sw s2,12(sp)
mv s1,a1    # s1 holds old msb
indefinite_loop:
# static testing 
li t5,0b11010101010101010000000000000000 
sw t5,0(s5)
# end of testing
# reading from switches
li s5, 0x80001400 # save SWitches address on s5
lw s2,0(s5)
srli s2,s2,16 
# switches value is at 16 LSBs now in s2
srli s2,s2,12
andi s2,s2,8      # s2 holds MSB (new)
# reading from switches
bne s1,s2,telos
j indefinite_loop
telos:
# epilogue 
lw ra,0(sp)
sw s5, 4 ( sp )
sw s1,8(sp)
sw s2,12(sp)
addi sp,sp,16
ret


print:
# input: a1 (what to print),a0 (address of where to print)
# output: none
addi sp,sp,-16
sw ra,0(sp)
sw a1, 0(a0) # print
lw ra,0(sp)
addi sp,sp,16
ret


main:
addi sp,sp,-32
sw ra, 0 ( sp )
sw s5, 4 ( sp )
sw s1,8(sp)
sw s2,12(sp)
sw s3,16(sp)
sw s4,20(sp)
# set correct IO pins
li t0, 0x80001408 # save I/O control address on t0
li t1, 0x0000FFFF # mark LEDs as output
sw t1, 0(t0) # I/O =0x0000FFFF
# set correct IO pins
li s1, 0x80001404 # save LED address on s1
li s5, 0x80001400 # save SWitches address on s5
# static testing 
        li t5,0b01010101010101010000000000000000 
        sw t5,0(s5)
# end of testing
repeat:
lw s2,0(s5)
srli s2,s2,16 
# switches value is at 16 LSBs now in s2
mv s3,s2
srli s3,s3,12
andi s3,s3,8      # s3 holds MSB (old)
not s4,s2           # bitwise not of s2 is passed as argument in counting ones
mv a0,s4 
jal count_ones
mv a2,a1 
mv a0,s1 
mv a1,s2
mv a1,s4 
jal flash           # number of flashes in a1 (taken directly from count_ones to a2)
mv a1,s3
jal wait_msb_change
j repeat  # this enables continuous operation, comment out to disable
# epilogue 
lw ra,0(sp)
lw s5,4( sp )
lw s1,8(sp)
lw s2,12(sp)
lw s3,16(sp)
lw s4,20(sp)
addi sp,sp,32
ret
.end


