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
!
module model_module
! ==================================================================================================
implicit none
! ==================================================================================================
public  :: getFSICell, getFluidCell
! ==================================================================================================
private
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexatr.h"
#include "asterfort/lteatt.h"
#include "asterfort/teattr.h"
! ==================================================================================================
contains
! --------------------------------------------------------------------------------------------------
!
! getFSICell
!
! Get list of cells with FSI model
!
! In  model            : name of model
! Out nbCellFSI        : number of FSI cells
! OUT cellFSI          : for each cell in mesh a flag for FSI cell
!
! --------------------------------------------------------------------------------------------------
subroutine getFSICell(modelz, nbCellFSI, cellFSI)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=*), intent(in) :: modelz
    integer, intent(out) :: nbCellFSI
    integer, pointer :: cellFSI(:)
! - Local
    integer :: iCell, nbCell, iCellFSI
    integer :: cellTypeNume, iret
    integer, pointer :: modelCells(:) => null()
    character(len=8) :: mesh, model
    character(len=16) :: cellTypeName
    aster_logical, pointer :: isCellFSI(:) => null()

!   ------------------------------------------------------------------------------------------------
    nbCellFSI = 0
    model     = modelZ
!
! - Access to model and mesh
!
    call dismoi('NOM_MAILLA', model, 'MODELE', repk = mesh)
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi = nbCell)
    call jeexin(model//'.MAILLE', iret)
    if (iret .eq. 0) then
! ----- No cells (sub-structuring)
        goto 99
    endif
    call jeveuo(model//'.MAILLE', 'L', vi=modelCells)
!
    AS_ALLOCATE(vl = isCellFSI, size = nbCell)
    do iCell = 1, nbCell
        cellTypeNume = modelCells(iCell)
        if (cellTypeNume .ne. 0) then
            call jenuno(jexnum('&CATA.TE.NOMTE', cellTypeNume), cellTypeName)
            if (lteatt('FSI', 'OUI', typel=cellTypeName)) then
                nbCellFSI = nbCellFSI + 1
                isCellFSI(iCell) = ASTER_TRUE
            endif
        endif
    end do
!
! - Create list of FSI elements
!
    if (nbCellFSI .ne. 0) then
        iCellFSI = 0
        AS_ALLOCATE(vi = cellFSI, size = nbCellFSI)
        do iCell = 1, nbCell
            if (isCellFSI(iCell)) then
                iCellFSI = iCellFSI + 1
                cellFSI(iCellFSI) = iCell
            endif
        end do
        ASSERT(iCellFSI .eq. nbCellFSI)
    endif
    AS_DEALLOCATE(vl = isCellFSI)
!
99  continue
!
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getFluidCell
!
! Get list of cells with fluid model
!
! In  model            : name of model
! Out nbCellFluid      : number of fluid cells
! OUT cellFluid        : for each cell in mesh a flag for fluid cells
!
! --------------------------------------------------------------------------------------------------
subroutine getFluidCell(modelz, nbCellFluid, cellFluid)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=*), intent(in) :: modelz
    integer, intent(out) :: nbCellFluid
    integer, pointer :: cellFluid(:)
! - Local
    integer :: iCell, nbCell, iCellFluid
    integer :: cellTypeNume
    integer, pointer :: modelCells(:) => null()
    character(len=8) :: mesh, model
    character(len=16) :: cellTypeName
    aster_logical, pointer :: isCellFluid(:) => null()

!   ------------------------------------------------------------------------------------------------
    nbCellFluid = 0
    model       = modelZ
!
! - Access to model and mesh
!
    call dismoi('NOM_MAILLA', model, 'MODELE', repk = mesh)
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi = nbCell)
    call jeveuo(model//'.MAILLE', 'L', vi=modelCells)
!
    AS_ALLOCATE(vl = isCellFluid, size = nbCell)
    do iCell = 1, nbCell
        cellTypeNume = modelCells(iCell)
        if (cellTypeNume .ne. 0) then
            call jenuno(jexnum('&CATA.TE.NOMTE', cellTypeNume), cellTypeName)
            if (lteatt('FLUIDE', 'OUI', typel=cellTypeName)) then
                nbCellFluid = nbCellFluid + 1
                isCellFluid(iCell) = ASTER_TRUE
            endif
        endif
    end do
!
! - Create list of fluid elements
!
    iCellFluid = 0
    AS_ALLOCATE(vi = cellFluid, size = nbCellFluid)
    do iCell = 1, nbCell
        if (isCellFluid(iCell)) then
            iCellFluid = iCellFluid + 1
            cellFluid(iCellFluid) = iCell
        endif
    end do
    ASSERT(iCellFluid .eq. nbCellFluid)
    AS_DEALLOCATE(vl = isCellFluid)
!
!   ------------------------------------------------------------------------------------------------
end subroutine
!
end module model_module
