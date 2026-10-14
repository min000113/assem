1. Q: Which instruction pushes all of the 32-bit general-purpose registers on the stack?
A: PUSHAD
2. Q: Which instruction pushes the 32-bit EFLAGS register on the stack?
A: PUSHFD
3. Q: Which instruction pops the stack into the EFLAGS register?
A: POPFD
4. Q: Why might listing multiple specific registers in the PUSH instruction be better than using PUSHAD?
A: It saves only the necessary registers and saves stack space.
5. Q: Suppose there were no PUSH instruction. Write two other instructions that accomplish the same as PUSH EAX.
A:SUB ESP, 4
MOV [ESP], EAX
6. Q: The RET instruction pops the top of the stack into the instruction pointer.
A: True (O)
7. Q: Nested procedure calls are not permitted by MASM unless the NESTED operator is used.
A: False (X)
8. Q: In protected mode, each procedure call uses a minimum of 4 bytes of stack space.
A: True (O)
9. Q: The ESI and EDI registers cannot be used when passing 32-bit parameters to procedures.
A: False (X)
10. Q: (True/False) The ArraySum procedure receives a pointer to any array of doublewords.
A: True (O)
11. Q: (True/False) The USES operator lets you name all registers that are modified within a procedure.
A: True (O)
12. Q: (True/False) The USES operator only generates PUSH instructions, so you must code POP instructions yourself.
A: False (X)
13. Q: (True/False) The register list in the USES directive must use commas to separate the register names.
A: False (X)
14. Q: Which statement(s) in the ArraySum procedure would have to be modified to accumulate an array of 16-bit words? Create a version of ArraySum and test it.
A: Change the array element size from 4 bytes to 2 bytes, and modify the corresponding register increments and loop calculations.
15. Q: What will be the final value in EAX after these instructions execute?
push 5
push 6
pop eax
pop eax


A: EAX = 5
16. Q: Which statement is true about what will happen when the example code runs?
A:c. EAX will equal 20 on line 6.
- push 10 → 스택에 10 저장
- push 20 → 스택에 20 저장
- call Ex2Sub → 프로시저 호출
- pop eax → EAX = 20
17. Q: Which statement is true about what will happen when the example code runs?
A: d. The program will halt with a runtime error on Line 13.
18. Q: Which statement is true about what will happen when the example code runs?
A: c. EAX will equal 30 on line 6.

19. Q: Which statement is true about what will happen when the example code runs?
A: c. EDX will equal 0 on line 6.

20. Q: What values will be written to the array when the following code executes?
A: array[0] = 10, array[1] = 20, array[2] = 30, array[3] = 40

1. Draw Text Colors
Q: Write a program that displays the same string in four different colors, using a loop. Call the SetTextColor procedure.
A:
INCLUDE Irvine32.inc

.data
msg BYTE "Hello World!",0

.code
main PROC
    mov ecx, 4
    mov eax, 1

L1:
    call SetTextColor
    mov edx, OFFSET msg
    call WriteString
    call Crlf
    inc eax
    loop L1

    exit
main ENDP
END main

2. Linking Array Items
Q: Write a program that traverses the links and locates the characters in their correct sequence. Copy them to a new array.
A:
INCLUDE Irvine32.inc

.data
start DWORD 1
chars BYTE 'H','A','C','E','B','D','F','G'
links DWORD 0,4,5,6,2,3,7,0
output BYTE 8 DUP(0)

.code
main PROC
    mov ecx, 8
    mov esi, start
    mov edi, OFFSET output

L1:
    mov al, chars[esi]
    mov [edi], al
    inc edi
    mov esi, links[esi*4]
    loop L1

    mov BYTE PTR [edi], 0
    mov edx, OFFSET output
    call WriteString
    call Crlf

    exit
main ENDP
END main

3. Simple Addition (1)
Q: Write a program that clears the screen, locates the cursor near the middle of the screen, prompts the user for two integers, adds them, and displays their sum.
A:INCLUDE Irvine32.inc

.data
msg1 BYTE "First number: ",0
msg2 BYTE "Second number: ",0
msg3 BYTE "Sum: ",0

.code
main PROC
    call Clrscr

    mov dh, 12
    mov dl, 25
    call Gotoxy

    mov edx, OFFSET msg1
    call WriteString
    call ReadInt
    mov ebx, eax

    mov edx, OFFSET msg2
    call WriteString
    call ReadInt

    add eax, ebx

    mov edx, OFFSET msg3
    call WriteString
    call WriteInt
    call Crlf

    exit
