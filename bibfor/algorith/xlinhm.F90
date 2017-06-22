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

subroutine xlinhm(elrefp, elref2)
!
    implicit none
!
#   include "asterfort/elref1.h"
    character(len=8) :: elrefp, elref2
!
! person_in_charge: samuel.geniaut at edf.fr
!
!          BUT : RECUPERER L'ELEMENT LINEAIRE ASSOCIE A L'ELEMENT
!                QUADRATIQUE HM-XFEM
!
!
! OUT  ELREFP  : NOM DE L'ELEMENT QUADRATIQUE PARENT
! OUT  ELREF2  : NOM DE L'ELEMENT LINEAIRE
!     ------------------------------------------------------------------
!
!     ON RECUPERE L'ELEMENT PARENT PRINCIPAL
    call elref1(elrefp)
!
    if (elrefp .eq. 'SE3') then
        elref2='SE2'
    else if (elrefp .eq. 'QU8') then
        elref2='QU4'
    else if (elrefp.eq.'TR6') then
        elref2='TR3'
    else if (elrefp.eq.'H20') then
        elref2='HE8'
    else if (elrefp.eq.'P15') then
        elref2='PE6'
    else if (elrefp.eq.'P13') then
        elref2='PY5'
    else if (elrefp.eq.'T10') then
        elref2='TE4'
    endif
end subroutine
