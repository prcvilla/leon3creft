	.file	"bubblesort.c"
	.section	".rodata"
	.align 8
.LLC0:
	.asciz	"%3d|"
	.section	".text"
	.align 4
	.global printarr
	.type	printarr, #function
	.proc	020
printarr:
	save	%sp, -104, %sp
	st	%i0, [%fp+68]
	st	%g0, [%fp-4]
	mov	124, %o0
	call	putchar, 0
	 nop
	st	%g0, [%fp-4]
	b	.LL2
	 nop
.LL3:
	ld	[%fp-4], %g1
	ld	[%fp+68], %g2
	add	%g2, %g1, %g1
	ldub	[%g1], %g1
	and	%g1, 0xff, %g1
	sethi	%hi(.LLC0), %g2
	or	%g2, %lo(.LLC0), %o0
	mov	%g1, %o1
	call	printf, 0
	 nop
	ld	[%fp-4], %g1
	add	%g1, 1, %g1
	st	%g1, [%fp-4]
.LL2:
	ld	[%fp-4], %g1
	cmp	%g1, 9
	ble	.LL3
	 nop
	mov	10, %o0
	call	putchar, 0
	 nop
	restore
	jmp	%o7+8
	 nop
	.size	printarr, .-printarr
	.align 4
	.global checkarr
	.type	checkarr, #function
	.proc	04
checkarr:
	save	%sp, -104, %sp
	st	%i0, [%fp+68]
	st	%g0, [%fp-4]
	b	.LL6
	 nop
.LL9:
	ld	[%fp-4], %g1
	ld	[%fp+68], %g2
	add	%g2, %g1, %g1
	ldub	[%g1], %g2
	ld	[%fp-4], %g1
	add	%g1, 1, %g1
	ld	[%fp+68], %g3
	add	%g3, %g1, %g1
	ldub	[%g1], %g1
	and	%g2, 0xff, %g2
	and	%g1, 0xff, %g1
	cmp	%g2, %g1
	bleu	.LL7
	 nop
	mov	-1, %g1
	b	.LL8
	 nop
.LL7:
	ld	[%fp-4], %g1
	add	%g1, 1, %g1
	st	%g1, [%fp-4]
.LL6:
	ld	[%fp-4], %g1
	cmp	%g1, 8
	ble	.LL9
	 nop
	mov	0, %g1
.LL8:
	mov	%g1, %i0
	restore
	jmp	%o7+8
	 nop
	.size	checkarr, .-checkarr
	.global .rem
	.align 4
	.global fillArray
	.type	fillArray, #function
	.proc	020
fillArray:
	save	%sp, -104, %sp
	st	%i0, [%fp+68]
	st	%g0, [%fp-4]
	st	%g0, [%fp-4]
	b	.LL12
	 nop
.LL13:
	ld	[%fp-4], %g1
	ld	[%fp+68], %g2
	add	%g2, %g1, %l0
	call	rand, 0
	 nop
	mov	%o0, %g1
	mov	%g1, %o0
	mov	255, %o1
	call	.rem, 0
	 nop
	mov	%o0, %g1
	stb	%g1, [%l0]
	ld	[%fp-4], %g1
	add	%g1, 1, %g1
	st	%g1, [%fp-4]
.LL12:
	ld	[%fp-4], %g1
	cmp	%g1, 9
	ble	.LL13
	 nop
	restore
	jmp	%o7+8
	 nop
	.size	fillArray, .-fillArray
	.align 4
	.global bubblesort
	.type	bubblesort, #function
	.proc	020
bubblesort:
	save	%sp, -120, %sp
	st	%i0, [%fp+68]
	mov	1, %g1
	st	%g1, [%fp-20]
	st	%g0, [%fp-16]
	b	.LL16
	 nop
.LL21:
	st	%g0, [%fp-20]
	st	%g0, [%fp-12]
	b	.LL17
	 nop
.LL19:
	ld	[%fp-12], %g1
	add	%g1, 1, %g1
	st	%g1, [%fp-8]
	ld	[%fp-12], %g1
	ld	[%fp+68], %g2
	add	%g2, %g1, %g1
	ldub	[%g1], %g2
	ld	[%fp-8], %g1
	ld	[%fp+68], %g3
	add	%g3, %g1, %g1
	ldub	[%g1], %g1
	and	%g2, 0xff, %g2
	and	%g1, 0xff, %g1
	cmp	%g2, %g1
	bleu	.LL18
	 nop
	ld	[%fp-12], %g1
	ld	[%fp+68], %g2
	add	%g2, %g1, %g1
	ldub	[%g1], %g1
	stb	%g1, [%fp-1]
	ld	[%fp-12], %g1
	ld	[%fp+68], %g2
	add	%g2, %g1, %g1
	ld	[%fp-8], %g2
	ld	[%fp+68], %g3
	add	%g3, %g2, %g2
	ldub	[%g2], %g2
	stb	%g2, [%g1]
	ld	[%fp-8], %g1
	ld	[%fp+68], %g2
	add	%g2, %g1, %g1
	ldub	[%fp-1], %g2
	stb	%g2, [%g1]
	mov	1, %g1
	st	%g1, [%fp-20]
.LL18:
	ld	[%fp-12], %g1
	add	%g1, 1, %g1
	st	%g1, [%fp-12]
.LL17:
	mov	9, %g2
	ld	[%fp-16], %g1
	sub	%g2, %g1, %g2
	ld	[%fp-12], %g1
	cmp	%g2, %g1
	bg	.LL19
	 nop
	ld	[%fp-16], %g1
	add	%g1, 1, %g1
	st	%g1, [%fp-16]
.LL16:
	ld	[%fp-16], %g1
	cmp	%g1, 9
	bg	.LL22
	 nop
	ld	[%fp-20], %g1
	cmp	%g1, 0
	bne	.LL21
	 nop
.LL22:
	restore
	jmp	%o7+8
	 nop
	.size	bubblesort, .-bubblesort
	.ident	"GCC: (BCC 4.4.2 release 1.0.45) 4.4.2"
