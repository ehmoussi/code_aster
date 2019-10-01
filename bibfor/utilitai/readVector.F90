! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine readVector(name, nb_value, vect)
!
implicit none
!
#include "asterfort/jevech.h"
#include "blas/dcopy.h"
#include "jeveux.h"
!
!
    character(len=*), intent(in) :: name
    integer, intent(in)          :: nb_value
    real(kind=8), intent(out)    :: vect(*)
!
! --------------------------------------------------------------------------------------------------
!
! IO routine
!
! Read a vector in memory (zr)
!
! --------------------------------------------------------------------------------------------------
!
!   In name        : name of the vector read with jevech
!   In nb_value    : size of the vector
!   Out vect       : vector to read
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jv_vect_in
!
! --------------------------------------------------------------------------------------------------
!
    call jevech(name, 'L', jv_vect_in)
    call dcopy(nb_value, zr(jv_vect_in), 1, vect, 1)
!
end subroutine
