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
subroutine resuGetEmpiricParameters(resultType  , fieldNb   , fieldList    ,&
                                    empiNumePlan, empiSnapNb, empiFieldType)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/getvis.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(in) :: resultType
integer, intent(in) :: fieldNb
character(len=16), intent(in) :: fieldList(100)
integer, intent(out) :: empiNumePlan, empiSnapNb
character(len=24), intent(out) :: empiFieldType
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU and CREA_RESU
!
! Get empiric parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  resultType       : type of results datastructure (EVOL_NOLI, EVOL_THER, )
! In  fieldNb          : number of fields to read
! In  fieldList        : list of fields to read
! Out empiNumeplan     : index of plane for empiric modes
! Out empiSnapNb       : number of snapshots for empiric modes
! Out empiFieldType    : type of field for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbOcc
!
! --------------------------------------------------------------------------------------------------
!
    empiNumePlan  = 0
    empiSnapNb    = 0
    empiFieldType = ' '
!
! - Get
!
    if (resultType .eq. 'MODE_EMPI') then
        if (fieldNb .ne. 1) then
            call utmess('F', 'RESULT2_18')
        endif
        empiFieldType = fieldList(1)
        call getvis(' ', 'NUME_PLAN', scal=empiNumePlan, nbret=nbOcc)
        if (nbOcc .eq. 0) then
            empiNumePlan = 0
        endif
        empiSnapNb = 0
    endif
!
end subroutine
