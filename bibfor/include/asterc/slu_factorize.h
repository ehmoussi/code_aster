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

!
!
interface
    subroutine slu_factorize( m, n, nnz, values, rowind, &
                              colptr, f_factors, info )
        integer(kind=4) :: m
        integer(kind=4) :: n
        integer(kind=4) :: nnz
        real(kind=8)    :: values(*)
        integer(kind=4) :: rowind(*)
        integer(kind=4) :: colptr(*)
        integer         :: f_factors
        integer(kind=4) :: info
    end subroutine slu_factorize
end interface
