# Working with variables in memory

    .data   # Data declaration section

varA:   .word   15
varB:   .word   10
varC:   .word   5
varD:   .word   2
varE:   .word   18
varF:   .word   -3
varX:   .word   0

    .text

main:       # Start of code section

  
	
    # Read variables from memory to registers (option 2)
  	lw  s0, varA        # Load A
    lw  s1, varB        # Load B
   	lw  s2, varC        # Load C
   	lw  s3, varD        # Load D
	lw  s4, varE		# Load E
	lw  s5, varF		# Load F
	
	#z = (A-B);
	sub t0, s0, s1
	
	#z = z + (C*D);
	mul t1, s2, s3
	add t0, t0, t1

    #z = z + (E-F)
	sub t1, s4, s5
	add t0, t0, t1
	
	#z = z + (A/C);
	div t1, s0, s2
	sub t0, t0, t1
	
	
	
    # Store register value to memory variable (option 1)
    sw  s0, varX, t0
    
    li  a7,10       #system call for an exit
    ecall

# END OF PROGRAM

