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

subroutine ccchci(questz, type_comp, crit, norm, nb_form, &
                  repi)
!
    implicit none
!
#include "asterfort/assert.h"
!
! person_in_charge: mathieu.courtois at edf.fr
!
    character(len=*), intent(in) :: questz
    character(len=16), intent(in) :: type_comp
    character(len=16), intent(in) :: crit
    character(len=16), intent(in) :: norm
    integer, intent(in) :: nb_form
    integer, intent(out) :: repi
!
! --------------------------------------------------------------------------------------------------
!
! Command CALC_CHAMP
!
! Get info for CHAM_UTIL
!
! --------------------------------------------------------------------------------------------------
!
! In  question       : question
! In  type_comp      : type of computation (CRITERE, NORME or FORMULE)
! In  crit           : type of criterion
! In  norm           : type of norm
! In  nb_form        : number of formulas
! Out repi           : answer
!
! --------------------------------------------------------------------------------------------------
!
    character(len=5) :: question
!
! --------------------------------------------------------------------------------------------------
!
    question = questz
    repi     = 0
!
    if (question .eq. 'NBCMP') then
        if (type_comp .eq. 'CRITERE') then
            if (crit .eq. 'VMIS' .or. crit .eq. 'INVA_2' .or. crit .eq. 'TRACE') then
                repi = 1
            else
                ASSERT(.false.)
            endif
        elseif (type_comp .eq. 'NORME') then
            if (norm .eq. 'L2') then
                repi = 1
            elseif (norm .eq. 'FROBENIUS') then
                repi = 1
            else
                ASSERT(.false.)
            endif
        elseif (type_comp .eq. 'FORMULE') then
            repi = nb_form
        else
            ASSERT(.false.)
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
