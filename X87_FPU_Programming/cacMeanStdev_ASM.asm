.model flat , c
.data
trash real8 0.0
.code
;bool cacMeanStdev_ASM(const double* arr, uint32_t n, double* mean, double* stdev);
cacMeanStdev_ASM proc
	push ebp
	mov ebp , esp
	push ebx 
	push esi
	push edi

	xor eax , eax ; make it zero
	mov ecx , dword ptr [ebp + 12] ; give me parameter uint32_t n
	; check if is not zero
	cmp ecx , eax ; eax is zero from the begining
	jz quit ; if substruct result after cmp is zero the we have bad parameter
	; else make eax true
	add eax , 1
	mov ebx , [ebp + 8]
	; use float registers to store after the loop the sum of all doubles on the arr 
	
	mov edx , ecx ; store back the value of n for later counting loop
	fldz ; add zero to the stack
@@: ; ecx is the counter , ebx is the base pointer
	cmp ecx , 0
	jz @F
	dec ecx

	; save to stack
	fld real8 ptr[ebx + ecx * (sizeof real8) ]
	faddp ; save the sum after first element is poped

	
	jmp @B
@@:
	; now devide by n
	fild dword ptr [ebp + 12] ; store n as float to the fpu stack
	fdivp ;divide result
	mov ecx , dword ptr[ebp + 16]
	fst real8 ptr[ecx] ; last result is the means
	;jmp quit
	; means is caculated , but we still needed it
	; use edx value 
	mov ecx , edx ; take back up n value (avoiding memory usage if we can)
; loop 2
; st0 , st1 , st2 , st3 , st4 , st5 , st6 , st7
	fldz ; the sum , st0 = sum , st1 = means
@@:
	cmp ecx , 0
	jz @F
	dec ecx

	; temp = arr[i] - *means
	fld st(1) ; st0 = means , st1 = sum and st2 = means
	fld real8 ptr[ebx + ecx * 8] ; real8 is 8 bytes long

	; st0 = arr[i] , st1 = means , st2 = sum , st3 = means
	;fxch st(1)
	;; st0 = means , st1 = arr[i] , st2 = sum , st3 = means
	; st0 = arr[i] , st1 = means , st2 = sum , st3 = means
	fsubp ; st0 = temp , st1 = sum , st2 = means
	fld st(0) ; st0 = st1 (temp) , st2 = sum , st3 = means
	fmulp ; st0 = temp * temp , st1 = sum , st2 = means
	faddp ; st0 = sum , st1 = means


	jmp @B
@@:
	; st0 , st1 , st2 , st3 , st4 , st5 , st6  ,st7
	fild dword ptr[ebp + 12]
	; st0 = n , st1 = sum , st2 = means
	fld1 ; st0 = 1 , st1 = n , st2 = sum , st3 = means
	fsubp
	; st0 = n-1 , st1 = sum , st2 = means
	fdivp ; st0 = sum / (n-1) , st1 = means
	fsqrt ; st0 = sqrt(sum / (n-1))
	mov ecx , [ebp + 20]
	fstp real8 ptr[ecx]
	fstp real8 ptr[trash]
quit:
	
	pop edi
	pop esi
	pop ebx
	mov esp , ebp
	pop ebp
	ret
cacMeanStdev_ASM endp
end