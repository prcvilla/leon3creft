!	int testandset(int *lock)
!
!	C-callable routine written in Sun Sparc assembly language that
!	implements a test and set operation.  The function is calld
!	with a pointer to single integer parameter which is the lock.  The
!	"ldstub" command below is a "compare and swap" operation that
!	indivisibly swaps a 1 into the lock parameter, and returns the
!	original value of the lock parameter (hence if the lock was
!	initially 0, it is set to 1 but a 0 is returned; if the lock was
!	initially 1, it is set to 1 and a zero is returned).

	.xstabs	".stab.index",	"/acct/wayne/cpsc823/lock/",0x64,0,0,0
	.xstabs	".stab.index",	"testandset.c",0x64,0,3,0
	.xstabs	".stab.index",	"",0x38,0,0,0
	.xstabs	".stab.index",	"",0x38,0,0,0
	.xstabs	".stab.index",	"Xt ; V=2.0", 0x3c,0,0,0
	.file	"testandset.c"
	.ident	"@(#)stdio.h	1.34	94/06/07 SMI"
	.ident	"@(#)feature_tests.h	1.6	93/07/09 SMI"
	.section	".text"
	.proc	04
	.global	testandset

	.align	4

testandset:
	!#PROLOGUE# 0
	sethi	%hi(.LF75),%g1
	add	%g1,%lo(.LF75),%g1
	save	%sp,%g1,%sp
	!#PROLOGUE# 1
.L77:
	.section	".text"

!   This is the section that does the test and set...
	mov	%i0,%o0
	ldstub	[%o0],%o1	! indivisible swap operation...

!	Move the result into the return register, and return...
	mov		%o1,%i0
	ret
	restore


	.optim	"-O~Q~R~S"
       .LF75 = -64
	.LP75 = 64
	.LST75 = 64
	.LT75 = 64
	.type	testandset,#function
	.size	testandset,.-testandset
	.ident	"acomp: (CDS) SPARCompilers 2.0.1 03 Sep 1992"
	.stabs	"",0x62, 0,0,0
