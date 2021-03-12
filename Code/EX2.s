# INIT IN ASSEMBLY RISC V

.globl main 
.equ N,16 
.text 
add_led:
# input: a0 (ledstate),a2 (temp)
# output: a1 (leds)


# prologue
addi sp,sp,- 16
sw ra,0( sp )
sw s5,4(sp)
sw s1,8(sp)
sw s2,12(sp)
# prologue

# body
mv s5,a0  # s5 holds ledstate
mv s2,a2  # a2 holds led to add (temp)
add s5,s5,s2 # s5 holds ledstate + added led 
mv s1,s5     # leds=ledstate+added led
mv a1,s1    # move result to a1 (leds)
# epilogue
lw ra,0( sp )
lw s5,4(sp)
lw s1,8(sp)
lw s2,12(sp)
addi sp,sp,16
# epilogue
ret

sub_led:
# input: a0 (ledstate),a2 (temp)
# output: a1 (leds)


# prologue
addi sp,sp,- 16
sw ra,0( sp )
sw s5,4(sp)
sw s1,8(sp)
sw s2,12(sp)
# prologue
# body
mv s5,a0  # s5 holds ledstate
mv s2,a2  # a2 holds led to add (temp)
sub s5,s5,s2 # s5 holds ledstate - added led 
mv s1,s5     # leds=ledstate-added led
mv a1,s1    # move result to a1 (leds)
# epilogue
lw ra,0( sp )
lw s5,4(sp)
lw s1,8(sp)
lw s2,12(sp)
addi sp,sp,16
# epilogue
ret

complete_shift_on:

# input: a0 (ledstate),a3(i),a2 (led address)
# output: a1 (leds)

# prologue
addi sp,sp,- 16
sw ra,0( sp )
sw s5,4(sp)
sw s1,8(sp)
sw s2,12(sp)
mv s5,a0        # s5 holds ledstate
mv s1,a2        # s1 holds led address
li t2,1         # t2 will be temp led being shifted
li t3,N
li t4,N
addi t3,t3,-1
sub a3,t4,a3
sub a3,zero,a3
add t3,t3,a3    # add -[N-1]
loopb:
beq t3,zero,endloopb
addi t3,t3,-1
slli t2,t2,1
# left shifted
mv a2,t2 
mv a0,s5   
jal add_led
mv a0,s1
jal print
looped:
add t6,zero,zero # absolutely nothing
j loopb
endloopb:
# epilogue
lw ra,0( sp )
lw s5,4(sp)
lw s1,8(sp)
lw s2,12(sp)
addi sp,sp,16
# epilogue
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


turn_leds_on_seq:
# input: a0 (ledstate),a1(led address)
# output: a0 (ledstate)
addi sp , sp , - 16
sw ra, 0 ( sp )
sw s5, 4 ( sp )
sw s1,8(sp)
mv s5,a0 
mv s1,a1 
li t0,N
loopa:
 # missing arguments
mv a2,zero
addi a2,zero,1 # temp = 1, argument to add_led
mv a0,s5  # s5 ledstate -> a0
jal add_led # returns in a1
mv a0,s1 # led address 
jal print #  printing argument in a1
mv a3,t0 
mv a0,s5
mv a2,s1 
jal complete_shift_on

completed_shift:
add t5,zero,zero # absolutely nothing


mv s5,a1 # ledstate=leds
addi t0,t0,-1
bne t0,zero,loopa
mv a0,s5 # return ledstate
lw ra,0(sp)
lw s5,4( sp )
lw s1,8(sp)
addi sp,sp,16
ret


turn_leds_off_seq:
# input: a0 (ledstate),a1(led address)
# output: a0 (ledstate)
addi sp , sp , - 16
sw ra, 0 ( sp )
sw s5, 4 ( sp )
sw s1,8(sp)
mv s5,a0 
mv s1,a1 
li t0,N
loopaoff:
 # missing arguments
mv a2,zero
li a2,0x8000 # temp = 0x8000, argument to add_led
mv a0,s5  # s5 ledstate -> a0
jal sub_led # returns in a1
mv a0,s1 # led address 
jal print #  printing argument in a1
mv a3,t0 
mv a0,s5
mv a2,s1 
jal complete_shift_off
completed_shiftoff:
add t5,zero,zero # absolutely nothing


mv s5,a1 # ledstate=leds
addi t0,t0,-1
bne t0,zero,loopaoff
mv a0,s5 # return ledstate
lw ra,0(sp)
lw s5,4( sp )
lw s1,8(sp)
addi sp,sp,16
ret

complete_shift_off:

# input: a0 (ledstate),a3(i),a2 (led address)
# output: a1 (leds)

# prologue
addi sp,sp,- 16
sw ra,0( sp )
sw s5,4(sp)
sw s1,8(sp)
sw s2,12(sp)
mv s5,a0        # s5 holds ledstate
mv s1,a2        # s1 holds led address
li t2,0x8000    # t2 will be temp led being shifted
li t3,N
li t4,N
addi t3,t3,-1
sub a3,t4,a3
sub a3,zero,a3
add t3,t3,a3    # add -[N-1]
loopboff:
beq t3,zero,endloopboff
addi t3,t3,-1
srli t2,t2,1
# left shifted
mv a2,t2 
mv a0,s5   
jal sub_led
mv a0,s1
jal print
loopedoff:
add t6,zero,zero # absolutely nothing
j loopboff
endloopboff:
# epilogue
lw ra,0( sp )
lw s5,4(sp)
lw s1,8(sp)
lw s2,12(sp)
addi sp,sp,16
# epilogue
ret

main: 
# add_led: adds led to a specific bit in *current* ledstate
# print: prints leds (current ledstate + led added)
# complete_shift_on: shifts one led all the way accross to off msb

addi sp , sp , - 16
sw ra, 0 ( sp )
sw s5, 4 ( sp )
sw s1,8(sp)
# prologue end
# body
# set correct IO pins
li t0, 0x80001408 # save I/O control address on t0
li t1, 0x0000FFFF # mark LEDs as output
sw t1, 0(t0) # I/O =0x0000FFFF
# set correct IO pins
li s1, 0x80001404 # save LED address on s1
add s5,zero,zero # s5 ledstate initial
mv a1,s1 
mv a0,s5 
# pass ledstate and led address to turn_leds_on_seq
jal turn_leds_on_seq
mv s5,a0  # save current ledstate, comign from turning leds on
idk:
add t6,t6,zero # debug
mv a1,s1 
mv s5,a0  # current ledstate (all on initially)
jal turn_leds_off_seq
idktwo:
add t6,t6,zero # debug
# epilogue 
lw ra,0(sp)
lw s5,4( sp )
lw s1,8(sp)
addi sp,sp,16
ret
.end

