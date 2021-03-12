# RISC-V-ASSEMBLY-USING-RCC
RISC-V assembly programs written on digilent nexys a7 using the RISC-V Calling Convention for calling and jumping between routines.


## Exercises Rubrics 

### EX 1: 
Save to int array C the value abs-value(A[i]+B[N-i-1]) for every i 

### EX 2:
1. Turn on LSB LED
2. Roll and turn on the next one
3. Repeat until MSB is on
4. Keeping the MSB led on repeat 1-2-3, until all leds are on.
5. Repeat 1-2-3-4 but this time by rolling a zero from MSB.

### EX 3:
Add 4 MSBs and 4 LSBs of Switches and put the result on 4 LSBs of LEDS. In case of overflow, only 5th LED LSB should turn on.

### EX 4:
Flash the bitwise not of Switches (on-off) n times on the LEDs. n is the number of "ones" (1) contained in the bitwise not of Switches.
While Flashing, ignore any cahnge in switches. After flashing, LEDs remain OFF until the MSB of switches Changes.

### EX 5(MyFilter):
Implement the following function following RCC:


* #define N 6
* int i, j=0, A[N]={48,64,56,80,96,48}, B[N];
* for (i=0; i<(N-1); i++) {
*   if ( (myFilter(A[i],A[i+1]) ) == 1) {
*     B[j]=A[i] + A[i+1] + 2;
*     j++;
*     }
* }
* myFilter returns 1 iff its first argument is a multiple of 16 and the second argument is greater than the first one. Otherwise it returns 0
  
## For pseudocode solutions check the corresponding PDF. For the assembly code check the "code" file.  

## There is also a pdf concerning loops in C

## Intellectual Property: Feel free to use any programs or routine to your projects

## Author: Dimitrios Lampros
