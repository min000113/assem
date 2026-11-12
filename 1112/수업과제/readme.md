.386
.model flat, stdcall
option casemap :none

; 외부 헤더 없이 필요한 Windows API 직접 프로토타입 선언
GetStdHandle PROTO, nStdHandle:DWORD
WriteFile PROTO, hFile:DWORD, lpBuffer:PTR BYTE, nNumberOfBytesToWrite:DWORD, lpNumberOfBytesWritten:PTR DWORD, lpOverlapped:PTR DWORD
ReadFile PROTO, hFile:DWORD, lpBuffer:PTR BYTE, nNumberOfBytesToRead:DWORD, lpNumberOfBytesRead:PTR DWORD, lpOverlapped:PTR DWORD
ExitProcess PROTO, uExitCode:DWORD

.data
    prompt      db "Enter 5 numbers (space separated): ", 0
    prompt_len  = ($ - prompt) - 1
    msgAvg      db 13, 10, "Average: "
    msgAvg_len  = ($ - msgAvg)
    
    hStdIn      dd 0
    hStdOut     dd 0
    bytesRead   dd 0
    bytesWritten dd 0
    
    buffer      db 128 dup(0)
    sum         dd 0
    count       dd 0
    tempNum     dd 0
    isNegative  dd 0

.code

; 매크로: 문자열 출력 간소화
PrintStr MACRO str, len
    push 0
    lea eax, bytesWritten
    push eax
    push len
    lea eax, str
    push eax
    push hStdOut
    call WriteFile
ENDM

main PROC
    ; 표준 입력(STD_INPUT_HANDLE = -10) 핸들 가져오기
    push -10
    call GetStdHandle
    mov hStdIn, eax

    ; 표준 출력(STD_OUTPUT_HANDLE = -11) 핸들 가져오기
    push -11
    call GetStdHandle
    mov hStdOut, eax

    ; 안내 문구 출력
    PrintStr prompt, prompt_len

    ; 사용자 입력 받기
    push 0
    lea eax, bytesRead
    push eax
    push 127
    lea eax, buffer
    push eax
    push hStdIn
    call ReadFile

    ; 문자열을 정수로 변환하여 5개 합산
    lea esi, buffer
    mov sum, 0
    mov count, 0

parse_loop:
    mov edx, count
    cmp edx, 5
    jge calc_avg

skip_spaces:
    mov al, [esi]
    cmp al, 0
    je calc_avg
    cmp al, ' '
    je next_ch
    cmp al, 13
    je next_ch
    cmp al, 10
    je next_ch
    jmp parse_num

next_ch:
    inc esi
    jmp skip_spaces

parse_num:
    mov tempNum, 0
    mov isNegative, 0
    
    mov al, [esi]
    cmp al, '-'
    jne parse_digits
    mov isNegative, 1
    inc esi

parse_digits:
    mov al, [esi]
    cmp al, '0'
    jl num_done
    cmp al, '9'
    jg num_done
    
    sub al, '0'
    movzx eax, al
    
    mov ebx, tempNum
    imul ebx, ebx, 10
    add ebx, eax
    mov tempNum, ebx
    
    inc esi
    jmp parse_digits

num_done:
    mov eax, tempNum
    cmp isNegative, 1
    jne add_sum
    neg eax

add_sum:
    add sum, eax
    inc count
    jmp parse_loop

calc_avg:
    ; 평균 계산 (총합 / 5)
    mov eax, sum
    cdq
    mov ebx, 5
    idiv ebx            ; 몫이 EAX에 저장됨

    mov tempNum, eax    ; 결과 보관

    ; 평균 출력문 출력
    PrintStr msgAvg, msgAvg_len

    ; 결과를 문자열로 변환하여 출력
    mov eax, tempNum
    cmp eax, 0
    jge print_pos
    neg eax
    mov tempNum, eax

print_pos:
    mov eax, tempNum
    mov ecx, 10
    lea esi, buffer
    mov byte ptr [esi+10], 0
    mov ebx, 9

to_str:
    xor edx, edx
    div ecx
    add dl, '0'
    mov [esi+ebx], dl
    dec ebx
    cmp eax, 0
    jne to_str

    inc ebx
    lea edx, [esi+ebx]
    lea ecx, buffer
    add ecx, 10
    sub ecx, edx

    push 0
    lea eax, bytesWritten
    push eax
    push ecx
    push edx
    push hStdOut
    call WriteFile

    ; 프로그램 종료
    push 0
    call ExitProcess

main ENDP
END main
