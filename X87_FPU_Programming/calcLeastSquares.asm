.model flat , c

.const
public LsEpsilon
LsEpsilon real8 1.0e-12

.code
calcLeastSquares proc
	push ebp
	mov ebp , esp
	sub esp , 8 ; create space for denom on the stack :)


	xor eax , eax
	mov ecx , [ebp + 16]
	cmp ecx , 0
	jle quit
	add eax , 1

	mov eax , [ebp +  8]; x ptr
	mov edx , [ebp + 12]; y ptr
	
	fldz ; sum_xx = 0
	fldz ; sum_xy = 0
	fldz ; sum_y  = 0
	fldz ; sum_x  = 0
;st0 = sum_x , st1 = sum_y , st2 = sum_xy , st3 = sum_xx
@@:
	cmp ecx , 0
	jz @F
	dec ecx
	
	fld real8 ptr[eax + ecx * 8]
	fld st(0)
	fld st(0)
	fld real8 ptr[edx + ecx * 8]
;st0 = y , st1 = x , st2 = x , st3 = x , st4 = sum_x , st5 = sum_y , st6 = sum_xy , st7 = sum_xx
	fadd st(5) , st(0) ; sum_y += y
	fmulp 
;st0 = x * y , st1 = x , st2 = x , st3 = sum_x , st4 = sum_y , st5 = sum_xy , st6 = sum_xx
	faddp st(5) , st(0) ; sum_xy += xy;
;st0 = x , st1 = x , st2 = sum_x , st3 = sum_y , st4 = sum_xy , st5 = sum_xx
	fadd st(2) , st(0) ; sum_x += x

	fmulp
;st0 = x * x , st1 = sum_x , st2 = sum_y , st3 = sum_xy , st4 = sum_xx
	faddp st(4) , st(0)
;st0 = sum_x , st1 = sum_y , st2 = sum_xy , st3 = sum_xx


	jmp @B
@@:
;denom = n * sum_xx - sum_x * sum_x
	fild dword ptr [ebp + 16]
;st0 = n , st1 = sum_x , st2 = sum_y , st3 = sum_xy , st4 = sum_xx
	fmul st(0) , st(4)
;st0 = n * sum_xx , ...
	fld st(1)
;st0 = sum_x , st1 = n*sum_xx ,  st2 = sum_x , st3 = sum_y , st4 = sum_xy , st5 = sum_xx
	fmul st(0) , st(0)
;st0 = sum_x * sum_x , st1 = n*sum_xx ,  st2 = sum_x , st3 = sum_y , st4 = sum_xy , st5 = sum_xx
	fsubp 
;st0 = n*sum_xx - sum_x * sum_x  , st1 = sum_x , st2 = sum_y , st3 = sum_xy , st4 = sum_xx
	fst real8 ptr [ebp - 8]

; check  if (LsEpsilon >= fabs(denom))
       ; return false;

	fld st(0)
	fabs 
	fld real8 ptr[LsEpsilon]
	fcomip st(0) , st(1)
	fstp st(0)
	xor eax , eax
	jae quit
	add eax ,1
;(*m) = (n * sum_xy - sum_x * sum_y) / denom;
	fild dword ptr [ebp + 16];
;st0 = n , st1 = denom , st2 = sum_x , st3 = sum_y , st4 = sum_xy , st5 = sum_xx
	fmul st(0) , st(4)
;st0 = n * sum_xy , st1 = denom , ...
	fld st(2)
;st0 = sum_x , st1 = n*sum_xy , st2 = denom , st3 = sum_x , st4 = sum_y , st5 = sum_xy , st6 = sum_xx
	fmul st(0) , st(4) 
;st0 = sum_x * sum_y , st1 = n*sum_xy , st2 = denom , st3 = sum_x , st4 = sum_y , st5 = sum_xy , st6 = sum_xx
	fsubp
;st0 = n*sum_xy - sum_x * sum_y , st1 = denom , st2 = sum_x , st3 = sum_y , st4 = sum_xy , st5 = sum_xx
	fld st(1)
;st0 = denom , st1 = n*sum_xy - sum_x * sum_y , st2 = denom , st3 = sum_x , st4 = sum_y , st5 = sum_xy , st6 = sum_xx
	fdivp
	mov eax , [ebp + 20]
;st0 = (n*sum_xy - sum_x * sum_y) / denom , st1 = denom , st2 = sum_x , st3 = sum_y , st4 = sum_xy , st5 = sum_xx
	fstp real8 ptr[eax]
;st0 = denom , st1 = sum_x , st2 = sum_y , st3 = sum_xy , st4 = sum_xx
	
;(*b) = (sum_xx * sum_y - sum_x * sum_xy) / denom;
;st0 = denom , st1 = sum_x , st2 = sum_y , st3 = sum_xy , st4 = sum_xx
	fld st(4)
;st0 = sum_xx , st1 = denom , st2 = sum_x , st3 = sum_y , st4 = sum_xy , st5 = sum_xx
	fmul st(0) , st(3)
;st0 = sum_xx*sum_y , ...
	fld st(2)
;st0 = sum_x , st1 = sum_xx*sum_y , st2 = denom , st3 = sum_x , st4 = sum_y , st5 = sum_xy , st6 = sum_xx
	fmul st(0) , st(5)
;st0 = sum_x*sum_xy , st1 = sum_x*sum_xy
	fsubp 
	fxch
	fdivp
;st0 = sum_x*sum_xy -   sum_x*sum_xy , st1 = denom , st2 = sum_x , st3 = sum_y , st4 = sum_xy , st5 = sum_xx
	mov edx , [ebp + 24]
	fstp real8 	ptr[edx]
;st0 = b , st1 = sum_x , st2 = sum_y , st3 = sum_xy , st4 = sum_xx
	fstp real8 ptr[ebp - 8]
	fstp real8 ptr[ebp - 8]
	fstp real8 ptr[ebp - 8]
	fstp real8 ptr[ebp - 8]
	fstp real8 ptr[ebp - 8]
	fstp real8 ptr[ebp - 8]
	fstp real8 ptr[ebp - 8]
	fstp real8 ptr[ebp - 8]
	fstp real8 ptr[ebp - 8]
	fstp real8 ptr[ebp - 8]
quit:
	mov esp , ebp
	pop ebp
	ret
calcLeastSquares endp

end