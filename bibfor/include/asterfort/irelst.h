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
    subroutine irelst(nofimd, chanom, nochmd, typech, nomaas,&
                      nomamd, nbimpr, caimpi, caimpk, sdcarm,&
                      carael)
        integer :: nbimpr
        character(len=*) :: nofimd
        character(len=19) :: chanom
        character(len=8) :: typech
        character(len=8) :: nomaas
        character(len=64) :: nomamd, nochmd
        integer :: caimpi(10, nbimpr)
        character(len=80) :: caimpk(3, nbimpr)
        character(len=8) :: sdcarm, carael
    end subroutine irelst
end interface
