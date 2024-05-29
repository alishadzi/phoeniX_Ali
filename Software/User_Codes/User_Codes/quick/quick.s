.data
num_elements: .word 10
elements:    .word 38, 2, 4, 100, -8, -230, 87, -9, 2, 3
msg_before:  .string "Array before sorting: "
msg_after:   .string "Array after sorting: "
delimiter:   .string " "
linebreak:   .string "\n"

.text
main:
    # Display the initial message
    la   a1, msg_before   # Load the address of msg_before
    li   a0, 4            # Syscall to print string
    ecall
    
    # Display the array
    la   a1, elements     # Load array address
    la   a2, num_elements # Load size address
    jal  ra, ShowArray    # Call ShowArray function
    
    # Sort the array using QuickSort
    la   a0, elements     # Load array address
    li   a1, 0            # Initialize left index to 0
    la   a2, num_elements # Load size address
    lw   a2, 0(a2)        # Load array size
    addi a2, a2, -1       # Set right index to size - 1
    jal  ra, QuickSort    # Call QuickSort function
    
    # Display the final message
    la   a1, msg_after    # Load the address of msg_after
    li   a0, 4            # Syscall to print string
    ecall
    
    # Display the sorted array
    la   a1, elements     # Load array address
    la   a2, num_elements # Load size address
    jal  ra, ShowArray    # Call ShowArray function
    
    li   a0, 10           # Syscall to exit the program
    ecall
    ebreak

QuickSort:
    # Save registers on the stack
    addi sp, sp, -28      # Allocate stack space
    sw   ra, 0(sp)        # Save return address
    sw   s0, 4(sp)        # Save s0
    sw   s1, 8(sp)        # Save s1
    sw   s2, 12(sp)       # Save s2
    sw   s3, 16(sp)       # Save s3
    sw   s4, 20(sp)       # Save s4
    sw   s5, 24(sp)       # Save s5
    
    # Initialize local variables
    mv   s0, a0           # s0 = array base address
    mv   s1, a1           # s1 = left index
    mv   s2, a2           # s2 = right index
    mv   s4, a1           # s4 = current left index
    mv   s5, a2           # s5 = current right index
    bge  s1, s2, EndQuickSort # If left index >= right index, end sorting
    
    # Choose pivot
    mv   t0, s0           # t0 = array base address
    mv   t1, s1           # t1 = left index
    slli t1, t1, 2        # t1 = left index * 4 (size of an element)
    add  t0, t0, t1       # t0 = address of array[left index]
    lw   s3, 0(t0)        # s3 = pivot element
    
Partition:
    beq  s4, s5, DonePartition # If current left index == current right index, partitioning done
    
    mv   t0, s0           # t0 = array base address
    mv   t1, s5           # t1 = current right index
    mv   t2, s4           # t2 = current left index
    slli t1, t1, 2        # t1 = right index * 4
    slli t2, t2, 2        # t2 = left index * 4
    add  t1, t0, t1       # t1 = address of array[right index]
    lw   t1, 0(t1)        # t1 = array[right index]
    add  t2, t0, t2       # t2 = address of array[left index]
    lw   t2, 0(t2)        # t2 = array[left index]
    
    # Adjust right index
    bge  s3, t1, MoveLeft # If pivot >= array[right index], move left index
    bge  s4, s5, MoveLeft # If current left index >= current right index, move left index
    addi s5, s5, -1       # Decrement right index
    j Partition           # Repeat partitioning
    
MoveLeft:
    blt  s3, t2, Swap     # If pivot < array[left index], swap elements
    bge  s4, s5, Swap     # If current left index >= current right index, swap elements
    addi s4, s4, 1        # Increment left index
    j Partition           # Repeat partitioning
    
Swap:
    bge  s4, s5, Partition # If current left index >= current right index, repeat partitioning
    mv   t0, s0           # t0 = array base address
    mv   t1, s5           # t1 = current right index
    mv   t2, s4           # t2 = current left index
    slli t1, t1, 2        # t1 = right index * 4
    slli t2, t2, 2        # t2 = left index * 4
    add  t1, t0, t1       # t1 = address of array[right index]
    lw   t3, 0(t1)        # t3 = array[right index]
    add  t2, t0, t2       # t2 = address of array[left index]
    lw   t0, 0(t2)        # t0 = array[left index]
    sw   t3, 0(t2)        # array[left index] = array[right index]
    sw   t0, 0(t1)        # array[right index] = array[left index]
    j Partition           # Repeat partitioning
    
DonePartition:
    mv   t0, s0           # t0 = array base address
    mv   t1, s1           # t1 = left index
    mv   t2, s4           # t2 = current left index
    slli t1, t1, 2        # t1 = left index * 4
    slli t2, t2, 2        # t2 = current left index * 4
    add  t1, t0, t1       # t1 = address of array[left index]
    add  t2, t0, t2       # t2 = address of array[current left index]
    lw   t3, 0(t2)        # t3 = array[current left index]
    sw   t3, 0(t1)        # array[left index] = array[current left index]
    sw   s3, 0(t2)        # array[current left index] = pivot element
    
    # Recursively sort left and right partitions
    mv   a0, s0           # a0 = array base address
    mv   a1, s1           # a1 = left index
    addi a2, s4, -1       # a2 = current left index - 1
    jal  ra, QuickSort    # Recursive call for left partition
    
    mv   a0, s0           # a0 = array base address
    addi a1, s4, 1        # a1 = current left index + 1
    mv   a2, s2           # a2 = right index
    jal  ra, QuickSort    # Recursive call for right partition
    
EndQuickSort:
    # Restore registers from the stack
    lw   ra, 0(sp)        # Restore return address
    lw   s0, 4(sp)        # Restore s0
    lw   s1, 8(sp)        # Restore s1
    lw   s2, 12(sp)       # Restore s2
    lw   s3, 16(sp)       # Restore s3
    lw   s4, 20(sp)       # Restore s4
    lw   s5, 24(sp)       # Restore s5
    addi sp, sp, 28       # Release stack space
    jr   ra               # Return to caller

ShowArray:
    mv t0, a1             # Load array base address
    lw t1, 0(a2)          # Load array size
PrintLoop:
    lw a1, 0(t0)          # Load array element
    li a0, 1              # Syscall to print integer
    ecall
    la a1, delimiter      # Load address of space string
    li a0, 4              # Syscall to print string
    ecall
    addi t0, t0, 4        # Move to next element
    addi t1, t1, -1       # Decrement array size
    bne t1, x0, PrintLoop # Loop until all elements are printed
    
    la a1, linebreak      # Load address of newline string
    li a0, 4              # Syscall to print string
    ecall
    jr ra                 # Return to caller
