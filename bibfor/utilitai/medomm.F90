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

subroutine medomm(model, mate, cara_elem)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/rcmfmc.h"
#include "asterfort/utmess.h"
!
!
    character(len=*), intent(out) :: model
    character(len=*), intent(out) :: mate
    character(len=*), intent(out) :: cara_elem
!
! --------------------------------------------------------------------------------------------------
!
! Mechanics - Initializations
!
! Get parameters from command file
!
! --------------------------------------------------------------------------------------------------
!
! Out model            : name of model
! Out mate             : name of material characteristics (field)
! Out cara_elem        : name of elementary characteristics (field)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nocc
    character(len=8) :: concept, answer
    aster_logical :: l_thm
!
! --------------------------------------------------------------------------------------------------
!
    model     = ' '
    mate      = ' '
    cara_elem = ' '
!
! - Get model
!
    concept = ' '
    call getvid(' ', 'MODELE', scal=concept, nbret=nocc)
    ASSERT(nocc .ne. 0)
    model = concept
    call dismoi('EXI_THM', model, 'MODELE', repk=answer)
    l_thm = answer .eq. 'OUI'
!
! - Get material characteristics field
!
    concept = ' '
    call getvid(' ', 'CHAM_MATER', scal=concept, nbret=nocc)
    call dismoi('BESOIN_MATER', model, 'MODELE', repk=answer)
    if ((nocc.eq.0) .and. (answer .eq. 'OUI')) then
        call utmess('A', 'MECHANICS1_40')
    endif
    if (nocc .ne. 0) then
        call rcmfmc(concept, mate, l_thm_ = l_thm)
    else
        mate = ' '
    endif
!
! - Get elementary characteristics
!
    concept = ' '
    call getvid(' ', 'CARA_ELEM', scal=concept, nbret=nocc)
    call dismoi('EXI_RDM', model, 'MODELE', repk=answer)
    if ((nocc.eq.0) .and. (answer .eq. 'OUI')) then
        call utmess('A', 'MECHANICS1_39')
    endif
    cara_elem = concept
!
end subroutine
