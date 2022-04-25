# Working with variables in memory

    .data   # Data declaration section
	
arrayA5:	.word	0,0,0,0,0
arrayB5:	.word	1,2,4,8,16
intI:		.word	0
incI:		.word   1
mult2:		.word   2
endFor:		.word   5

    .text

main:       # Start of code section

  
	
    # Read variables from memory to registers (option 2)
  	la  s0, arrayA5         # Load Array 5 elements
	la  s1, arrayB5			# Load Array 5 Set elements
	lw  s2, intI			# Load Int Int
	lw  s3, incI			# Load incriment I
	lw  s4, mult2			# Load multiply by 2
	lw  s5, endFor			# Load limit 5
	
	
# for(i = 0; i < 20; i++) 
	beq  s2, x0, doFor
	j exit
	
	doFor:
	beq  s2, s5 dropI       # Branch if i = 5 *should be less than but thug life do function dropI
	slli t0, s2, 2			# t0 points to intI address (first 2 bits)	
	add  t1, s1, t0			# t1 is pointing to the addres of the value at intI (first 2 bits)
	lw   t2, 0(t1)			# t2 holds, Load word of the pointed location (intI)(t1)
	sub  t2, t2, s3
	
	add  t3, s0, t0			# t3 is pointing to values address in arrayA
	lw   t4, 0(t3)	        # t4 holds, Load word of the pointed location t3 (pointed values address in A)
	add  t4, t4, t2
	sw   t4, 0(t3)
	
	add s2, s2, s3
	
	j doFor
	
	
	dropI:
	sub s2, s2, s3
	j wHile
	
	
	wHile:
	
	
	exit:
	li t0, 10
		ecall
	