# Working with variables in memory

    .data   # Data declaration section

varZ:	.word	2
countI:	.word   0
endI:	.word   20
endDo:	.word   100
incZ:   .word   1
incI:   .word   2
decZ:   .word   -1
decI:   .word   -1



    .text

main:       # Start of code section

  
	
    # Read variables from memory to registers (option 2)
  	lw  s0, varZ         # Load Z
    lw  s1, countI       # Load I
	lw  s2, endI         # Load end of first loop
	lw  s3, endDo		 # Load end of do while
    lw  s4, incZ		 # Load incriment z by 1
	lw  s5, incI 		 # Load incriment i by 2
	lw  s6, decZ		 # Load decriment z by 1
	lw  s7, decI		 # Load decriment i by 1
	
# for(i = 0; i <= 20; i=i+2) 
# Z++;
	beq  s1, x0, doFor	 # if s1 (countI) equals zero do for loop
	j exit
	
	doFor:				 # Begin doFor 
	add s0, s0, s4		 # inc s0 (varZ) by 1
	add s1, s1, s5		 # inc s1 (countI) by 2
	
	bne  s1, s2, doFor   # if s1 (countI) does not equals s2 (endI) 
	j doDo              # if s1 (countI) does equal s2 (endI) end doFor jump to doDo
	
	
	doDo:				 # Begin doFor		
	add  s0, s0, s4		 # inc s0 (varZ) by 1
	bne  s0, s3, doDo    # if s0 (varZ) does not equal s3 (endDo) loop doDo again
	j doWhile            # if s0 (varZ) does equal s3 (endDo) jump to whileLoop
	
	doWhile:			 # Begin doWhile
	add  s0, s0, s6      # inc s0 (varZ) by -1
	add  s1, s1, s7		 # inc s1 (countI) by -1
	slt  t0, x0, s1      # t0 holds true or false (1 or 0) if 0 > s1 (countI)
	
	bne  t0, x0, doWhile
	j exit	 # if 0 < s1 (countI) do doWhile until s1 (countI) is less than 0

	exit:
	li  t0, 10           #system call for an exit
    	ecall
	