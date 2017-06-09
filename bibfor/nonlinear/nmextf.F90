! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine nmextf(keyw_fact, i_keyw_fact, type_extr_cmp)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(in) :: keyw_fact
    integer, intent(in) :: i_keyw_fact
    character(len=8), intent(out) :: type_extr_cmp
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Extraction (OBSERVATION/SUIVI_DDL) utilities 
!
! Get type of extraction for components
!
! --------------------------------------------------------------------------------------------------
!
! In  keyw_fact        : factor keyword to read extraction parameters
! In  i_keyw_fact      : index of keyword to read extraction parameters
! Out type_extr_cmp    : type of extraction for components
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: answer
!
! --------------------------------------------------------------------------------------------------
!
    type_extr_cmp = ' '
    call getvtx(keyw_fact, 'EVAL_CMP', iocc=i_keyw_fact, scal=answer)
    if (answer .eq. 'VALE') then
        type_extr_cmp = ' '
    else if (answer.eq.'FORMULE') then
        call getvid(keyw_fact, 'FORMULE', iocc=i_keyw_fact, scal=type_extr_cmp)
    else
        ASSERT(.false.)
    endif
!
end subroutine
