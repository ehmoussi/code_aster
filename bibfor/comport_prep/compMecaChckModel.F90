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
subroutine compMecaChckModel(iComp       ,&
                             model       , fullElemField ,&
                             lAllCellAffe, cellAffe      , nbCellAffe   ,&
                             relaCompPY  , lElasByDefault, lNeedDeborst)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/lctest.h"
#include "asterfort/cesexi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/teattr.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: iComp
character(len=8), intent(in) :: model
character(len=19), intent(in) :: fullElemField
aster_logical, intent(in) :: lAllCellAffe
character(len=24), intent(in) :: cellAffe
integer, intent(in) :: nbCellAffe
character(len=16), intent(in) :: relaCompPY
aster_logical, intent(out) :: lElasByDefault, lNeedDeborst
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Checking the consistency of the modelization with the behavior
!
! --------------------------------------------------------------------------------------------------
!
! In  iComp            : occurrence number
! In  model            : name of model
! In  fullElemField    : field for FULL_MECA option
! In  lAllCellAffe     : ASTER_TRUE if affect on all cells where behaviour is defined
! In  nbCellAffe       : number of cells where behaviour is defined
! In  cellAffe         : list of cells where behaviour is defined
! In  relaCompPY       : comportement RELATION - Python coding
! Out lElasByDefault   : flag if at least one element use ELAS by default
! Out lNeedDeborst     : flag if at least one element swap to Deborst algorithm
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: elemTypeName, modelType
    integer :: elemTypeNume, cellNume, nbCmpAffected
    integer :: jvCesd, jvCesl, jvVale
    integer :: modelTypeIret, lctestIret, iCell
    integer :: nbCellMesh, nbCell
    character(len=16), pointer :: cesv(:) => null()
    integer, pointer :: cellAffectedByModel(:) => null()
    integer, pointer :: listCellAffe(:) => null()
    aster_logical :: lAtOneCellAffect, lAllCellAreBound
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    lElasByDefault   = ASTER_FALSE
    lNeedDeborst     = ASTER_FALSE
    lAtOneCellAffect = ASTER_FALSE
    lAllCellAreBound = ASTER_FALSE
!
! - Access to model
!
    call jeveuo(model//'.MAILLE', 'L', vi = cellAffectedByModel)
!
! - Access to <CHELEM_S> of FULL_MECA option
!
    call jeveuo(fullElemField//'.CESD', 'L', jvCesd)
    call jeveuo(fullElemField//'.CESL', 'L', jvCesl)
    call jeveuo(fullElemField//'.CESV', 'L', vk16 = cesv)
    nbCellMesh = zi(jvCesd-1+1)
!
! - Mesh affectation
!
    if (lAllCellAffe) then
        nbCell = nbCellMesh
    else
        call jeveuo(cellAffe, 'L', vi = listCellAffe)
        nbCell = nbCellAffe
    endif
!
! - Loop on elements
!
    nbCmpAffected = 0
    do iCell = 1, nbCell
! ----- Current cell
        if (lAllCellAffe) then
            cellNume = iCell
        else
            cellNume = listCellAffe(iCell)
        endif

! ----- Number of components affected
        nbCmpAffected = max(nbCmpAffected, zi(jvCesd-1+5+4*(cellNume-1)+3))

! ----- Get adress in field for FULL_MECA option
        call cesexi('C', jvCesd, jvCesl, cellNume, 1, 1, 1, jvVale)

        if (jvVale .gt. 0) then
            lAtOneCellAffect = ASTER_TRUE

! --------- Behaviour on this cell is elastic (default)
            if (cesv(jvVale) .eq. ' ') then
                lElasByDefault = ASTER_TRUE
            endif

! --------- Access to type of finite element
            elemTypeNume = cellAffectedByModel(cellNume)
            call jenuno(jexnum('&CATA.TE.NOMTE', elemTypeNume), elemTypeName)

! --------- Type of modelization
            call teattr('C', 'TYPMOD' , modelType , modelTypeIret, typel = elemTypeName)
            if (modelTypeIret .eq. 0) then
                if (modelType  .eq. 'C_PLAN') then
                    call lctest(relaCompPY, 'MODELISATION', 'C_PLAN', lctestIret)
! ----------------- C_PLAN is not allowed for this behaviour => activation of Deborst algorithm
                    if (lctestIret .eq. 0) then
                        lNeedDeborst = ASTER_TRUE
                    endif

                else if (modelType .eq. '1D') then
                    call lctest(relaCompPY, 'MODELISATION', '1D', lctestIret)
! ----------------- 1D is not allowed for this behaviour => activation of (double) Deborst algorithm
                    if (lctestIret .eq. 0) then
                        lNeedDeborst = ASTER_TRUE
                    endif

                else if (modelType .eq.'3D') then
                    call lctest(relaCompPY, 'MODELISATION', '3D', lctestIret)

                else
                    call lctest(relaCompPY, 'MODELISATION', modelType, lctestIret)

                endif
            endif
        endif
    end do
!
! - All elements are boundary elements
!
    lAllCellAreBound = nbCmpAffected .eq. 0
!
! - Error when nothing is affected by the behavior
!
    if (.not. lAtOneCellAffect) then
        if (lAllCellAreBound) then
            call utmess('F', 'COMPOR1_60', si = iComp)
        else
            call utmess('F', 'COMPOR1_59', si = iComp)
        endif
    endif
!
    call jedema()
!
end subroutine
