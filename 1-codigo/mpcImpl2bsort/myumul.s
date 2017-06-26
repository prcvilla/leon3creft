/*
* Procedure to perform a 32 by 32 unsigned multiply.
* Pass the multiplier in %o0, and the multiplicand in %o1.
* The least significant 32 bits of the result will be returned in %o0,
* and the most significant in %o1.
*
* This code has an optimization built-in for short (less than 13 bit)
* multiplies. Short multiplies require 25 instruction cycles, and long ones
* require 46 or 48 instruction cycles.
*
* This code indicates that overflow has occurred, by leaving the Z condition
* code clear. The following call sequence would be used if you wish to
* deal with overflow:
*
*        call      .umul
*        nop                      ! (or set up last parameter here)
*        bnz       overflow_code  ! (or tnz to overflow handler)
*
* Note that this is a leaf routine; i.e. it calls no other routines and does
* all of its work in the out registers.  Thus, the usual SAVE and RESTORE
* instructions are not needed.
*/
.global   myumul
myumul:
or        %o0, %o1, %o4  ! logical or of multiplier and multiplicand
mov       %o0, %y        ! multiplier to Y register
andcc     %g0, %g0, %o4  ! zero the partial product and clear N and V conditions
!
! long multiply
!
mulscc    %o4, %o1, %o4  ! first iteration of 33
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4
mulscc    %o4, %o1, %o4  ! 32nd iteration
mulscc    %o4, %g0, %o4  ! last iteration only shifts
/*
* Normally, with the shift and add approach, if both numbers are
* nonnegative, you get the correct result.  With 32-bit twos-complement
* numbers, -x can be represented as ((2 - (x/(2**32))) mod 2) * 2**32.
* To avoid a lot of 2**32’s, we can just move the radix point up to be
* just to the left of the sign bit.  So:
*
*    x *  y   = (xy) mod 2
*   -x *  y   = (2 - x) mod 2 * y = (2y - xy) mod 2
*    x * -y   = x * (2 - y) mod 2 = (2x - xy) mod 2
*   -x * -y   = (2 - x) * (2 - y) = (4 - 2x - 2y + xy) mod 2
*
* For signed multiplies, we subtract (2**32) * x from the partial
* product to fix this problem for negative multipliers (see .mul in
* Section 1.
* Because of the way the shift into the partial product is calculated
* (N xor V), this term is automatically removed for the multiplicand,
* so we don’t have to adjust.
*
* But for unsigned multiplies, the high order bit wasn’t a sign bit,
* and the correction is wrong.  So for unsigned multiplies where the
* high order bit is one, we end up with xy - (2**32) * y.  To fix it
* we add y * (2**32).
*/
/* Faster code from tege@sics.se.  */
sra	%o1, 31, %o2	! make mask from sign bit
and	%o0, %o2, %o2	! %o2 = 0 or %o0, depending on sign of %o1
rd	%y, %o1		! get lower half of product
retl
 addcc	%o4, %o2, %o0	! add compensation and put upper half in place
