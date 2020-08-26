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
subroutine dbrReadPod(operation, paraPod)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/romResultGetInfo.h"
#include "asterfort/romSnapRead.h"
#include "asterfort/romTableParaRead.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(in) :: operation
type(ROM_DS_ParaDBR_POD), intent(inout) :: paraPod
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Read parameters - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  operation        : type of POD method
! IO  paraPod          : datastructure for parameters (POD)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nocc
    real(kind=8) :: toleSVD, toleIncr
    character(len=16) :: fieldName
    character(len=8)  :: lineicAxis, lineicSect, baseType
    character(len=8)  :: resultDomName
    integer :: nbModeMaxi, nbCmpToFilter, nbVariToFilter
    type(ROM_DS_Result) :: resultDom
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_1')
    endif
!
! - Initializations
!
    toleSVD        = 0.d0
    toleIncr       = 0.d0
    nbModeMaxi     = 0
    fieldName      = ' '
    lineicAxis     = ' '
    lineicSect     = ' '
    baseType       = ' '
    resultDomName  = ' '
    nbCmpToFilter  = 0
    nbVariToFilter = 0
!
! - Get parameters - Result
!
    call getvid(' ', 'RESULTAT', scal = resultDomName)
!
! - Get parameters - Field
!
    call getvtx(' ', 'NOM_CHAM', scal = fieldName, nbret = nocc)
    ASSERT(nocc .eq. 1)
    call getvtx(' ', 'NOM_CMP', iocc = 1, nbval=0, nbret = nbCmpToFilter)
    if (nbCmpToFilter .ne. 0) then
        nbCmpToFilter = abs(nbCmpToFilter)
        AS_ALLOCATE(vk8 = paraPod%cmpToFilter, size = nbCmpToFilter)
        call getvtx(' ', 'NOM_CMP', iocc = 1, nbval = nbCmpToFilter, vect = paraPod%cmpToFilter)
    endif
    call getvtx(' ', 'NOM_VARI', iocc = 1, nbval=0, nbret = nbVariToFilter)
    if (nbVariToFilter .ne. 0) then
        ASSERT(nbCmpToFilter .eq. 0)
        nbVariToFilter = abs(nbVariToFilter)
        AS_ALLOCATE(vk16 = paraPod%variToFilter, size = nbVariToFilter)
        call getvtx(' ', 'NOM_VARI', iocc = 1, nbval = nbVariToFilter, vect = paraPod%variToFilter)
        nbCmpToFilter = nbVariToFilter
        AS_ALLOCATE(vk8 = paraPod%cmpToFilter, size = nbCmpToFilter)
    endif
!
! - Maximum number of modes
!
    call getvis(' ', 'NB_MODE' , scal = nbModeMaxi, nbret = nocc)
    if (nocc .eq. 0) then
        nbModeMaxi = 0
    endif
!
! - Get parameters - Base type to numbering
!
    call getvtx(' ', 'TYPE_BASE', scal = baseType)
    if (baseType .eq. 'LINEIQUE') then
        call getvtx(' ', 'AXE', scal = lineicAxis, nbret = nocc)
        ASSERT(nocc .eq. 1)
        call getvtx(' ', 'SECTION', scal = lineicSect, nbret = nocc)
        ASSERT(nocc .eq. 1)
    endif
!
! - Get parameters - For SVD selection
!
    call getvr8(' ', 'TOLE_SVD', scal = toleSVD)
    if (operation .eq. 'POD_INCR') then
        call getvr8(' ', 'TOLE', scal = toleIncr)
    endif
!
! - Read parameters for snapshot selection
!
    call romSnapRead(resultDomName, paraPod%snap)
!
! - Read parameters for reduced coordinate table
!
    if (operation .eq. 'POD_INCR') then
        call romTableParaRead(paraPod%tablReduCoor)
    endif
!
! - Get parameters for result datastructure
!
    call romResultGetInfo(resultDomName, resultDom)
!
! - Save parameters in datastructure
!
    paraPod%nbCmpToFilter  = nbCmpToFilter
    paraPod%nbVariToFilter = nbVariToFilter
    paraPod%fieldName      = fieldName
    paraPod%baseType       = baseType
    paraPod%lineicAxis     = lineicAxis
    paraPod%lineicSect     = lineicSect
    paraPod%toleSVD        = toleSVD
    paraPod%toleIncr       = toleIncr
    paraPod%nbModeMaxi     = nbModeMaxi
    paraPod%resultDomName  = resultDomName
    paraPod%resultDom      = resultDom
!
end subroutine
