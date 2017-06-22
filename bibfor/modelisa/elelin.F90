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

subroutine elelin(nconta, elref1, elref2, nnop, nnops)
    implicit none
!
#include "asterfort/elraca.h"
    character(len=8) :: elref1, elref2
    integer :: nnop, nnops, nconta
!
!                      RETOURNE LE TYPE DE L'ELEMENT "LINEARISE"
!                      ET LE NOMBRE DE NOEUDS DE CHAQUE ELEMENT
!
!     ENTREE
!       NCONTA  : TYPE DE CONTACT
!       ELREF1  : TYPE DE L'ELEMENT PARENT
!
!     SORTIE
!       ELREF2  : TYPE DE L'ELEMENT LINEAIRE A L'ELEMENT PARENT
!       NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
!       NNOPS   : NOMBRE DE NOEUDS DE L'ELEMENT LINEAIRE
!......................................................................
!
    integer :: ndim, nbfpg, nbpg(20)
    real(kind=8) :: x(3*27), vol
    character(len=8) :: fapg(20)
!
!
    if (nconta .ge. 2) then
        if (elref1 .eq. 'QU8') then
            elref2='QU4'
            nnop = 8
            nnops= 4
        else if (elref1.eq.'TR6') then
            elref2='TR3'
            nnop = 6
            nnops= 3
        else if (elref1.eq.'SE3') then
            elref2='SE2'
            nnop = 3
            nnops= 2
        else if (elref1.eq.'H20') then
            elref2='HE8'
            nnop = 20
            nnops= 8
        else if (elref1.eq.'P15') then
            elref2='PE6'
            nnop = 15
            nnops= 6
        else if (elref1.eq.'S15') then
            elref2='SH6'
            nnop = 15
            nnops= 6
        else if (elref1.eq.'P13') then
            elref2='PY5'
            nnop = 13
            nnops= 5
        else if (elref1.eq.'T10') then
            elref2='TE4'
            nnop = 10
            nnops= 4
        else
            elref2=elref1
            call elraca(elref1, ndim, nnop, nnops, nbfpg,&
                        fapg, nbpg, x, vol)
        endif
    else
        elref2=elref1
        call elraca(elref1, ndim, nnop, nnops, nbfpg,&
                    fapg, nbpg, x, vol)
    endif
!
end subroutine
