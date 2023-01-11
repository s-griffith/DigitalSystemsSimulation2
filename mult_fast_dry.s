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
        ori t5, x0, 0xff # shift variable

        srli a5, t3, 8 # isolates the first byte of a
        bne a5, x0, Start # if the first byte of a is not equal to 0, we'll continue the regular loop
        # Else, swap the values of a and b, so that b is left as 16 in the multiplication
        add t2, t4, x0
        add t4, t3, x0
        add t3, t2, x0
        srli a6, t3, 8 # isolates the first byte of b
        bne a6, x0, Start
        and a4, t5, t4
        mul t6, a4, t3 # multiply 8 bits from b with the 16 from a
        and t6, t6, t0
        j Exit

Start:
        add t2, x0, x0 # index of b 
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
        srli a6, t4, 8 # isolates the first byte of b
        beq a6, x0, Exit # if the first byte of b is equal to 0, skip to the end and leave the loop
        addi t2, t2, 8 # move the index on b by 8
        blt t2, t1, Loop1 
Exit:

####################
		
finish: addi    a0, x0, 1
        addi    a1, t6, 0
        ecall # print integer ecall
        addi    a0, x0, 10
        ecall # terminate ecall


