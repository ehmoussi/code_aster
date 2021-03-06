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
    subroutine calcfp(mutrbe, rprim, seuil, dt, dp,&
                      sigm0, epsi0, coefm, fplas, fprim,&
                      dfprim)
        real(kind=8) :: mutrbe
        real(kind=8) :: rprim
        real(kind=8) :: seuil
        real(kind=8) :: dt
        real(kind=8) :: dp
        real(kind=8) :: sigm0
        real(kind=8) :: epsi0
        real(kind=8) :: coefm
        real(kind=8) :: fplas
        real(kind=8) :: fprim
        real(kind=8) :: dfprim
    end subroutine calcfp
end interface
