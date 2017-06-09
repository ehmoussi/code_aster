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

subroutine nmtstm(carcri, jv_matr, l_matr_symm)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jevech.h"
!
!
    real(kind=8), intent(in) :: carcri(*)
    aster_logical, intent(out) :: l_matr_symm
    integer, intent(out) :: jv_matr
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility
!
! Select symmtric or unsymmetric matrix for tangent operator
!
! --------------------------------------------------------------------------------------------------
!
! In  carcri           : parameter for comportment
! Out l_matr_symm      : .true. if matrix is symmetric
! Out jv_matr          : JEVEUX address for matrix
!
! --------------------------------------------------------------------------------------------------
!
    l_matr_symm = .true.
    if (nint(carcri(17)) .gt. 0) then
        l_matr_symm = .false.
    endif
    if (l_matr_symm) then
        call jevech('PMATUUR', 'E', jv_matr)
    else
        call jevech('PMATUNS', 'E', jv_matr)
    endif
end subroutine
