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
    subroutine glrc_integ_loc(lambda, deuxmu, seuil, alf,&
                              alfmc, gmt, gmc, cof1,&
                              vim, q2d, qff, tr2d, eps33,&
                              de33d1, de33d2, ksi2d, dksi1, dksi2,&
                              da1, da2, kdmax, told, codret,&
                              emp)
        real(kind=8) :: lambda
        real(kind=8) :: deuxmu
        real(kind=8) :: seuil
        real(kind=8) :: alf
        real(kind=8) :: alfmc
        real(kind=8) :: gmt
        real(kind=8) :: gmc
        real(kind=8) :: cof1(2)
        real(kind=8) :: vim(*)
        real(kind=8) :: q2d(2)
        real(kind=8) :: qff(2)
        real(kind=8) :: tr2d
        real(kind=8) :: eps33
        real(kind=8) :: de33d1
        real(kind=8) :: de33d2
        real(kind=8) :: ksi2d
        real(kind=8) :: dksi1
        real(kind=8) :: dksi2
        real(kind=8) :: da1
        real(kind=8) :: da2
        integer :: kdmax
        real(kind=8) :: told
        integer :: codret
        real(kind=8) :: emp(2)
    end subroutine glrc_integ_loc
end interface
