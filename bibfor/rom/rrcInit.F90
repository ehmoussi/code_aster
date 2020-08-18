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
subroutine rrcInit(cmdPara)
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
#include "asterfort/romFieldBuildInit.h"
#include "asterfort/romTableRead.h"
#include "asterfort/rrcInfo.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsGetAllFieldType.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaRRC), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Initializations
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(ROM_DS_Result) :: resultDom, resultRom
    character(len=8) :: mesh, modelRom
    integer :: nbNodeMesh, nbFieldBuild, nbFieldResult
    integer :: iFieldBuild
    character(len=16), pointer :: resultField(:) => null()
    integer, pointer :: resultFieldNume(:) => null()
    integer, pointer :: listNode(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM16_2')
    endif
!
! - Get parameters
!
    resultRom    = cmdPara%resultRom
    resultDom    = cmdPara%resultDom
    modelRom     = cmdPara%modelRom
    mesh         = cmdPara%mesh
    nbFieldBuild = cmdPara%nbFieldBuild
!
! - Get reduced coordinates
!
    call romTableRead(cmdPara%tablReduCoor)
!
! - Create output result datastructure
!
    call rscrsd('G', resultDom%resultName, resultDom%resultType, resultDom%nbStore)
!
! - Get list of type of fields in a results datastructure (at least for ONE storing index)
!
    call rsGetAllFieldType(cmdPara%resultRom%resultName,&
                           nbFieldResult, resultField, resultFieldNume)
!
! - Prepare vector of list of nodes for selection
!
    call dismoi('NB_NO_MAILLA', mesh, 'MAILLAGE', repi = nbNodeMesh)
    AS_ALLOCATE(vi = listNode, size = nbNodeMesh) 
!
! - Initializations of build fields
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM16_4', si = nbFieldBuild)
    endif
    do iFieldBuild = 1, nbFieldBuild
        call romFieldBuildInit(mesh         , nbNodeMesh , listNode       ,&
                               nbFieldResult, resultField, resultFieldNume,&
                               resultRom    , modelRom   , cmdPara%tablReduCoor   ,&
                               cmdPara%fieldBuild(iFieldBuild))
    end do
!
! - Clean
!
    AS_DEALLOCATE(vi = listNode)
    AS_DEALLOCATE(vk16 = resultField)
    AS_DEALLOCATE(vi = resultFieldNume)
!
! - Print parameters (debug)
!
    if (niv .ge. 2) then
        call rrcInfo(cmdPara)
    endif
!
end subroutine
