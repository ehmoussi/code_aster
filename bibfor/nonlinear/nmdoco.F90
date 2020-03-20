! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmdoco(model, caraElem, compor)
!
implicit none
!
#include "asterfort/cesvar.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
!
character(len=*), intent(in) :: model, caraElem, compor
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE
!
! EXTENSION DE LA CARTE COMPORTEMENT
!   TRANSFO. EN CHAM_ELEM_S
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : NOM DU MODELE
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! I/O COMPOR : CARTE COMPORTEMENT ETENDUE EN CHAM_ELEM_S
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=24) :: ligrmo
!
! --------------------------------------------------------------------------------------------------
!
    call dismoi('NOM_LIGREL', model, 'MODELE', repk=ligrmo)
    call exisd('CHAM_ELEM_S', compor, iret)
    if (iret .eq. 0) then
        call cesvar(caraElem, compor, ligrmo, compor)
    endif
!
end subroutine
