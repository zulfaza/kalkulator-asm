;===================================|
;; Nama		: Zul Faza Makarima		|
;; Kelas	: ILKOMP-REG B			|
;; NIM		: 19/442493/PA/19242	|
;===================================|
%include "Kalkulator.INC"
WM_CREATE		equ 1h
WM_DESTROY		equ 2h
WM_COMMAND      equ 0111h
BN_CLICKED		equ 0h

EditID1			equ 1111
EditID2			equ 1112
EditID3			equ 1113
EditID4			equ 1114

btn_minID		equ 2221
btn_exitID		equ 2222
btn_plusID		equ 2223
btn_mulID		equ 2224
btn_divID		equ 2225

section .data 
ClassName		db "WindowForm", 0 
TitleBar		db "Simple Calculator", 0 
TitlemBox		db "Hasil",0
TitleExit		db "Confirm",0
ExitBox			db "EXIT?",0

EditClassName   db "Edit",0
EditText		db "",0

LblClassName	db "Static",0	
LabelText1		db "1st Number : ",0
LabelText2		db "2nd Number : ",0
LabelText3		db "Result     : ",0
LabelText4		db "Remainder  : ",0

ButtonClassName	db "Button",0

ButtonText0      db "CLEAR",0
btn_min     	 db "-",0
btn_div			 db "/",0
btn_mul      	 db "X",0
btn_exit     	 db "Exit",0
btn_plus      	 db "+",0


err_msg			db "Fail create Window. ", 0

nilai1          times 128 db 0 
nilai2          times 128 db 0
buff3          	times 128 db 0
blen1			resw 1
blen2			resw 1
blen3			resw 1
hasil			times 1024 db 0

nhasil1			dd 0
nhasil2			dd 0
strminus		db "-"
strcopy			resb 512

section .bss 
hInstance       resd 1 
CommandLine     resd 1
hWind			resd 1

hwndBtnMin     	resd 1
hwndBtn_exit     resd 1
hwndBtnPlus     resd 1
hwndBtnMul     	resd 1
hwndBtnDiv     	resd 1
hwndEdit1       resd 1
hwndEdit2       resd 1
hwndEdit3       resd 1
hwndEdit4       resd 1
hwndLbl1		resd 1
hwndLbl2		resd 1
hwndLbl3		resd 1
hwndLbl4		resd 1

section .text use32 
..start: 
GetModuleHandle
GetCommandLine
push dword 10 
push dword [CommandLine]	
push dword 0 				
push dword [hInstance]		
	 
call WindowMain 
							 
push eax
call [ExitProcess]
WindowMain:	
    enter 76, 0 
	
    RegisterClass
    CreateWindow ClassName, TitleBar, 500, 150, 500, 250 
	
	CreateLabel hwndLbl1, LabelText1, 35, 25, 120, 25
	CreateLabel hwndLbl2, LabelText2, 35, 55, 120, 25
	CreateLabel hwndLbl3, LabelText3, 35, 85, 120, 25
	CreateLabel hwndLbl4, LabelText4, 35, 115, 120, 25
	
	CreateEditBox hwndEdit1, EditText, 170, 25, 260, 25, EditID1
	CreateEditBox hwndEdit2, EditText, 170, 55, 260, 25, EditID2
	CreateEditBox hwndEdit3, EditText, 170, 85, 260, 25, EditID3
	CreateEditBox hwndEdit4, EditText, 170, 115, 260, 25, EditID4
	

	CreateButton hwndBtnMul, btn_mul, 270,  155, 40, 25, btn_mulID
	CreateButton hwndBtnDiv, btn_div, 320,  155, 40, 25, btn_divID
	CreateButton hwndBtnPlus, btn_plus, 170,  155, 40, 25, btn_plusID
	CreateButton hwndBtnMin, btn_min, 220, 155, 40, 25, btn_minID
	CreateButton hwndBtn_exit, btn_exit, 370, 155, 55, 25, btn_exitID
		
	push dword [hwndEdit1]
	call [SetFocus], 
	
    .MessageLoop: 
								 
        GetMessage 
        cmp eax, 0
        jz .MessageLoopExit 		 
		TranslateMsg	
		DispatchMsg
        jmp .MessageLoop
	.MessageLoopExit: 
		jmp .finish 
    .new_window_failed: 
        push dword 0 
        push dword 0 
        push dword err_msg 
        push dword 0 
        call [MessageBoxA] 			 
        mov eax, 1 
        leave 
        ret 16 
	.finish: 
		lea ebx, [ebp-72] 
		mov eax, dword [ebx+08]  
		leave 
		ret 16  
