! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine fft(s, n, ifft)
    implicit none
#include "jeveux.h"
#include "blas/zscal.h"
#include "asterc/r8pi.h"
#include "asterfort/assert.h"
#include "asterfort/veri32.h"
!-----------------------------------------------------------------------
! IN,OUT : S    FONCTION A TRANSFORMER
! IN     : N    NOMBRE DE POINTS DE LA FONCTION
! IN     : IFFT > 0 => FFT
!               < 0 => FFT INVERSE
!
    complex(kind=8) :: u, w, t
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
! parametres
    integer :: n, ifft
    complex(kind=8) :: s(n)
! variables locales
    integer :: i, ip, isgn, j, k, l
    integer :: le, le1, m, n2, nm1, nv2
    complex(kind=8) :: calpha
    real(kind=8) :: pi
!-----------------------------------------------------------------------
!
    m= int(log(dble(n))/log(2.d0))
!    if (m .gt. 30) call veri32()
    n2 = 2**m
    if (n2 .ne. n) then
        m = m+1
!        if (m .gt. 30) call veri32()
        n2 = 2**m
        if (n2 .ne. n) then
            m = m-2
        endif
    endif
    isgn = 1
    if (ifft .lt. 0) isgn=-1
    pi= r8pi()*isgn
    nm1=n-1
    j = 1
    nv2=n/2
    do 8 i = 1, nm1
        if (i .ge. j) goto 5
        t=s(j)
        s(j)=s(i)
        s(i)=t
 5      continue
        k=nv2
 6      continue
        if (k .ge. j) goto 7
        j=j-k
        k=k/2
        goto 6
 7      continue
        j=j+k
 8  continue
    do 20 l = 1, m
!        if (l .gt. 30) call veri32()
        le=2**l
        le1=le/2
        u=(1.d0,0.d0)
        w=dcmplx(cos(-pi/dble(le1)),sin(-pi/dble(le1)))
        do 21 j = 1, le1
            do 10 i = j, n, le
                ip=i+le1
                t=s(ip)*u
                s(ip)=s(i)-t
                s(i)=s(i)+t
10          continue
            u=u*w
21      continue
20  continue
    if (ifft .lt. 0) then
      calpha=dcmplx(1.d0,0.d0)/(n2*1.d0)
      call zscal(n2,calpha,s,1)
    endif
end subroutine
