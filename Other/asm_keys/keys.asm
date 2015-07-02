.586
.model flat, stdcall

option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc

includeLib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib


getKey     PROTO


.data
	hStdOut dd ?
	hStdIn dd ?
	bytearray db 32 dup(?)
	ReadWritten dd ? 
	
	char db 20h,0h;
	
.code

start:

	; доступ к выводу
	invoke GetStdHandle,STD_OUTPUT_HANDLE
	mov    hStdOut,eax
	
	; задаем случайное распределение
	invoke  GetTickCount
	invoke  nseed, eax
	
	; доступ к символу
	mov esi, offset char 
	
	.repeat
	
		invoke nrandom, 26 	; случайное число
		add al, 65			; символ (A-Z)
		mov [esi], al		; сохраняем символ для вывода
		invoke WriteConsole, hStdOut, addr char, sizeof char, addr ReadWritten, 0 	; вывод символа на экран
        invoke getKey		; ждем нажатия любой клавиши
		
		.if al == [esi]		; сравниваем результат, если верно, то следующий символ зеленый, иначе красный
			invoke SetConsoleTextAttribute, hStdOut, 10
		.else
			invoke SetConsoleTextAttribute, hStdOut, 12
		.endif
  
    .until (0)
	
	
; процедура опроса клавиатуры
getKey PROC

    LOCAL   ir          :INPUT_RECORD
    LOCAL   uRecCnt     :UINT
    LOCAL   hStdInp     :HANDLE

    INVOKE  GetStdHandle, STD_INPUT_HANDLE
    mov     hStdInp, eax
    .repeat
        INVOKE  ReadConsoleInput, hStdInp, addr ir, 1, addr uRecCnt
        movzx   edx, word ptr ir.EventType
    .until (edx == KEY_EVENT) && (edx == ir.KeyEvent.bKeyDown)
    movzx   eax, word ptr ir.KeyEvent.wVirtualKeyCode
    ret

getKey  ENDP	

end start