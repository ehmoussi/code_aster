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
    subroutine nmpoel(npg, klv, xl, nno,&
                      nc, pgl, ugl,&
                      epsthe, e, em, effm, fl,&
                      effl)
        integer :: npg
        real(kind=8) :: klv(*)
        real(kind=8) :: xl
        integer :: nno
        integer :: nc
        real(kind=8) :: pgl(*)
        real(kind=8) :: ugl(*)
        real(kind=8) :: epsthe
        real(kind=8) :: e
        real(kind=8) :: em
        real(kind=8) :: effm(*)
        real(kind=8) :: fl(*)
        real(kind=8) :: effl(*)
    end subroutine nmpoel
end interface
