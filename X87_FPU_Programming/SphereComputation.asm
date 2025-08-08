.model flat , c
; surf = 4 * pi (r ^ 2)
; vol  = surf * r/3 = surf * r * (1/3)
.const
r8constant_4 real8 4.0
r8constant_3 real8 3.0

.code
SphereCompute proc
	push ebp
	mov ebp , esp


	xor eax , eax ; set to false

	; compute surf
	fld real8 ptr [ebp + 8] ; st0 = r
	fldz ; st0 = 0 , st1 = r
	fcomip st(0) , st(1) ; st0 compared to st1 () and pop st0 
	fstp st(0) ; clear stack for case of wrong parameter 

	jp done ; result of substruction is NaN
	jnb done ; 0.0 > r

	;now start loading and caculating
	mov edx , [ebp + 16];surf ptr
	mov eax , [ebp + 20];vol ptr

	fld real8 ptr [ebp + 8] ; st0 = r
	fld real8 ptr [ebp + 8] ;st(0) ; st0 = r, st1 = r
	fldpi ; st0 = pi , st1 = r , st2 = r
	fld real8 ptr [r8constant_4] ; st0 = 4.0 , st1 = pi , st2 = r , st3 = r
	fmulp ; st0 = 4*pi , st1 = r , st2 = r
	fmulp ; st0 = 4*pi*r , st1 = r
	fmul st(0) , st(1)  ; st0 = 4 * pi * r * r , st1 = r
	; if fmul was writed without the parameters (operands) then doing dissasembly i a masm
	; translate it to fmulp :( , after a little search i figure out a command that has not any 
	; operand (but we expect that is implicity is st0 , st1 , ) then it translates it in to what 
	; is best fit (fmulp in my example)
	fst real8 ptr [edx]
	;st0,st1,st2,st3,st4,st5
	fld real8 ptr [r8constant_3] ; st0 = 3 , st1 = 4 * pi * r * r , st2 = r
	fst real8 ptr [eax]
	fdivp ; st0 = (4 * pi * r * r) / 3 , st1 = r
	fst real8 ptr [eax]
	fmulp ; st0 = [(4 * pi * r * r) / 3] * r
	fst real8 ptr [eax]
	fstp real8 ptr [eax]
	;st0 , st1 , st2 , st3 , st4 , st5 , st6 , st7
	xor eax , eax
	add eax , 1 ; true
done: ; when leaving fpu x87 stack must be empty if no fp value is to be return 
	mov esp , ebp
	pop ebp
	ret
SphereCompute endp

end