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
    subroutine ccaccl(option, modele, mateco, carael, ligrel, &
                      typesd, nbpain, lipain, lichin, lichou, &
                      codret)
        character(len=16) :: option
        character(len=8) :: modele
        character(len=8) :: mateco
        character(len=8) :: carael
        character(len=24) :: ligrel
        character(len=16) :: typesd
        integer :: nbpain
        character(len=8) :: lipain(*)
        character(len=24) :: lichin(*)
        character(len=24) :: lichou(2)
        integer :: codret
    end subroutine ccaccl
end interface
