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
    subroutine critev(epsp, epsd, eta, lambda, deuxmu,&
                      fpd, seuil, rd, crit, critp)
        real(kind=8) :: epsp(7)
        real(kind=8) :: epsd(7)
        real(kind=8) :: eta
        real(kind=8) :: lambda
        real(kind=8) :: deuxmu
        real(kind=8) :: fpd
        real(kind=8) :: seuil
        real(kind=8) :: rd
        real(kind=8) :: crit
        real(kind=8) :: critp
    end subroutine critev
end interface
