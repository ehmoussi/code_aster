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
subroutine modelCheckFSINormals(model)
!
use mesh_module, only: getCellProperties, getSkinCellSupport, checkNormalOnSkinCell
use model_module, only: getFSICell, getFluidCell
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/jexnum.h"
#include "asterfort/jenuno.h"
!
character(len=8), intent(in) :: model
!
! --------------------------------------------------------------------------------------------------
!
! AFFE_MODELE
!
! Check normals for FSI elements
!
! --------------------------------------------------------------------------------------------------
!
! In  model           : name of the model
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=8) :: mesh
    integer :: nbCell, modelDime
    integer :: nbCellFSI, nbCellFluid
    integer, pointer :: cellFSI(:) => null()
    integer, pointer :: cellFluid(:) => null()
    aster_logical :: lCell2d, lCell1d
    integer, pointer :: cellFSINbNode(:) => null()
    integer, pointer :: cellFSINodeIndx(:) => null()
    integer, pointer :: cellFSISupport(:) => null()
    aster_logical :: lMisoriented
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)

    call dismoi('NOM_MAILLA', model, 'MODELE', repk = mesh)
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi = nbCell)
    call dismoi('DIM_GEOM', model, 'MODELE', repi = modelDime)
!
! - Get list of cells with FSI model
!
    call getFSICell(model, nbCellFSI, cellFSI)

    if (nbCellFSI .gt. 0) then
        if (niv .ge. 2) then
            call utmess('I', 'MODELE1_80', si = nbCellFSI)
        endif
! ----- Get list of cells with fluid model
        call getFluidCell(model, nbCellFluid, cellFluid)
! ----- Get properties of FSI cells
        AS_ALLOCATE(vi=cellFSINbNode, size=nbCellFSI)
        AS_ALLOCATE(vi=cellFSINodeIndx, size=nbCellFSI)
        call getCellProperties(mesh         ,&
                               nbCellFSI    , cellFSI        ,&
                               cellFSINbNode, cellFSINodeIndx,&
                               lCell2d      , lCell1d)
        ASSERT(lCell1d.or.lCell2d)
        if (lCell1d) then
            ASSERT(.not.lCell2d)
            if (niv .ge. 2) then
                call utmess('I', 'MODELE1_81')
            endif
        endif
        if (lCell2d) then
            ASSERT(.not.lCell1d)
            if (niv .ge. 2) then
                call utmess('I', 'MODELE1_82')
            endif
        endif

! ----- Get "volumic" cells support of skin cells
        AS_ALLOCATE(vi=cellFSISupport, size=nbCellFSI)
        call getSkinCellSupport(mesh          ,&
                                nbCellFSI     , cellFSI,&
                                lCell2d       , lCell1d,&
                                cellFSISupport,&
                                nbCellFluid   , cellFluid)
! ----- Check normals
        call checkNormalOnSkinCell(mesh          , modelDime      ,&
                                   nbCellFSI     , cellFSI        ,&
                                   cellFSINbNode , cellFSINodeIndx,&
                                   cellFSISupport, lMisoriented)
        if (lMisoriented) then
            call utmess('A', 'FLUID1_4')
        endif
!
        AS_DEALLOCATE(vi=cellFSINbNode)
        AS_DEALLOCATE(vi=cellFSINodeIndx)
        AS_DEALLOCATE(vi=cellFSISupport)
    endif

!
    AS_DEALLOCATE(vi = cellFSI)
    AS_DEALLOCATE(vi = cellFluid)
!
end subroutine
