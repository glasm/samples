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

	; ������ � ������
	invoke GetStdHandle,STD_OUTPUT_HANDLE
	mov    hStdOut,eax
	
	; ������ ��������� �������������
	invoke  GetTickCount
	invoke  nseed, eax
	
	; ������ � �������
	mov esi, offset char 
	
	.repeat
	
		invoke nrandom, 26 	; ��������� �����
		add al, 65			; ������ (A-Z)
		mov [esi], al		; ��������� ������ ��� ������
		invoke WriteConsole, hStdOut, addr char, sizeof char, addr ReadWritten, 0 	; ����� ������� �� �����
        invoke getKey		; ���� ������� ����� �������
		
		.if al == [esi]		; ���������� ���������, ���� �����, �� ��������� ������ �������, ����� �������
			invoke SetConsoleTextAttribute, hStdOut, 10
		.else
			invoke SetConsoleTextAttribute, hStdOut, 12
		.endif
  
    .until (0)
	
	
; ��������� ������ ����������
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