.data
binary_input:     .asciz "1101"     	   @ Input binary string (changeable)
decimal_output:   .word 0            	   @ Stores decimal result of binary input
output_str:       .space 12         	   @ Buffer for decimal string (10 digits + null terminator + padding)
binary_str:       .space 33          	   @ Buffer for binary string (32 bits + null terminator)
decimal_label:    .asciz "\nDecimal: "   @ Label to print before decimal output
binary_label:     .asciz "\nBinary: "    @ Label to print before binary output

.text
.global _start

_start:
    @ PHASE 1: Convert Binary String to Decimal Integer

    LDR r0, =binary_input           	   @ Load address of binary input string into r0
    MOV r1, #0                       	   @ Clear r1; it will hold the resulting decimal value

bin_to_dec_loop:
    LDRB r2, [r0], #1               	   @ Load byte at address r0 into r2 and increment r0 by 1 (next char)
    CMP r2, #0                      	   @ Compare current char to null terminator
    BEQ store_decimal              		   @ If null terminator, we're done converting

    SUB r2, r2, #'0'                	   @ Convert ASCII '0' or '1' to numeric 0 or 1
    LSL r1, r1, #1                 		   @ Shift result in r1 left by 1 bit (multiply by 2)
    ADD r1, r1, r2                  	   @ Add current bit (0 or 1) to the result
    B bin_to_dec_loop               	   @ Repeat for next character

store_decimal:
    LDR r3, =decimal_output         	   @ Load address where the decimal result will be stored
    STR r1, [r3]                    	   @ Store the result from r1 into memory

    @ PHASE 2: Convert Decimal Integer to ASCII String

    LDR r0, =output_str              	   @ Load address of output string buffer into r0
    MOV r2, r1                     	     @ Move decimal value into r2 for conversion
    ADD r0, r0, #11                 	   @ Move r0 to the end of the buffer to build string backwards
    MOV r4, #0                      	   @ r4 = null terminator character (0)
    STRB r4, [r0]                   	   @ Store null terminator at the end
    SUB r0, r0, #1                  	   @ Step back to start filling digits

itoa_loop:
    MOV r3, #10                     	   @ r3 = 10 (divisor)
    MOV r6, #0                      	   @ r6 = quotient (init to 0)

    @ Perform manual division: r2 / 10

    div_loop:
        CMP r2, r3                  	   @ Compare value with 10
        BLT itoa_done               	   @ If less than 10, stop dividing
        SUB r2, r2, r3              	   @ Subtract 10
        ADD r6, r6, #1              	   @ Count how many times we've subtracted (quotient)
        B div_loop

itoa_done:
    MOV r4, r2                      	   @ r4 = remainder
    ADD r4, r4, #'0'               		   @ Convert remainder to ASCII character
    STRB r4, [r0]                   	   @ Store ASCII digit into buffer
    MOV r2, r6                      	   @ Move quotient into r2 to process next digit
    SUB r0, r0, #1                  	   @ Move buffer pointer back
    CMP r2, #0                      	   @ Are we done with all digits?
    BNE itoa_loop                   	   @ If not, loop again

    ADD r0, r0, #1                   	   @ Adjust r0 to point to first digit in string

    @ Print "\nDecimal: " label before printing decimal value

    LDR r7, =decimal_label
print_decimal_label:
    LDRB r1, [r7], #1
    CMP r1, #0
    BEQ print_decimal
    LDR r2, =0xFF201000
    STRB r1, [r2]
    B print_decimal_label

print_decimal:
    LDRB r1, [r0], #1                	  @ Load character from buffer and increment pointer
    CMP r1, #0                       	  @ Check for null terminator
    BEQ convert_to_binary            	  @ If null, move to next phase

    LDR r2, =0xFF201000              	  @ Load memory-mapped I/O address (UART TX)
    STRB r1, [r2]                    	  @ Send character to terminal
    B print_decimal

    @ PHASE 3: Convert Decimal Integer Back to Binary String

convert_to_binary:
    LDR r1, =decimal_output            	@ Load address of decimal result
    LDR r1, [r1]                       	@ Load the decimal value itself

    LDR r0, =binary_str              	  @ Load address of binary string buffer
    ADD r0, r0, #32                  	  @ Move to end of buffer
    MOV r2, #0                       	  @ Prepare null terminator
    STRB r2, [r0]                   	  @ Store null at the end of the string
    SUB r0, r0, #1                   	  @ Step back to build binary string in reverse

dec_to_bin_loop:
    AND r2, r1, #1                   	  @ r2 = r1 & 1 (get least significant bit)
    ADD r2, r2, #'0'                 	  @ Convert bit to ASCII character
    STRB r2, [r0]                    	  @ Store character in buffer
    LSR r1, r1, #1                   	  @ Logical shift r1 right by 1 (r1 / 2)
    SUB r0, r0, #1                   	  @ Move back one position in buffer
    CMP r1, #0                       	  @ Are we done converting?
    BNE dec_to_bin_loop              	  @ If not, continue

    ADD r0, r0, #1                   	  @ Adjust r0 to start of valid binary string

    @ Print "\nBinary: " label before printing binary string

    LDR r7, =binary_label
print_binary_label:
    LDRB r1, [r7], #1
    CMP r1, #0
    BEQ print_binary
    LDR r2, =0xFF201000
    STRB r1, [r2]
    B print_binary_label

print_binary:
    LDRB r1, [r0], #1                	  @ Load next character from binary string
    CMP r1, #0                       	  @ Null terminator?
    BEQ done                         	  @ End printing if done

    LDR r2, =0xFF201000              	  @ UART output address
    STRB r1, [r2]                    	  @ Output character
    B print_binary                   	  @ Loop to next character

done:
    B done                           	  @ Infinite loop to end the program
