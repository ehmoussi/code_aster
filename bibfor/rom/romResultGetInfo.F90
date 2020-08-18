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
subroutine romResultGetInfo(resultNameZ, result)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/gettco.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ltnotb.h"
#include "asterfort/exisd.h"
#include "asterfort/romResultPrintInfo.h"
!
character(len=*), intent(in) :: resultNameZ
type(ROM_DS_Result), intent(inout) :: result
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Get informations about (non-linear) results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure (EVOL_*)
! IO  result           : results
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret
    integer :: nbStore, nbLine
    character(len=8)  :: resultName
    character(len=24) :: tablName
    character(len=16) :: resultType
    aster_logical :: lTablFromResu
    integer, pointer :: tbnp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','ROM13_1')
    endif
!
! - Initializations
!
    nbStore       = 0
    resultName    = resultNameZ
    resultType    = ' '
    lTablFromResu = ASTER_FALSE
!
! - Get number of storing index
!
    call rs_get_liststore(resultName, nbStore)
!
! - Get type of result
!
    call gettco(resultName, resultType)
!
! - Detect reduced coordinates table
!
    call ltnotb(resultName, 'COOR_REDUIT', tablName, iret)
    if (iret .eq. 0) then
        call exisd('TABLE', tablName, iret)
        if (iret .ne. 0) then
            call jeveuo(tablName(1:19)//'.TBNP', 'L', vi=tbnp)
            nbLine = tbnp(2)
            if (nbLine .eq. 0) then
                iret = 1
            else
                iret = 0
            endif
        endif
    endif
    lTablFromResu = iret .eq. 0
!
! - Save parameters in datastructure
!
    result%resultType    = resultType
    result%resultName    = resultName
    result%nbStore       = nbStore
    result%lTablFromResu = lTablFromResu
!
! - Debug
!
    if (niv .ge. 2) then
        call romResultPrintInfo(result)
    endif
!
end subroutine
