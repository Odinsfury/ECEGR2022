# Working with variables in memory

    .data   # Data declaration section

varA:   .word   15
varB:   .word   15
varC:   .word   10
varZ:   .word   0
var1:   .word   1
var2:   .word   2
var3:   .word   3


    .text

main:       # Start of code section

  
	
    # Read variables from memory to registers (option 2)
  	lw  s0, varA         # Load A
    lw  s1, varB         # Load B
   	lw  s2, varC         # Load C
   	lw  s3, varZ         # Load D
	lw  s4, var1		 # Load 1
	lw  s5, var2         # Load 2
	lw  s6, var3		 # Load 3
	
# if(A < B && C > 5) 
# Z = 1;
	# slt  rd, rs1, rs2  # Load Registers yo ask dude about methodology and sytnax is this not good practice?
	slt  t0, s0, s1	     # t0 holds true/false for A < B
	
	bne  t0, x0, checkC  # if t0 does not equal zero , do checkC
	j secondCheck
	
	li  t0, 10           #system call for an exit
    	ecall
	
	checkC:              # Func checkC (is 5 < C)
	addi t1, x0, 5       # Load temporary register : zero register plus 5
	slt  t2, t1, s2      # t2 holds true/false for 5 < C
	
	bne  t2, x0, logiAND # if t2 does not equal zero, do logiAND
	li  t2, 10           #system call for an exit
    	ecall
	
	logiAND:	         # Func logiAND
	AND  a0, t0, t2      # a0 holds true/false for A < B  && C > 5
	
	bne  a0, x0, PASS1   # if t3 does not equal zero, PASS1
	j secondCheck
	
	PASS1:		         # Func PASS1
	li	s3 , 1
	j exit
   
	
 
	
# else if ( A > B || ((C+1) == 7))
# Z = 2;
	secondCheck: 
	slt t0, s1, s0		 # t0 holds true/false for B < A
	bne t0, x0, PASS2
	
	
	addi t1, x0, 7		 # Load temporary register t1: zero register plus 7
	addi t2, s2, 1       # Load temporary register t2: C + 1
	
	bne  t1, t2, thirdCheck  # if 7 does not equal C + 1 do setFAL
	beq  t1, t2, PASS2   # if 7 equals C + 1 do setTRU
	

	PASS2:
	li	s3 , 2           #system call for an exit
    j exit
	
	
	
# else
# Z = 3;
	thirdCheck:
	addi s3, x0, 3
	j exit
	
# switch
	exit:
	
	beq s3, s4, case1
	beq s3, s5, case2
	beq s3, s6, case3
	
	li s3, 0
	li t0, 10           #system call for an exit
    	ecall
	
	case1:
	li s3, -1
	sw s3, varZ, t6
	li t0, 10           #system call for an exit
	ecall
	
	case2:
	li s3, -2
	sw s3, varZ, t6
	li t0, 10           #system call for an exit
	ecall
	
	case3:
	li s3, -3
	sw s3, varZ, t6
	li t0, 10           #system call for an exit
	ecall