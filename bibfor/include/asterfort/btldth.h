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
    subroutine btldth(fami, xi3, nb1, kpg, btild,&
                      wgt, indic, young, nu, alpha,&
                      temper, forthi)
        character(len=4) :: fami
        real(kind=8) :: xi3
        integer :: nb1
        integer :: kpg
        real(kind=8) :: btild(5, 42)
        real(kind=8) :: wgt
        integer :: indic
        real(kind=8) :: young
        real(kind=8) :: nu
        real(kind=8) :: alpha
        real(kind=8) :: temper
        real(kind=8) :: forthi(1)
    end subroutine btldth
end interface
