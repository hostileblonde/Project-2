# prj2.asm
CS-2033 Spring, Group 6: Booth's Algorithm

This is the second project using QtSpim and Github Classroom. Please test your code thoroughly on your laptop before submitting for auto-grading. Your grade will be based on your last attempt.

Note that you cannot make any changes to run.sh or run1.sh.

Project 2 - Booth's Algorithm Group 6: Eli Shelton, Bradyn Combs, Kaitlin Colvin

* Every member must individually submit to Github classroom.
* Add comments at the beginning of code and include the group number and member names.
* Final source code name: prj2.asm
* Add both source code and reportX.pdf to local repo and push to Github.

GOAL: Implement Booth's Algorithm for 32-bit multiplicand/multiplier, and print the product as a binary, 64-bit integer.
  * Section 3.3 Slides for alorithm review
  * DO NOT directly use MIPS mult instruction to multiply the 2 inputs. Mult only allowed when converting keyboard string inputs to integer multiplicand/multiplier.

Input Requirements:
  * Must accept keyboard STRING inputs (use syscall 8 exactly twice) and interpret them as SIGNED INTEGERS for the multiplicand/multiplier
    - HINT: in proj 1, you have implemented the conversion from string input to int output, so you may adapt that code for this project
  * Both inputs can be negative or not, and prgram must handle that
  * Must check for non-numeric inputs and report as "input error!"
    - In addition, note that a 32-bit signed int exactly fits in a general purpose register in MIPS and range is between -2^31 to 2^31 - 1. Program must identify if inputs are in range
    - If not in range, print same input error -HINT: mult instr is still used for string to int conversion, you may want to use MFHI and MFLO to help check if converted int is within range
    - Also think about whether the multiplicand can be equal to -2^31. The multiplicand and its opposite value are both needed by Booth's algorithm: Will this multiplicand value cause any problem? Take care of it in code if so.
  * NOTE: DO NOT USE AN INFINITE LOOP TO RECEIVE KEYBOARD INPUT

Output Requirements:
  * Output product is a 64 bit. As long as 32- input bits are properly checked, there's no overflow to product
  * CODE WILL NEED: 1 register for A, 1 for Q, 1 for Q of -1.
  * ARITHMETIC SHIFT RIGHT operation should be performed on AQ(Q of -1) together.
  * As multiplier is 32 bit, loop of algorithm should contain 32 iterations.
  * At the end of each iteration, program should PRINT CURRENT AQ (arithmetic right shifted) as an intermediate result.
  * Since these are two registers, you will PRINT THEIR CONCATENATED 64 bit binary. After algorithm terminates, you must also PRINT FINAL RESULT AS LAST AQ in 64 bit binary

Sample output in QTSpim: (picture included in PDF handout)
  * DONT PRINT ANY MESSAGE TO PROMPT FOR KEYBOARD INPUTS
  * Directly use syscall 8 twice: One to receive multiplicand, next to receive a multiplier
    - For example, when you hit QtSpim run button, you key in 5 (and Enter) and 9 (and Enter) for multiplicand and multiplier syscalls respectively, then the output of your code must be the following format shown in proj 2 PDF.
    - Row 1 and 2 are 32 bit multiplicand (=5) and multiplier (=9) in binary. NOTE: the multiplicand is printed with a space char to start and a newline character to end. multiplier is printed with an uppercase X to start and a newling to end
    - 32 rows between the 2 separating lines ( each has 10 hyphens) are the intermediate AQs in binary from each iteration. Each row is 64 bit with a space to start and a newline to end
    - Last row is final product, with a space to start and a newling to end (verify by yourself if binary sequence in the picture is = 45)
  * If you enter any non-numeric input or out of range value, your code should print error and RETURN AT ONCE
    - For Example, you key in abs, code should print: input error! (which ends with newline). If you key in 56 for multiplicand syscall but 8000000000 (which is too large) for the multiplier syscall, should print the same message

Pair Programming Requirements:
  * One will be a programmer and the other will be an observer, and you guys must frequently switch between the two roles
  * One page report must be written with your partners which needs to include:
    - How you switched roles on different parts of the program
    - How you handled difficulties and program bugs together
    - The difference between pair programming on proj2 and individual programming on proj 1
    - Name the report as: reportX.pdf, where X = group number.

Submission: : https://classroom.github.com/a/T1w_qTnV
