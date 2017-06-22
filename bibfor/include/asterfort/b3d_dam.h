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
    subroutine b3d_dam(s, e, epic, reg, r,&
                       nu, dam, e2, fr, beta,&
                       dpic)
        real(kind=8) :: s
        real(kind=8) :: e
        real(kind=8) :: epic
        real(kind=8) :: reg
        real(kind=8) :: r
        real(kind=8) :: nu
        real(kind=8) :: dam
        real(kind=8) :: e2
        real(kind=8) :: fr
        real(kind=8) :: beta
        real(kind=8) :: dpic
    end subroutine b3d_dam
end interface 
