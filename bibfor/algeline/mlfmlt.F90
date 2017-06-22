! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine mlfmlt(b, f, y, ldb, n,&
                  p, l, opta, optb, nb)
!
!     B = B - F*Y PAR BLOCS
    implicit none
#include "blas/dgemm.h"
    integer :: ldb, n, p, l, nb
    real(kind=8) :: b(ldb, l), f(n, p), y(ldb, l)
    integer :: m, npb, restp, nlb, restl
    integer :: i, j, ib, jb
    real(kind=8) :: beta, alpha
    integer :: opta, optb
    character(len=1) :: tra, trb
!
    tra='T'
    if (opta .eq. 1) tra='N'
    trb='T'
    if (optb .eq. 1) trb='N'
    alpha = -1.d0
    beta = 1.d0
    m= n - p
    npb=p/nb
    nlb=l/nb
    restp = p - (nb*npb)
    restl= l - (nb*nlb)
    if (nlb .gt. 0) then
        do 500 j = 1, nlb
            jb= nb*(j-1)+1
            do 600 i = 1, npb
                ib= nb*(i-1)+1
                call dgemm(tra, trb, nb, nb, m,&
                           alpha, f(1, ib), n, y(1, jb), ldb,&
                           beta, b(ib, jb), ldb)
600          continue
            if (restp .gt. 0) then
                ib=nb*npb+1
                call dgemm(tra, trb, restp, nb, m,&
                           alpha, f(1, ib), n, y(1, jb), ldb,&
                           beta, b(ib, jb), ldb)
            endif
500      continue
    endif
    if (restl .gt. 0) then
        jb=nb*nlb+1
        do 601 i = 1, npb
            ib= nb*(i-1)+1
            call dgemm(tra, trb, nb, restl, m,&
                       alpha, f(1, ib), n, y(1, jb), ldb,&
                       beta, b(ib, jb), ldb)
601      continue
        if (restp .gt. 0) then
            ib=nb*npb+1
            call dgemm(tra, trb, restp, restl, m,&
                       alpha, f(1, ib), n, y(1, jb), ldb,&
                       beta, b(ib, jb), ldb)
        endif
    endif
end subroutine
