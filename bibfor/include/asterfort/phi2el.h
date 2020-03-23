! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine phi2el(modele, carele, mate, mateco, accel, phibar,&
                      instap, ve)
        character(len=*) :: modele
        character(len=*) :: carele
        character(len=*) :: mate, mateco
        character(len=*) :: accel
        character(len=*) :: phibar
        real(kind=8) :: instap
        character(len=*) :: ve
    end subroutine phi2el
end interface
