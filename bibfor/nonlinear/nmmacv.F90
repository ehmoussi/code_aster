! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine nmmacv(disp, matr_sstr, cnsstr)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mrmult.h"
!
character(len=19), intent(in) :: matr_sstr, disp, cnsstr
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute sub-structuring effect on second member
!
! --------------------------------------------------------------------------------------------------
!
! In  disp             : displacement field
! In  matr_sstr        : name of sub-structuring matrix
! In  cnsstr           : name of sub-structuring effect on second member
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jrsst
    real(kind=8), pointer :: v_cnsstr(:) => null()
    real(kind=8), pointer :: v_disp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jeveuo(cnsstr(1:19)//'.VALE', 'E', vr=v_cnsstr)
    call jeveuo(disp(1:19)//'.VALE', 'L', vr=v_disp)
    call jeveuo(matr_sstr(1:19) //'.&INT', 'L', jrsst)
    call mrmult('ZERO', jrsst, v_disp, v_cnsstr, 1, ASTER_TRUE)
!
end subroutine
