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
    subroutine cer3pt(cupn0, cvpn0, cupn1, cvpn1, cupn2,&
                      cvpn2, cuon, cvon, rayon)
        real(kind=8) :: cupn0
        real(kind=8) :: cvpn0
        real(kind=8) :: cupn1
        real(kind=8) :: cvpn1
        real(kind=8) :: cupn2
        real(kind=8) :: cvpn2
        real(kind=8) :: cuon
        real(kind=8) :: cvon
        real(kind=8) :: rayon
    end subroutine cer3pt
end interface
