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
    subroutine glrcad(zimat, mp1, mp2, delas, rpara,&
                      dmax1, dmax2, dam1, dam2, curvcu,&
                      c1, c2, nbackn, deps, depsp,&
                      df, ddiss, dsidep, normm, normn,&
                      crit, codret)
        integer :: zimat
        real(kind=8) :: mp1(*)
        real(kind=8) :: mp2(*)
        real(kind=8) :: delas(6, 6)
        real(kind=8) :: rpara(5)
        real(kind=8) :: dmax1
        real(kind=8) :: dmax2
        real(kind=8) :: dam1
        real(kind=8) :: dam2
        real(kind=8) :: curvcu(3)
        real(kind=8) :: c1(6, 6)
        real(kind=8) :: c2(6, 6)
        real(kind=8) :: nbackn(6)
        real(kind=8) :: deps(6)
        real(kind=8) :: depsp(6)
        real(kind=8) :: df(6)
        real(kind=8) :: ddiss
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: normm
        real(kind=8) :: normn
        real(kind=8) :: crit(*)
        integer :: codret
    end subroutine glrcad
end interface
