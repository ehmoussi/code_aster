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
interface 
    subroutine b3d_dc(sigec03, long3, dcf, dc0, e,&
                      delta, gf, rc, epic, beta,&
                      gama, reg, fr2, suc1, ifour,&
                      aleas0, bw1, pw1)
        real(kind=8) :: sigec03(3)
        real(kind=8) :: long3(3)
        real(kind=8) :: dcf
        real(kind=8) :: dc0
        real(kind=8) :: e
        real(kind=8) :: delta
        real(kind=8) :: gf
        real(kind=8) :: rc
        real(kind=8) :: epic
        real(kind=8) :: beta
        real(kind=8) :: gama
        real(kind=8) :: reg
        real(kind=8) :: fr2
        real(kind=8) :: suc1
        integer :: ifour
        real(kind=8) :: aleas0
        real(kind=8) :: bw1
        real(kind=8) :: pw1
    end subroutine b3d_dc
end interface 
