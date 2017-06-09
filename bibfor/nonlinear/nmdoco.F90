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

subroutine nmdoco(modele, carele, compor)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/cesvar.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    character(len=24) :: modele, carele
    character(len=24) :: compor
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (INITIALISATION)
!
! EXTENSION DE LA CARTE COMPORTEMENT
!   TRANSFO. EN CHAM_ELEM_S
!
! ----------------------------------------------------------------------
!
!
! IN  MODELE : NOM DU MODELE
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! I/O COMPOR : CARTE COMPORTEMENT ETENDUE EN CHAM_ELEM_S
!
!
!
!
    integer :: iret
    character(len=24) :: ligrmo
    integer :: ifm, niv
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- INITIALISATIONS
!
    call dismoi('NOM_LIGREL', modele, 'MODELE', repk=ligrmo)
!
! --- EXTENSION DU COMPORTEMENT : NOMBRE DE VARIABLES INTERNES
!
    call exisd('CHAM_ELEM_S', compor, iret)
    if (iret .eq. 0) then
        call cesvar(carele, compor, ligrmo, compor)
    endif
!
    call jedema()
end subroutine
