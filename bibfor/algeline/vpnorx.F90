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

subroutine vpnorx(nbmode, neq, exclus, vecp, resufk)
    implicit   none
#include "asterfort/vecink.h"
#include "blas/dscal.h"
    integer :: nbmode, neq, exclus(*)
    real(kind=8) :: vecp(neq, *)
    character(len=*) :: resufk(*)
!     NORMALISE A LA PLUS GRANDE DES VALEURS SUR UN DDL QUI N'EST PAS
!     EXCLUS
!     ------------------------------------------------------------------
!
    integer :: imode, ieq
    real(kind=8) :: normx, invx, absnx, rexc, arexc
    character(len=24) :: k24b
!
    k24b='SANS_CMP: LAGR'
    do 100 imode = 1, nbmode
        normx = vecp(1,imode)*exclus(1)
        absnx=abs(normx)
        do 110 ieq = 2, neq
            rexc=vecp(ieq,imode)*exclus(ieq)
            arexc=abs(rexc)
            if (absnx .lt. arexc) then
                normx = rexc
                absnx = arexc
            endif
110      continue
        if (normx .ne. 0.d0) then
            invx=1.d0/normx
            call dscal(neq, invx, vecp(1, imode), 1)
        endif
100  end do
    call vecink(nbmode, k24b, resufk)
!
end subroutine
