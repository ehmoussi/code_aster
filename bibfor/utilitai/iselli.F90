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

function iselli(elrefz)
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    aster_logical :: iselli
    character(len=*) :: elrefz
! person_in_charge: samuel.geniaut at edf.fr
! ----------------------------------------------------------------------
!
! FONCTION VALANT TRUE SI L'ELEMENT DE REFERENCE EST LINEAIRE
!        (AUTANT DE NOEUDS QUE DE NOEUDS SOMMET)
!
! ----------------------------------------------------------------------
!
! IN   ELREFE : ELEMENT DE REFERENCE (ELREFE)
! OUT  ISELLI : TRUE SI L'ELEMENT DE REFERENCE EST LINEAIRE
!
    character(len=3) :: elrefe
!
    elrefe = elrefz
!
    if (elrefe .eq. 'PO1' .or. elrefe .eq. 'SE2' .or. elrefe .eq. 'TR3' .or. elrefe .eq.&
        'QU4' .or. elrefe .eq. 'TE4' .or. elrefe .eq. 'PY5' .or. elrefe .eq. 'PE6' .or.&
        elrefe .eq. 'HE8') then
!
        iselli=.true.
!
        elseif (elrefe.eq.'SE3'.or. elrefe.eq.'TR6'.or. elrefe.eq.'TR7'&
    .or. elrefe.eq.'QU8'.or. elrefe.eq.'QU9'.or. elrefe.eq.'T10'.or.&
    elrefe.eq.'P13'.or. elrefe.eq.'P15'.or. elrefe.eq.'P18'.or.&
    elrefe.eq.'H20'.or. elrefe.eq.'H27') then
!
        iselli=.false.
!
    else
!
        ASSERT(.false.)
!
    endif
!
end function
