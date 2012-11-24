extern malloc ; Neeeded to allocate memory (substr)
section .text
externes 
      global asm_strlen
      global asm_strchr
      global asm_strcmp
      global asm_strcpy
      global asm_strrchr
      global asm_strcspn
      global asm_memchr
      global asm_memset
      global asm_memcpy
      global asm_execute
      global asm_substr

_retour: ; Return EAX and restore register (stack frame)
    pop esp 
    pop ebp 
    ret

asm_strlen:
  push ebp
  mov ebp, esp 
  push esp
      
  mov ebx, [ebp+8] ; Pointer to data (parameters)
  xor eax,eax ; Counter
 
  asm_strlen_loop:
    inc eax
    cmp byte [ebx+eax],0 ; End of char
    jne asm_strlen_loop 
   
    jmp _retour

asm_strchr:
  push ebp 
  mov ebp, esp 
  push esp 
      
  mov ebx, [ebp+12] ; Char to look for
  mov eax, [ebp+8] ; String  
  dec eax 

  asm_strchr_loop:
    inc eax ; Next character
    cmp byte [eax], 0 ; End of data
    je asm_strchr_null ; Not found (return NULL)
    cmp byte [eax],bl ; compare char
    jne asm_strchr_loop 
    
  jmp _retour
  
  asm_strchr_null:
    xor eax,eax
    jmp _retour


asm_strcmp:
  push ebp 
  mov ebp, esp 
  push esp 
  
  mov eax, [ebp+8] ; first string
  mov ebx, [ebp+12] ; second string
  xor ecx, ecx ; reset ECX
  dec eax 
  dec ebx 

  asm_strcmp_loop:
    inc ecx 
    cmp byte [eax+ecx], 0 ; end of first string ?
    je asm_strcmp_check_two ; is the second too ?
    cmp byte [ebx+ecx],0 ; end of the second string ?
    je asm_strcmp_check_one ; is the first too ?
    mov edx, [ebx+ecx] ; move to EDX to compare
    cmp byte [eax+ecx],dl 
    je asm_strcmp_loop ; if egals, continue
    
    jmp asm_strcmp_null ; Otherwise, it's wrong

  asm_strcmp_check_two:
    cmp byte [ebx+ecx], 0 
    jne asm_strcmp_null ; not the same length return false

  asm_strcmp_check_one:
    cmp byte [eax+ecx],0 
    jne asm_strcmp_null ; not the same length return false

  asm_strcmp_correct:
     xor eax, eax 
     jmp _retour
  
  asm_strcmp_null:
     mov eax, 1
     jmp _retour

asm_strcpy:
  push ebp 
  mov ebp, esp
  push esp 
  pushf ; Save  flags
  cld ; needed to increment offset

  mov edi, [ebp+8] ; Destination
  mov eax, [ebp+8] ; Destination to return
  mov esi, [ebp+12] ; Source to copy

  asm_strcpy_loop:
      cmp byte [esi],0 ; end of string
      je asm_strcpy_retour 
      movsb ; Copy ESI to EDI and increase
      jmp asm_strcpy_loop 

  asm_strcpy_retour:
    mov byte [edi],0
    popf
    jmp _retour

asm_strrchr:
  push ebp
  mov  ebp, esp
  push esp

  mov ebx, [ebp+8]
  dec ebx
  xor ecx, ecx
  mov edx, [ebp+12]

  asm_strrchr_loop:
    inc ecx
    cmp byte [ebx+ecx],0
    je _retour
    cmp byte [ebx+ecx],dl
    je asm_strrchr_letter
    
  jmp asm_strrchr_loop

  asm_strrchr_letter:
    mov eax, ebx
    add eax, ecx
    jmp asm_strrchr_loop
  
