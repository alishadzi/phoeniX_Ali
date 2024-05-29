Computer Organization - Spring 2024
Iran University of Science and Technology
Task 1: Executing Assembly Code on phoeniX RISC-V Core
Student: Ali Shadzi
Team Members: Soha Shahzeidi & Payam kariminezhad
Student ID: 99412141
Date: May 28, 2024
Report
Quick Sort
Integer Square Root
This assembly program for RISC-V calculates the integer square root of a given value (64 in this instance) using a basic iterative method. The integer square root of a number n is the largest integer x such that x<sup>2</sup> $\le$ n.
Procedure:
Load the Value:
Initially, the program loads the value to be processed (64) into the register a0.
markdown
Copy code
    addi a0, x0, 64
Initialize Variables:
The variable t0, representing the guess, is set to 1.
css
Copy code
    li t0, 1
Loop:
The program enters a loop where it computes the square of the current guess and compares it with the value in a0.
If the square of the guess is greater than or equal to the value, the loop terminates.
Otherwise, the guess is incremented, and the loop continues.
yaml
Copy code
    loop:
        mul t2, t0, t0      # Calculate the square of the guess
        bge t2, a0, end_loop # Exit loop if guess squared >= value

        addi t0, t0, 1      # Increment guess
        j loop              # Repeat loop
End of Loop:
After exiting the loop, t0 holds the first value for which t0^2 >= a0. Consequently, t0 is decremented by 1 to obtain the largest t0 such that t0^2 < a0.
The resulting value is stored in a0.
vbnet
Copy code
    end_loop:
        addi t0, t0, -1  # Decrement guess as the loop exits when t0^2 >= a0
        sub a0, t0, x0   # Store result (integer square root) in a0
Program Termination:
The program terminates using ebreak to signify the end of execution.
markdown
Copy code
    ebreak
Purpose:
This program illustrates a simple technique for computing the integer square root through iterative approximation. It gradually increases the guess until the square of the guess exceeds or equals the target value, then adjusts to find the correct integer square root. Although not the most efficient method for large numbers, this approach is straightforward and comprehensible.