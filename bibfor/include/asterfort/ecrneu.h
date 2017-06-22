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
    subroutine ecrneu(imod, nbnode, ama, bma, cma,&
                      ami, bmi, cmi, min, man,&
                      ites)
        integer :: imod
        integer :: nbnode
        real(kind=8) :: ama
        real(kind=8) :: bma
        real(kind=8) :: cma
        real(kind=8) :: ami
        real(kind=8) :: bmi
        real(kind=8) :: cmi
        integer :: min
        integer :: man
        integer :: ites
    end subroutine ecrneu
end interface
