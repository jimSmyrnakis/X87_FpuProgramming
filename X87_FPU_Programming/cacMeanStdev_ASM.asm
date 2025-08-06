.model flat , c

.code
cacMeanStdev_ASM proc
	push ebp
	mov ebp , esp
	push ebx 
	push esi
	push edi



	pop edi
	pop esi
	pop ebx
	mov esp , ebp
	pop ebp
	ret
cacMeanStdev_ASM endp
end