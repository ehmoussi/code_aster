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
    subroutine nmveot(drbdb, drbdp, drpdb, drpdp, drbde,&
                      drpde, dsgde, dsgdb, dsgdp, np,&
                      nb, nr, dsidep)
        integer :: nb
        integer :: np
        real(kind=8) :: drbdb(nb, nb)
        real(kind=8) :: drbdp(nb, np)
        real(kind=8) :: drpdb(np, nb)
        real(kind=8) :: drpdp(np, np)
        real(kind=8) :: drbde(nb, nb)
        real(kind=8) :: drpde(np, nb)
        real(kind=8) :: dsgde(nb, nb)
        real(kind=8) :: dsgdb(nb, nb)
        real(kind=8) :: dsgdp(nb, np)
        integer :: nr
        real(kind=8) :: dsidep(nb, nb)
    end subroutine nmveot
end interface
