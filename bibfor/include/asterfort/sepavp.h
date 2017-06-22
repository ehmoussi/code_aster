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

!
!
interface
    subroutine sepavp(ck, cm, cmat, ndim, alpha,&
                      beta, nbmod, lambd1, lambd2, interv)
        integer :: ndim
        complex(kind=8) :: ck(*)
        complex(kind=8) :: cm(*)
        complex(kind=8) :: cmat(*)
        real(kind=8) :: alpha(ndim+1)
        real(kind=8) :: beta(ndim+1)
        integer :: nbmod
        real(kind=8) :: lambd1
        real(kind=8) :: lambd2
        real(kind=8) :: interv
    end subroutine sepavp
end interface
