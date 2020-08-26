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
subroutine dbrInitAlgoPod(base, paraPod)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/infniv.h"
#include "asterfort/jedetr.h"
#include "asterfort/romFieldDSCopy.h"
#include "asterfort/romFieldPrepFilter.h"
#include "asterfort/utmess.h"
#include "asterfort/varinonu.h"
#include "asterfort/wkvect.h"
!
type(ROM_DS_Empi), intent(in) :: base
type(ROM_DS_ParaDBR_POD), intent(inout) :: paraPod
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Initializations for algorith - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : base
! IO  paraPod          : datastructure for parameters (POD)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=8) :: model, mesh
    character(len=24) :: compor
    character(len=24), parameter :: listVariNume = '&&LIST_VARInNUME'
    integer :: iCell, iCmp, nbCell, nbVari
    integer, pointer :: listCell(:) => null()
    character(len=8), pointer :: variNume(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_30')
    endif
!
! - Prepare reference to read (high fidelity)
!
    call romFieldDSCopy(base%mode, paraPod%field)
!
! - Convert names of components from VARI_R (NOM_VARI)
!
    if (paraPod%nbVariToFilter .ne. 0) then
        nbVari = paraPod%nbVariToFilter
        model  = paraPod%resultDom%modelRefe
        compor = paraPod%resultDom%comporRefe
        call dismoi('NOM_MAILLA', model, 'MODELE', repk = mesh)
        call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi = nbCell)
        AS_ALLOCATE(vi = listCell, size = nbCell)
        do iCell = 1, nbCell
            listCell(iCell) = iCell
        end do
        call wkvect(listVariNume, 'V V K8', nbCell*nbVari, vk8 = variNume)
        call varinonu(model , compor      ,&
                      nbCell, listCell    ,&
                      nbVari, paraPod%variToFilter, variNume)
        ASSERT(paraPod%nbCmpToFilter .eq. nbVari)
        do iCmp = 1, nbVari
            paraPod%cmpToFilter(iCmp) = variNume(iCmp)
        end do
        AS_DEALLOCATE(vi = listCell)
        call jedetr(listVariNume)
    endif
!
! - Prepare filter for components
!
    call romFieldPrepFilter(paraPod%nbCmpToFilter, paraPod%cmpToFilter ,&
                            paraPod%field)
!
end subroutine
