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

subroutine ddmpfn(zimat, nmnbn, nmddpl)
    implicit none
!
!     RECUPERE LES VALEURS DES DERIVEES SECONDES
!     DES MOMENTS LIMITES DE PLASTICITE
!     NMDDPL = df/dn(n)
!
! IN  ZIMAT : ADRESSE DE LA LISTE DE MATERIAU CODE
! IN  NMNBN : FORCE - BACKFORCE
!
! OUT NMDDPL : DERIVEES SECONDES DES MOMENTS LIMITES DE PLASTICITE
!
#include "asterfort/cdnfon.h"
#include "asterfort/utmess.h"
    integer :: i, ier0, ier1, ier2, zimat
!
    real(kind=8) :: nmnbn(6), nmddpl(2, 2)
!
    character(len=8) :: nomres(4), domres(4), ddmres(4)
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
    ddmres(1) = 'DDFMEX1'
    ddmres(2) = 'DDFMEX2'
    ddmres(3) = 'DDFMEY1'
    ddmres(4) = 'DDFMEY2'
!
    do 10, i=1,2
    call cdnfon(zimat, ddmres(2*(i-1)+1), nmnbn(i), 0, nmddpl(1, i),&
                ier0)
!
    if (ier0 .gt. 0) then
        call cdnfon(zimat, domres(2*(i-1)+1), nmnbn(i), 1, nmddpl(1, i),&
                    ier1)
!
        if (ier1 .gt. 0) then
            call cdnfon(zimat, nomres(2*(i-1)+1), nmnbn(i), 2, nmddpl(1, i),&
                        ier2)
!
            if (ier2 .eq. 3) then
                call utmess('F', 'ELEMENTS_24')
            endif
        endif
    endif
!
    call cdnfon(zimat, ddmres(2*i), nmnbn(i), 0, nmddpl(2, i),&
                ier0)
!
    if (ier0 .gt. 0) then
        call cdnfon(zimat, domres(2*i), nmnbn(i), 1, nmddpl(2, i),&
                    ier1)
!
        if (ier1 .gt. 0) then
            call cdnfon(zimat, nomres(2*i), nmnbn(i), 2, nmddpl(2, i),&
                        ier2)
!
            if (ier2 .eq. 3) then
                call utmess('F', 'ELEMENTS_24')
            endif
        endif
    endif
    10 end do
!
end subroutine
