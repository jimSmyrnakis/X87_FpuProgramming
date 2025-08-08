 
.model flat , c


 .const
 r4_MinFloat dword 0ff7fffffh                ;smallest float number
 r4_MaxFloat dword  7f7fffffh                ;largest float number
 ;bool MinMaxF32Asm(const float* arr, uint32_t n, float* min, float* max);
.code
MinMaxF32Asm proc
	push ebp
	mov ebp , esp
	push ebx 
	push esi
	push edi

	
	xor eax , eax
	mov ecx , [ebp + 12]
	cmp ecx , 0
	jz quit
	add eax , 1
	mov ebx , [ebp + 8]

	fld real4 ptr[ebx ]	; st0 = min
	fld st(0)										; st0 = max , st1 = min

@@:
	
	cmp ecx , 0
	jz @F
	dec ecx

	fld real4 ptr[ebx + ecx * (sizeof real4)]
	fld st(0)
	;st0 = arr[i] , st1 = arr[i] , st2 = max , st3 = min
	fcomi st(0) , st(3)
	fcmovnb st(0) , st(3)
	;st0 = min(arr[i] , st2) , st1 = arr[i] , st2 = max , st3 = min
	fstp st(3)
	;st3 = st0 , pop st0 so , st0 = arr[i] , st1 = max , st2 = min
	fcomi st(0) , st(1)
	fcmovb st(0) , st(1)
	;st0 = max(arr[i] , st1) , st1 = max , st2 = min
	fstp st(1)
	;st0 = max , st1 = min

	jmp @B
@@:

	mov ebx , [ebp + 16]
	mov ecx , [ebp + 20]
	fstp real4 ptr[ecx]
	fstp real4 ptr[ebx]
	; st0 , st1 , st2 , st3 , st4 , st5 , st6, st7
quit:
	pop edi
	pop esi
	pop ebx
	mov esp , ebp
	pop ebp
	ret
MinMaxF32Asm endp
end