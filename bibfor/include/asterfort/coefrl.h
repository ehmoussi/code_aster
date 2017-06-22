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
    subroutine coefrl(nom1, nom2, nom3, nckmax, ipas,&
                      ires, bornck, nborck, coefck, ipas1,&
                      ires1)
        character(len=24) :: nom1
        character(len=24) :: nom2
        character(len=24) :: nom3
        integer :: nckmax
        integer :: ipas
        integer :: ires
        real(kind=8) :: bornck(20)
        integer :: nborck
        real(kind=8) :: coefck(20, 11)
        integer :: ipas1
        integer :: ires1
    end subroutine coefrl
end interface
