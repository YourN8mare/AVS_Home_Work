;Вариант 7. Найти индексы положительных элементов массива А
format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize   db 'input size of vector from 1 to 100: ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strVecElemI  db '[%d]= ', 0
        strScanInt   db '%d', 0
        p db 'pause',0
        strVectorB  db 'B array:', 10, 0
        strVectorA  db 'A array:', 10, 0
        strVecAElemOut  db '[%d] = %d', 10, 0
        strVecBElemOut  db '[%d] = %d', 10, 0
        vec_A_size   dd 0
        i            dd ?
        tmp          dd ?
        A            rd 100
        B            rd 100

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) vector A input
        call VectorInput
; 2) get vector B
        call CreateVectorB
; 3) vectors  out
        push strVectorB
        call [printf]
        call VectorBOut
finish:
        call [getch]
        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vec_A_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_A_size]
        cmp eax, 0
        jng BadSize
        cmp eax, 100
        jg BadSize
        jmp getVector
BadSize:
        push [vec_A_size]
        push strIncorSize
        call [printf]
        cinvoke system,p
        push 0
        call [ExitProcess]
getVector:
        xor ecx, ecx
        mov ebx, A
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_A_size]
        jge endInputVector
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
;--------------------------------------------------------------------------
CreateVectorB:
        xor esi, esi
        xor ecx, ecx
        mov ebx, A
        mov edi,B
        dec ecx
GetPositiveIndexesLoop:
        inc ecx
        cmp ecx, [vec_A_size]
        je endCreateVectorB
        mov eax, [ebx]
        add ebx, 4
        cmp eax, 0
        jg InputElem
        jmp GetPositiveIndexesLoop
InputElem:
        mov [edi], ecx
        add edi,4
        inc esi
        jmp GetPositiveIndexesLoop
endCreateVectorB:
        ret
;--------------------------------------------------------------------------
VectorsOut:

VectorBOut:
        xor ecx,ecx
        mov ebx,B
putVecBLoop:
        mov [tmp], ebx
        cmp ecx,esi
        je VectorAOut
        mov [i], ecx
        push dword [ebx]
        push ecx
        push strVecBElemOut
        call [printf]
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecBLoop
endOutputVectorB:
        ret

VectorAOut:
        push strVectorA
        call [printf]
        xor ecx,ecx
        mov ebx,A
putVecALoop:
        mov [tmp], ebx
        cmp ecx,[vec_A_size]
        je endOutputVectorA
        mov [i], ecx
        push dword [ebx]
        push ecx
        push strVecAElemOut
        call [printf]
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecALoop
endOutputVectorA:
        cinvoke system,p
;--------------------------------------------------------------------------
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch',\
           system,'system'
