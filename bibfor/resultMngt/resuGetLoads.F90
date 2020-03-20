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
subroutine resuGetLoads(resultType, listLoad)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterfort/gnomsd.h"
#include "asterfort/utmess.h"
#include "asterfort/nmdoch.h"
#include "asterfort/ntdoch.h"
#include "asterfort/copisd.h"
!
character(len=16), intent(in) :: resultType
character(len=19), intent(out) :: listLoad
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU and CREA_RESU
!
! Get loads
!
! --------------------------------------------------------------------------------------------------
!
! In  resultType       : type of results datastructure (EVOL_NOLI, EVOL_THER, )
! Out listLoad         : name of datastructure for loads
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: loadFromUser
    character(len=24) :: noobj
    integer :: nbOcc
    character(len=19), parameter :: listLoadIn = '&&LRCOMM.LISTLOAD'
!
! --------------------------------------------------------------------------------------------------
!
    listLoad     = ' '
    loadFromUser = ASTER_TRUE
    call getfac('EXCIT', nbOcc)
    if (nbOcc .gt. 0) then
! ----- Generate name of datastructure
        noobj ='12345678.1234.EXCIT.INFC'
        call gnomsd(' ', noobj, 10, 13)
        listLoad = noobj(1:19)
! ----- Read from command file
        if (resultType .eq. 'EVOL_ELAS' .or. resultType .eq. 'EVOL_NOLI') then
            call nmdoch(listLoadIn, loadFromUser)
        else if (resultType .eq. 'EVOL_THER') then
            call ntdoch(listLoadIn)
        else
            call utmess('A', 'RESULT2_16', sk=resultType)
        endif
        call copisd(' ', 'G', listLoadIn, listLoad)
    endif
!
end subroutine