asm_strcspn:
  push ebp
  mov ebp, esp
  push esp

  mov eax, [ebp+8] ; String
  mov ebx, [ebp+12] ; To Look for
  dec eax
  dec ebx
  xor ecx,ecx ; Main counter

  asm_strcspn_loop:
    inc ecx

    cmp byte [eax+ecx],0 ; End of string
    je asm_strcspn_end 

    mov edx, [eax+ecx] ; store the actual char
    xor esi, esi ; reset counter
    
    asm_strcspn_under_loop: 
      inc esi 
      cmp byte [ebx+esi], 0 ; End
      je asm_strcspn_loop 

      cmp byte [ebx+esi],dl 
      je asm_strcspn_end ; return the position

      jmp asm_strcspn_under_loop ; keep looking
      
  asm_strcspn_end:
      dec ecx
      mov eax,ecx
      jmp _retour


asm_memchr:
  push ebp 
  mov ebp, esp
  push esp 

  mov eax, [ebp+8] ; Pointer
  dec eax 
  mov ebx, [ebp+12] ; Char
  mov edx, [ebp+16] ; Size
  xor ecx, ecx 

  asm_memchr_loop:
    inc ecx 
    cmp ecx, edx ; end 
    je asm_memchr_null ; No results
    cmp byte [eax+ecx],bl 
    jne asm_memchr_loop
    add eax, ecx ; return a pointer to the char
    jmp _retour

  asm_memchr_null: 
    xor eax, eax ; return NULL
    jmp _retour

asm_memset:
  push ebp 
  mov ebp, esp 
  push esp 

  mov eax, [ebp+8] ; Pointer
  mov ebx, [ebp+12] ; Char
  mov edx, [ebp+16] ; Size
  xor ecx, ecx 

  asm_memset_loop:
    mov [eax+ecx],bl ; Replace the value 
    inc ecx 
    cmp ecx, edx ; End (size reached)
    jne asm_memset_loop ;

  jmp _retour

asm_memcpy:
	push ebp
	mov ebp,esp
	push esp
	pushf ; Save the flags
	cld ; Increase the offsets
	
	mov edi, [ebp+8] ; Destination
	mov esi, [ebp+12] ; Source 
	mov ebx, [ebp+16] ; Size
	dec ebx ; Last char must be \0
	xor ecx, ecx ; counter

	asm_memcpy_loop:
		cmp ecx, ebx ; Check the size
		je asm_memcpy_end
		movsb	; copy ESI to EDI and increase
		inc ecx 
		jmp asm_memcpy_loop
	
	asm_memcpy_end:
		mov byte [edi],0
		sub edi, ecx ; We return to the begining of the area
		mov eax, edi ; Return to EAX
		popf; Restore the flags
		jmp _retour	; Return



asm_execute: ; This function doesn't exist in the lib but it's a quiet good training
  pop ecx ; Get the return address
  pop ebx ; Adress to jump on

  call ebx
  
  push ebx
  push ecx
  ret
 
asm_substr:
	push ebp
	mov ebp, esp
	push esp
	
	mov ebx,[ebp+8] ; Pointer
	mov ecx,[ebp+12] ; First
	mov edx,[ebp+16] ; Last
	
	
	test ecx,ecx
	jl asm_substr_negative ; If negative number
	
	asm_substr_positive:
		add ebx,ecx ; On the first char
		inc edx ; For the '\0'
		push edx ; parameters needed to malloc
		call malloc
		pop edx ; get the end
		sub edx, 2 ; One for the  \0 and One because we started at 0
		
		xor ecx, ecx ; Counter
		asm_substr_loop:
			mov esi, [ebx+ecx] ; Store the char
			mov [eax+ecx],esi ; Put it in EAX
			inc ecx 
			cmp ecx, edx ; End of the string ?
			jne asm_substr_loop 
	
	
	mov byte [eax+ecx+1],0 ; End 
	jmp _retour ; return
	
	asm_substr_negative:
		push ebx ; Parameters to asm_strlen
		call asm_strlen ; Size of the string
		pop ebx 
		add ecx, eax ; Starting char
		jmp asm_substr_positive 
		
