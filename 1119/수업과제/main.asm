.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib

STD_INPUT_HANDLE  EQU -10
STD_OUTPUT_HANDLE EQU -11

GetStdHandle  PROTO :DWORD
WriteConsoleA PROTO :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ReadConsoleA  PROTO :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ExitProcess   PROTO :DWORD

.data
    msgIn1   BYTE "첫 번째 숫자 입력 (1~9): "
    lenIn1   EQU $ - msgIn1

    msgIn2   BYTE 0dh, 0ah, "두 번째 숫자 입력 (1~9): "
    lenIn2   EQU $ - msgIn2

    msgZero  BYTE 0dh, 0ah, "0으로 나눌 수 없습니다.", 0dh, 0ah
    lenZero  EQU $ - msgZero

    hdrAX    BYTE 0dh, 0ah, 0dh, 0ah, "AX (덧셈 결과) : "
    lenHdrAX EQU $ - hdrAX

    hdrBX    BYTE 0dh, 0ah, "BX (뺄셈 결과) : "
    lenHdrBX EQU $ - hdrBX

    hdrCX    BYTE 0dh, 0ah, "CX (곱셈 결과) : "
    lenHdrCX EQU $ - hdrCX

    hdrDX    BYTE 0dh, 0ah, "DX (나눗셈 몫) : "
    lenHdrDX EQU $ - hdrDX

    crlf     BYTE 0dh, 0ah
    lenCrlf  EQU $ - crlf

    hIn      DWORD ?
    hOut     DWORD ?
    ioCount  DWORD ?
    inBuf    BYTE 16 DUP(0)
    hexBuf   BYTE 5 DUP(0)    ; 4자리 16진수 + 'h'

    num1     WORD 0
    num2     WORD 0
    resAdd   WORD 0
    resSub   WORD 0
    resMul   WORD 0
    resDiv   WORD 0

.code
main PROC
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov hOut, eax
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hIn, eax

    ; 1. 첫 번째 숫자 입력
    invoke WriteConsoleA, hOut, ADDR msgIn1, lenIn1, ADDR ioCount, 0
    invoke ReadConsoleA, hIn, ADDR inBuf, 14, ADDR ioCount, 0
    movzx eax, BYTE PTR [inBuf]
    sub al, '0'
    movzx eax, al
    mov num1, ax

    ; 2. 두 번째 숫자 입력
    invoke WriteConsoleA, hOut, ADDR msgIn2, lenIn2, ADDR ioCount, 0
    invoke ReadConsoleA, hIn, ADDR inBuf, 14, ADDR ioCount, 0
    movzx eax, BYTE PTR [inBuf]
    sub al, '0'
    movzx eax, al
    mov num2, ax

    ; 0으로 나누기 방지
    cmp num2, 0
    jne calc_start
    invoke WriteConsoleA, hOut, ADDR msgZero, lenZero, ADDR ioCount, 0
    invoke ExitProcess, 1

calc_start:
    ; 3. 사칙연산 수행
    ; [덧셈] -> AX
    mov ax, num1
    add ax, num2
    mov resAdd, ax

    ; [뺄셈] -> BX
    mov ax, num1
    sub ax, num2
    mov resSub, ax

    ; [곱셈] -> CX
    mov ax, num1
    mul num2                ; DX:AX = AX * num2
    mov resMul, ax

    ; [나눗셈] -> DX (몫)
    mov ax, num1
    xor dx, dx                ; 상위 워드 DX 초기화
    div num2                ; 몫: AX, 나머지: DX
    mov resDiv, ax

    ; 최종 결과를 AX, BX, CX, DX 레지스터에 배치
    mov ax, resAdd
    mov bx, resSub
    mov cx, resMul
    mov dx, resDiv

    ; 4. 레지스터 값 보존 후 화면 출력
    push edx
    push ecx
    push ebx
    push eax

    invoke WriteConsoleA, hOut, ADDR hdrAX, lenHdrAX, ADDR ioCount, 0
    pop ebx
    call PrintHexBX

    invoke WriteConsoleA, hOut, ADDR hdrBX, lenHdrBX, ADDR ioCount, 0
    pop ebx
    call PrintHexBX

    invoke WriteConsoleA, hOut, ADDR hdrCX, lenHdrCX, ADDR ioCount, 0
    pop ebx
    call PrintHexBX

    invoke WriteConsoleA, hOut, ADDR hdrDX, lenHdrDX, ADDR ioCount, 0
    pop ebx
    call PrintHexBX

    invoke WriteConsoleA, hOut, ADDR crlf, lenCrlf, ADDR ioCount, 0
    invoke ExitProcess, 0
main ENDP

; BX의 16비트 값을 "XXXXh" 문자열로 변환 후 출력
PrintHexBX PROC
    push ecx
    push esi
    mov ecx, 4
    lea esi, hexBuf

HexLoop:
    rol bx, 4
    mov al, bl
    and al, 0fh
    cmp al, 9
    jbe HexStore
    add al, 7

HexStore:
    add al, '0'
    mov [esi], al
    inc esi
    loop HexLoop

    mov BYTE PTR [esi], 'h'
    invoke WriteConsoleA, hOut, ADDR hexBuf, 5, ADDR ioCount, 0

    pop esi
    pop ecx
    ret
PrintHexBX ENDP

END main