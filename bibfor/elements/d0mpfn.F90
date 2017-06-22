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

subroutine d0mpfn(zimat, nmnbn, nmdpla)
    implicit none
!
!     RECUPERE LES VALEURS DES DERIVEES DES MOMENTS LIMITES DE PLAST
!
! IN  ZIMAT : ADRESSE DE LA LISTE DE MATERIAU CODE
! IN  NMNBN : FORCE - BACKFORCE
!
! OUT NMDPLA : DERIVEES DES MOMENTS LIMITES DE PLASTICITE
!
#include "asterfort/cdnfon.h"
    integer :: i, ier0, ier1, zimat
!
    real(kind=8) :: nmnbn(6)
    real(kind=8) :: nmdpla(2, 2)
!
    character(len=8) :: nomres(4), domres(4)
!
    nomres(1) = 'FMEX1'
    nomres(2) = 'FMEX2'
    nomres(3) = 'FMEY1'
    nomres(4) = 'FMEY2'
!
    domres(1) = 'DFMEX1'
    domres(2) = 'DFMEX2'
    domres(3) = 'DFMEY1'
    domres(4) = 'DFMEY2'
!
    do 10, i=1,2
    call cdnfon(zimat, domres(2*(i-1)+1), nmnbn(i), 0, nmdpla(1, i),&
                ier0)
!
    if (ier0 .gt. 0) then
        call cdnfon(zimat, nomres(2*(i-1)+1), nmnbn(i), 1, nmdpla(1, i),&
                    ier1)
    endif
!
    call cdnfon(zimat, domres(2*i), nmnbn(i), 0, nmdpla(2, i),&
                ier0)
!
    if (ier0 .gt. 0) then
        call cdnfon(zimat, nomres(2*i), nmnbn(i), 1, nmdpla(2, i),&
                    ier1)
    endif
    10 end do
!
end subroutine
