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

subroutine dfllae(keywf, i_fail, pcent_iter_plus)
!
implicit none
!
#include "asterfort/getvr8.h"
!
!
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: i_fail
    real(kind=8), intent(out) :: pcent_iter_plus
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST
!
! Get parameters of ACTION=ITER_SUPPL for current failure keyword
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : factor keyword to read failures
! In  i_fail           : index of current factor keyword to read failure
! Out pcent_iter_plus  : value of PCENT_ITER_PLUS for ACTION=ITER_SUPPL
!
! --------------------------------------------------------------------------------------------------
!
    pcent_iter_plus = 0.d0
    call getvr8(keywf, 'PCENT_ITER_PLUS', iocc=i_fail, scal=pcent_iter_plus)
!
end subroutine
