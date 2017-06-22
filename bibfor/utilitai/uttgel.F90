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

subroutine uttgel(nomte, typgeo)
! person_in_charge: jacques.pellet at edf.fr
!  UTILITAIRE - TYPE GEOMETRIQUE D'UN ELEMENT FINI
!  **           *    *                **
! =====================================================================
! IN  NOMTE  : NOM DU TYPE D'ELEMENT FINI
! OUT TYPGEO : TYPE GEOMETRIQUE CORRESPONDANT
!              EN 2D : 'TR', 'QU'
!              EN 3D : 'HE', 'TE', 'PE', 'PY'
! ----------------------------------------------------------------------
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "asterfort/codent.h"
#include "asterfort/utmess.h"
#include "asterfort/teattr.h"
#include "asterfort/assert.h"
    character(len=2) :: typgeo
    character(len=16) :: nomte
!
! 0.2. ==> VARIABLES LOCALES
!
    integer :: ibid
    character(len=8) :: alias8
    character(len=3) :: codtma


    call teattr('S', 'ALIAS8', alias8, ibid, typel=nomte)
    codtma=alias8(6:8)

    if (codtma(1:2).eq.'TR') then
        typgeo='TR'
    elseif (codtma(1:2).eq.'QU') then
        typgeo='QU'
    elseif (codtma.eq.'HE8' .or. codtma.eq.'H20' .or. codtma.eq.'H27') then
        typgeo='HE'
    elseif (codtma.eq.'PE6' .or. codtma.eq.'P15' .or. codtma.eq.'P18' .or. &
            codtma == 'SH6' .or. codtma == 'S15' ) then
        typgeo='PE'
    elseif (codtma.eq.'TE4' .or. codtma.eq.'T10') then
        typgeo='TE'
    elseif (codtma.eq.'PY5' .or. codtma.eq.'P13') then
        typgeo='PY'
    else
        ASSERT(.false.)
    endif
!
end subroutine
