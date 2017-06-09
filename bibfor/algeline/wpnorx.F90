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

subroutine wpnorx(nbmode, neq, exclus, vecp, resufk)
    implicit   none
#include "asterc/r8miem.h"
    integer :: nbmode, neq, exclus(*)
    complex(kind=8) :: vecp(neq, nbmode)
    character(len=*) :: resufk(*)
!     NORMALISE A LA PLUS GRANDE DES VALEURS SUR UN DDL QUI N'EST PAS
!     EXCLUS
!     ------------------------------------------------------------------
! IN  NBMODE : I : NOMBRE  DE  MODE
! IN  NEQ    : I : TAILLE  DES MODES
! VAR VECP   : C : MATRICE DES MODES
! IN  EXCLUS : I : TABLE   DES DDL EXCLUS (0 <=> EXCLUS)
!     ------------------------------------------------------------------
    integer :: imode, ieq
    complex(kind=8) :: normx, zero
    real(kind=8) :: prec
!     ------------------------------------------------------------------
!
    prec=r8miem()*10.d0
    zero = dcmplx(0.0d0,0.0d0)
    do 100 imode = 1, nbmode
        normx = zero
        do 110 ieq = 1, neq
            if (abs(vecp(ieq,imode)*exclus(ieq)) .gt. abs(normx)) then
                normx = vecp(ieq,imode)
            endif
110      continue
        if (abs(normx) .gt. prec) then
            normx = 1.d0 / normx
            do 120 ieq = 1, neq
                vecp(ieq,imode) = vecp(ieq,imode) * normx
120          continue
        endif
        resufk(imode) = 'SANS_CMP: LAGR'
100  end do
!
end subroutine