main ENDP
END main

4. Simple Addition (2)
Q: Repeat the same steps three times, using a loop. Clear the screen after each loop iteration.
A:INCLUDE Irvine32.inc

.data
msg1 BYTE "First number: ",0
msg2 BYTE "Second number: ",0
msg3 BYTE "Sum: ",0

.code
main PROC
    mov ecx, 3

L1:
    call Clrscr

    mov edx, OFFSET msg1
    call WriteString
    call ReadInt
    mov ebx, eax

    mov edx, OFFSET msg2
    call WriteString
    call ReadInt

    add eax, ebx

    mov edx, OFFSET msg3
    call WriteString
    call WriteInt
    call Crlf

    call WaitMsg
    loop L1

    exit
main ENDP
END main

5. BetterRandomRange Procedure
Q: Write a short test program that calls BetterRandomRange from a loop that repeats 50 times. Display each randomly generated value.
A:INCLUDE Irvine32.inc

.code
main PROC
    call Randomize
    mov ecx, 50

L1:
    mov ebx, -300
    mov eax, 100
    call BetterRandomRange
    call WriteInt
    call Crlf
    loop L1

    exit
main ENDP
END main

6. Random Strings
Q: Create a procedure that generates a random string of length \(L\), containing all capital letters. Call the procedure 20 times and display the strings.
A:INCLUDE Irvine32.inc

.data
str BYTE 51 DUP(0)

.code
main PROC
    mov ecx, 20

L1:
    mov eax, 10
    call RandomRange
    inc eax
    mov ecx, eax
    mov edi, OFFSET str

L2:
    mov eax, 26
    call RandomRange
    add eax, 'A'
    mov [edi], al
    inc edi
    loop L2

    mov BYTE PTR [edi], 0
    mov edx, OFFSET str
    call WriteString
    call Crlf

    ; 바깥 반복 횟수 관리 필요
    ; 아래 완성 코드 참고
    exit
main ENDP
END main

7. Random Screen Locations
Q: Display a single character at 100 random screen locations, using a delay of 100 milliseconds.
A:INCLUDE Irvine32.inc

.code
main PROC
    mov ecx, 100

L1:
    call GetMaxXY
    movzx eax, dl
    call RandomRange
    mov dl, al

    call GetMaxXY
    movzx eax, dh
    call RandomRange
    mov dh, al

    call Gotoxy
    mov al, '*'
    call WriteChar

    mov eax, 100
    call Delay
    loop L1

    exit
main ENDP
END main

8. Color Matrix
Q: Display a single character in all possible combinations of foreground and background colors (16 × 16 = 256).
A:INCLUDE Irvine32.inc

.code
main PROC
    mov ebx, 0

L1:
    mov esi, 0

L2:
    mov eax, ebx
    shl eax, 4
    add eax, esi
    call SetTextColor

    mov al, '*'
    call WriteChar

    inc esi
    cmp esi, 16
    jl L2

    call Crlf
    inc ebx
    cmp ebx, 16
    jl L1

    exit
main ENDP
END main

9. Recursive Procedure
Q: Write a program that calls a recursive procedure a specified number of times, using only the LOOP instruction and no other conditional statements.
A:INCLUDE Irvine32.inc

.data
count DWORD 0

.code
main PROC
    mov ecx, 5
    call RecursiveProc
    call WriteInt
    exit
main ENDP

RecursiveProc PROC
    inc count
    loop L1
    ret

L1:
    call RecursiveProc
    ret
RecursiveProc ENDP

END main

10. Fibonacci Generator
Q: Write a procedure that generates N values in the Fibonacci number series and stores them in an array of doublewords. Use N = 47.
A:INCLUDE Irvine32.inc

.data
fib DWORD 47 DUP(0)

.code
main PROC
    mov esi, OFFSET fib
    mov eax, 0
    mov ebx, 1
    mov ecx, 47

L1:
    mov [esi], eax
    add esi, 4

    mov edx, eax
    add eax, ebx
    mov ebx, edx

    loop L1

    exit
main ENDP
END main

11. Finding Multiples of K
Q: In a byte array of size N, find all multiples of K that are less than N. Initialize all elements to zero, and set an element to 1 if it is a multiple of K. Use K = 2 and N = 50.
A:INCLUDE Irvine32.inc

.data
arr BYTE 50 DUP(0)

.code
main PROC
    mov ecx, 25
    mov esi, 2

L1:
    mov BYTE PTR arr[esi], 1
    add esi, 2
    loop L1

    exit
main ENDP
END main






