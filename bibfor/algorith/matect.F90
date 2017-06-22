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

subroutine matect(materd, materf, nmat, macst)
    implicit none
!     ROUTINE GENERIQUE DE RECUPERATION DU MATERIAU A T ET T+DT
!     ----------------------------------------------------------------
!     IN  MATERD  :  COEFFICIENTS MATERIAU A T-
!     IN  MATERF  :  COEFFICIENTS MATERIAU A T+
!         NMAT   :  DIMENSION  DE MATER
!     OUT MATCST :  'OUI' SI  MATERIAU A T = MATERIAU A T+DT
!                   'NON' SINON
!     ----------------------------------------------------------------
#include "asterc/r8prem.h"
    integer :: nmat, i
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2), epsi
    character(len=3) :: macst
!     ----------------------------------------------------------------
    epsi=r8prem()
!
! -   MATERIAU CONSTANT ?
    macst = 'OUI'
    do 30 i = 1, nmat
        if (abs(materd(i,1)-materf(i,1)) .gt. epsi*materd(i,1)) then
            macst = 'NON'
            goto 9999
        endif
30  end do
    do 40 i = 1, nmat
        if (abs(materd(i,2)-materf(i,2)) .gt. epsi*materd(i,2)) then
            macst = 'NON'
            goto 9999
        endif
40  end do
9999  continue
end subroutine
