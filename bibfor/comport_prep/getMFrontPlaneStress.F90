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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine getMFrontPlaneStress(keywf, i_comp, rela_comp, l_mfront_cp)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lccree.h"
#include "asterc/lcdiscard.h"
#include "asterc/lctest.h"
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
!
character(len=16), intent(in) :: keywf
integer, intent(in) :: i_comp
character(len=16), intent(in) :: rela_comp
aster_logical, intent(out) :: l_mfront_cp
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get type of plane stress hypothesis for MFront
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : factor keyword to read (COMPORTEMENT)
! In  i_comp           : factor keyword index
! In  rela_comp        : RELATION comportment
! Out l_mfront_cp      : .true. if analytical plane stress
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=16) :: rela_comp_py, answer
!
! --------------------------------------------------------------------------------------------------
!
    l_mfront_cp = .false.
!
    if (rela_comp .eq. 'MFRONT') then
        call getvtx(keywf, 'ALGO_CPLAN', iocc = i_comp, scal = answer)
        l_mfront_cp = answer .eq. 'ANALYTIQUE'  
    else
        call lccree(1, rela_comp, rela_comp_py)
        call lctest(rela_comp_py, 'MODELISATION', 'C_PLAN', iret)
        l_mfront_cp = iret .ne. 0
        call lcdiscard(rela_comp_py)
    endif
!
end subroutine
