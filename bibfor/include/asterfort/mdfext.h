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
    subroutine mdfext(tinit, dt, neqgen, nbexci, idescf,&
                      nomfon, coefm, liad, inumor, nbpas,&
                      f)
        integer :: neqgen
        real(kind=8) :: tinit
        real(kind=8) :: dt
        integer :: nbexci
        integer :: idescf(*)
        character(len=8) :: nomfon(*)
        real(kind=8) :: coefm(*)
        integer :: liad(*)
        integer :: inumor(*)
        integer :: nbpas
        real(kind=8) :: f(neqgen, *)
    end subroutine mdfext
end interface
