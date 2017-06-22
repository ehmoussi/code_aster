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
    subroutine coqrep(pgl, alpha, beta, t2iu, t2ui,&
                      c, s)
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: alpha
        real(kind=8) :: beta
        real(kind=8) :: t2iu(*)
        real(kind=8) :: t2ui(*)
        real(kind=8) :: c
        real(kind=8) :: s
    end subroutine coqrep
end interface
