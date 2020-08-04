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
subroutine nueqch(error, chamno, nume_node, cmp_name, nueq)
!
implicit none
!
#include "asterc/ismaem.h"
#include "asterfort/select_dof.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
character(len=19), intent(in) :: chamno
character(len=1), intent(in) :: error
integer, intent(in) :: nume_node
character(len=8), intent(in) :: cmp_name
integer, intent(inout) :: nueq
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE)
!
! PERMET DE RECUPERER LES NUMEROS DES EQUATIONS
!
! ----------------------------------------------------------------------
!
!
! IN  CHAMNO  : CHAM_NO A MODIFIER
! IN  ERREUR  : 'F' SI UNE COMPOSANTE ABSENTE -> ERREUR
!               'A' SI UNE COMPOSANTE ABSENTE -> ALARME
!               ' ' SI UNE COMPOSANTE ABSENTE -> RIEN
!
! --------------------------------------------------------------------------------------------------
!
    integer, pointer :: tablCmp(:) => null()
    integer, pointer :: listNodeToSelect(:) => null()
    character(len=8), pointer :: listCmpToSelect(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    AS_ALLOCATE(vi = tablCmp, size = 1)
    AS_ALLOCATE(vi = listNodeToSelect, size = 1)
    AS_ALLOCATE(vk8 = listCmpToSelect, size = 1)
!
    listNodeToSelect(1) = nume_node
    listCmpToSelect(1)  = cmp_name
!
! - Find component in list of equations
!
    call select_dof(tablCmp_    = tablCmp, &
                    fieldNodeZ_ = chamno,&
                    nbNodeToSelect_ = 1, listNodeToSelect_ = listNodeToSelect,&
                    nbCmpToSelect_  = 1, listCmpToSelect_  = listCmpToSelect)
!
! - Check
!
    if (tablCmp(1).eq.0) then
        if (error .ne. ' ') then
            call utmess(error, 'MECANONLINE5_50', sk = cmp_name)
        endif
    endif
!
! - Copy
!
    nueq = tablCmp(1)
!
    AS_DEALLOCATE(vi = tablCmp)
    AS_DEALLOCATE(vi = listNodeToSelect)
    AS_DEALLOCATE(vk8 = listCmpToSelect)
!
end subroutine
