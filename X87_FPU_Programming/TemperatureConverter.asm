.386
.model flat , c

.const
FToC real8 0.5555555555555556 ; 9/5
CToF real8 1.8 ; 5/9
i4_32 dword 32
;c = (f-32) * 5/9)
;f = c * 1.8 + 32
.data 
place_holder real8 0.0

.code
CelsiusToFahrenheit proc
	push ebp
	mov ebp , esp 
	

	fild real8 ptr [i4_32] ; load 32 integer into FPU stack but first converts it to double
	fld real8 ptr [CToF] ; load 1.8 into FPU stack
	fld real8 ptr [ebp + 8] ; load the first argument (Celsius) into FPU stack
	

	fmulp ;
	faddp ;
	mov eax , [ebp + 16]
	fstp real8 ptr [eax] ; store the result in eax (Fahrenheit)


	mov esp , ebp ; for safety reasons
	pop ebp
	ret
CelsiusToFahrenheit endp
;st0 , st1 , st2 , st3 , st4 , st5 , st6 , st7
; c = (f - 32) * 5/9(or FToC) 
FahrenheitToCelsius proc
	push ebp
	mov ebp , esp

	fld real8 ptr [FToC] ;
	fld real8 ptr [ebp + 8]
	fild real8 ptr [i4_32] ; load 32 integer into FPU stack but first converts it to double
	
	fsubp
	fmulp
	
	mov esp , ebp 
	pop ebp
	ret
FahrenheitToCelsius endp

end