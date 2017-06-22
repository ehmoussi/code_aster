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
    subroutine dlarch(result, neq, istoc, iarchi, texte,&
                      alarm, temps, nbtyar, typear, masse,&
                      depl, vite, acce, fexte, famor,&
                      fliai)
        integer :: nbtyar
        integer :: neq
        character(len=8) :: result
        integer :: istoc
        integer :: iarchi
        character(len=*) :: texte
        integer :: alarm
        real(kind=8) :: temps
        character(len=16) :: typear(nbtyar)
        character(len=8) :: masse
        real(kind=8) :: depl(neq)
        real(kind=8) :: vite(neq)
        real(kind=8) :: acce(neq)
        real(kind=8) :: fexte(neq)
        real(kind=8) :: famor(neq)
        real(kind=8) :: fliai(neq)
    end subroutine dlarch
end interface
