.model flat,c
.const
DegToRad_const real8 0.01745329251994 ;pi/180
RadToDeg_const real8 57.295779513082  ;180/pi

.code
CartesianToPolarCoords proc
	push ebp 
	mov ebp , esp
	push ebx
	push edi
	push esi

	mov ebx , [ebp + 24] ; radius ptr
	mov eax , [ebp + 28] ; angle ptr
	fld real8 ptr [ebp + 16] ; y
	fld real8 ptr [ebp +  8] ; x , y
	fpatan 					 ; arctan(y/x) in rads 
	fld real8 ptr [RadToDeg_const]; pi/180 , arctan(y/x) in rads , x , y
	fmulp ; arctan(y/x) in degrees 
	fstp real8 ptr [eax] ; store to angle , then pop st0
	; st0 , st1 , st2 , st3 , st4 , st5 , st6 , st7
	fld real8 ptr [ebp +  8] ; x
	fmul st(0) , st(0) ; x*x
	fld real8 ptr [ebp + 16] ;y, x*x
	fmul st(0) , st(0) ; x*x , y*y
	faddp ; x*x + y*y
	fsqrt ; sqrt(x*x + y*y)
	fstp real8 ptr [ebx]

	pop esi
	pop edi
	pop ebx
	mov esp , ebp
	pop ebp
	ret
CartesianToPolarCoords endp

PolarToCartesianCoords proc
	push ebp 
	mov ebp , esp
	push ebx
	push edi
	push esi

	fld real8 ptr [ebp + 16] ; angle in deg
	fld real8 ptr [DegToRad_const] ; angle in deg , constant convertion to rad
	fmulp ; angle in rads
	fsincos; sin(st0) ,  cos(st0), angle in rads
	fmul real8 ptr[ebp + 8] ; x = r*sin(a) , cos(a)
	mov eax , [ebp + 24] ; x ptr
	fstp real8 ptr[eax] ; cos(a)
	fmul real8 ptr[ebp + 8]; y = r * cos(a)
	mov eax , [ebp + 28] ; y ptr
	fstp real8 ptr[eax] ;

	pop esi
	pop edi
	pop ebx
	mov esp , ebp
	pop ebp
	ret
PolarToCartesianCoords endp


end