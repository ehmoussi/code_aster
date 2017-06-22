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

subroutine moytpg(fami, kpg, nspg, poum, temp,&
                  iret)
!
implicit none
!
#include "asterfort/rcvarc.h"
!
!
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg
    integer, intent(in) :: nspg
    character(len=*), intent(in) :: poum
    real(kind=8), intent(out) :: temp
    integer, intent(out) :: iret
!
! --------------------------------------------------------------------------------------------------
!
! Compute mean temperature (on all "sous-point" gauss)
!
! --------------------------------------------------------------------------------------------------
!
! In  fami         : Gauss family for integration point rule
! In  kpg          : current point gauss
! In  nspg         : number of "sous-point" gauss
! In  poum         : parameters evaluation
!                     '-' for previous temperature
!                     '+' for current temperature
!                     'T' for current and previous temperature => epsth is increment
! Out temp         : mean temperature
! Out iret         : 0 if temperature defined
!                    1 if not  
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ispg
    real(kind=8) :: tg, tgtot
!
! --------------------------------------------------------------------------------------------------
!
    tgtot = 0.d0
    do ispg = 1, nspg
        call rcvarc(' ', 'TEMP', poum, fami, kpg,&
                    ispg, tg, iret)
        if (iret .eq. 1) then
            goto 999
        endif
        tgtot = tgtot + tg
    end do
    temp = tgtot/nspg
999 continue
end subroutine
