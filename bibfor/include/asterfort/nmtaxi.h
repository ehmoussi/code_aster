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
    subroutine nmtaxi(ndimsi, crit, mat, sigel, vim,&
                      epm, dp, sp, xi, g,&
                      iret)
        integer :: ndimsi
        real(kind=8) :: crit(3)
        real(kind=8) :: mat(14)
        real(kind=8) :: sigel(*)
        real(kind=8) :: vim(9)
        real(kind=8) :: epm(*)
        real(kind=8) :: dp
        real(kind=8) :: sp
        real(kind=8) :: xi
        real(kind=8) :: g
        integer :: iret
    end subroutine nmtaxi
end interface