WindowProcedure: 
    
    enter 0, 0
    
    mov eax, dword [ebp+12] 
    
    cmp eax, WM_DESTROY
    jz .window_destroy 

    cmp eax, WM_COMMAND 
	jnz .window_default

	mov eax, dword [ebp+16]
	
	.cekbutton2:
	cmp eax, btn_exitID
    jnz .cekbuttonMin

	call mBoxKonfirmasi

	shr eax, 16					
	cmp eax, BN_CLICKED			
	jz .window_destroy          
    jmp .window_default			

	.cekbuttonMin:
	cmp eax, btn_minID			
	jnz .cekbuttonPlus

	shr eax, 16					
	cmp eax, BN_CLICKED			
	jz .kurangin              	
    jmp .window_default					

	.cekbuttonPlus:
	cmp eax, btn_plusID			
	jnz .cekbuttonMul
	shr eax, 16					
	cmp eax, BN_CLICKED			
	jz .jumlah              

    jmp .window_default			
    
	.cekbuttonMul:
	cmp eax, btn_mulID			
	jnz .cekbuttonDiv
	shr eax, 16					
	cmp eax, BN_CLICKED			
	jz .kali              

    jmp .window_default			

	.cekbuttonDiv:
	cmp eax, btn_divID		
	jnz .window_default
	shr eax, 16					
	cmp eax, BN_CLICKED			
	jz .bagi              

    jmp .window_default			
    
	.window_destroy: 
        push dword 0 
        call [PostQuitMessage] 
        jmp .window_finish 

    .window_default: 
        push dword [ebp+20] 
        push dword [ebp+16] 
        push dword [ebp+12] 
        push dword [ebp+08] 
        call [DefWindowProcA] 

        leave          
        ret 16	
	.kali:
		GetTextEditBox [hwndEdit1], nilai1, 128, blen1
		GetTextEditBox [hwndEdit2], nilai2, 128, blen2
		str2int nilai2
		mov [nilai2],eax

		str2int nilai1
		mov [nilai1],eax
		mov eax,[nilai1]
		mov esi,[nilai2]
		xor edx,edx
		mul si
		mov [nhasil1],eax
		mov [nhasil2],edx
		int2str [nhasil1],nilai1
		int2str [nhasil2],nilai2
		call TampilkanIsi
		leave
		ret 16
	.bagi:
		GetTextEditBox [hwndEdit1], nilai1, 128, blen1
		GetTextEditBox [hwndEdit2], nilai2, 128, blen2
		str2int nilai2
		mov [nilai2],eax
		str2int nilai1
		mov [nilai1],eax
		mov eax,[nilai1]
		mov esi,[nilai2]
		xor edx,edx
		div si
		mov [nhasil1],eax
		mov [nhasil2],edx
		int2str [nhasil1],nilai1
		int2str [nhasil2],nilai2
		call TampilkanIsi
		leave
		ret 16
	.kurangin:
		GetTextEditBox [hwndEdit1], nilai1, 128, blen1
		GetTextEditBox [hwndEdit2], nilai2, 128, blen2
		
		str2int nilai2
		mov [nilai2],eax

		str2int nilai1
		mov [nilai1],eax

		mov eax, [nilai1]
		mov ebx, [nilai2]
		
		cmp eax,ebx
		jl .balik
		sub eax,ebx
		mov edx, 0
		mov [nhasil1],eax
		mov [nhasil2],edx
		int2str [nhasil1],nilai1
		int2str [nhasil2],nilai2
		call TampilkanIsi
		jmp .next
		.balik:
			sub ebx,eax
			mov edx, 0
			mov [nhasil1],ebx
			mov [nhasil2],edx
			int2str [nhasil1],strcopy
			int2str [nhasil2],nilai2
			SetTextEditBox [hwndEdit3], strminus
			SetTextEditBox [hwndEdit4], nilai2
		.next:	
		leave 
		ret 16

	.clear_data:
		SetTextEditBox [hwndEdit1], EditText
		SetTextEditBox [hwndEdit2], EditText
		leave 
		ret 16
	
	.jumlah:	
		GetTextEditBox [hwndEdit1], nilai1, 128, blen1
		GetTextEditBox [hwndEdit2], nilai2, 128, blen2
		
		str2int nilai2
		mov [nilai2],eax

		str2int nilai1
		mov edx, 0	
		add eax,[nilai2]
		mov [nhasil1],eax
		mov [nhasil2],edx
		int2str [nhasil1],nilai1
		int2str [nhasil2],nilai2
		call TampilkanIsi
		leave 
		ret 16
		
    .window_finish: 
		xor eax, eax
		leave 
		ret 16 

TampilkanIsi:
		SetTextEditBox [hwndEdit3], nilai1
		SetTextEditBox [hwndEdit4], nilai2
		leave
		ret 16

mBoxKonfirmasi:
		push dword 20H
		push dword TitleExit
		push dword ExitBox     	
		push dword [hWind]		
		call [MessageBoxA]
		ret
