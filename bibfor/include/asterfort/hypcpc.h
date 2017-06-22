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
    subroutine hypcpc(c11, c22, c33, c12, k,&
                      c10, c01, c20, nitmax, epsi,&
                      sig, codret)
        real(kind=8) :: c11
        real(kind=8) :: c22
        real(kind=8) :: c33
        real(kind=8) :: c12
        real(kind=8) :: k
        real(kind=8) :: c10
        real(kind=8) :: c01
        real(kind=8) :: c20
        integer :: nitmax
        real(kind=8) :: epsi
        real(kind=8) :: sig(6)
        integer :: codret
    end subroutine hypcpc
end interface
