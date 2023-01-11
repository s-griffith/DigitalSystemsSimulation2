# Operands to multiply
.data
a: .word 0xBAD
b: .word 0xFEED

.text
main:   # Load data from memory
		la      t3, a
        lw      t3, 0(t3)
        la      t4, b
        lw      t4, 0(t4)
        
        # t6 will contain the result
        add		t6, x0, x0

        # Mask for 16x8=24 multiply
        ori		t0, x0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        
####################
        add t2, x0, x0 # index of b 
        ori t5, x0, 0xff # shift variable 
        addi t1, x0, 16 # size of numbers given
Loop1:
        sll t5, t5, t2 # shift the shift variable over
        and a4, t5, t4 # isolates 8 bits from b
        srl a4, a4, t2 # 8 bits from b
        mul a4, a4, t3 # multiply 8 bits from b with the 16 from a
        and a4, a4, t0 
        add a3, x0, t2 # add the two indices together
        sll a4, a4, a3 # shift the product by the sum of the indices
        add t6, t6, a4 # add the product to the output
        addi t2, t2, 8 # move the index on b by 8
        blt t2, t1, Loop1 


####################
		
finish: addi    a0, x0, 1
        addi    a1, t6, 0
        ecall # print integer ecall
        addi    a0, x0, 10
        ecall # terminate ecall


