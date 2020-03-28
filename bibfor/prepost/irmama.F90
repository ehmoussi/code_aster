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
subroutine irmama(meshNameZ , meshNbCell  ,&
                  nbCell    , cellName    ,&
                  nbGrCell  , grCellName  ,&
                  cellSelect, nbCellSelect,&
                  cellFlag)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
!
character(len=*), intent(in) :: meshNameZ
integer, intent(in) :: meshNbCell
integer, intent(in) :: nbCell
character(len=8), pointer :: cellName(:)
integer, intent(in) :: nbGrCell
character(len=24), pointer :: grCellName(:)
integer, pointer :: cellSelect(:)
integer, intent(out) :: nbCellSelect
integer, pointer :: cellFlag(:)
!
! --------------------------------------------------------------------------------------------------
!
! Print results
!
! Select cells from user
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: meshName
    integer :: iCell, cellNume, iGrCell, iret, grCellNbCell
    integer, pointer :: listCell(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    meshName     = meshNameZ
    nbCellSelect = 0
!
! - Select cells by name
!
    if (nbCell .ne. 0) then
        do iCell = 1, nbCell
            call jenonu(jexnom(meshName//'.NOMMAI', cellName(iCell)), cellNume)
            if (cellNume .eq. 0) then
                call utmess('A', 'RESULT3_9', sk=cellName(iCell))
                cellName(iCell) = ' '
            else
                if (cellFlag(cellNume) .eq. 0) then
                    nbCellSelect = nbCellSelect + 1
                    ASSERT(nbCellSelect .le. nbCell)
                    cellSelect(nbCellSelect) = cellNume
                    cellFlag(cellNume) = 1
                endif
            endif
        end do
    endif
!
! - Select cells in groups of cells
!
    if (nbGrCell .ne. 0) then
        do iGrCell = 1, nbGrCell
            call jeexin(jexnom(meshName//'.GROUPEMA', grCellName(iGrCell)), iret)
            if (iret .eq. 0) then
                call utmess('A', 'RESULT3_10', sk=grCellName(iGrCell))
                grCellName(iGrCell) = ' '
            else
                call jelira(jexnom(meshName//'.GROUPEMA', grCellName(iGrCell)),&
                            'LONMAX', grCellNbCell)
                if (grCellNbCell .eq. 0) then
                    call utmess('A', 'RESULT3_11', sk = grCellName(iGrCell))
                    grCellName(iGrCell) = ' '
                else
                    call jeveuo(jexnom(meshName//'.GROUPEMA', grCellName(iGrCell)),&
                                'L', vi = listCell)
                    do iCell = 1, grCellNbCell
                        cellNume = listCell(iCell)
                        if (cellFlag(cellNume) .eq. 0) then
                            nbCellSelect = nbCellSelect+1
                            ASSERT(nbCellSelect .le. meshNbCell)
                            cellSelect(nbCellSelect) = cellNume
                            cellFlag(cellNume) = 1
                        endif
                    end do
                endif
            endif
        end do
    endif
!
    call jedema()
end subroutine
