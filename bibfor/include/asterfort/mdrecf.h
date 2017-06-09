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
    subroutine mdrecf(nexci, nexcir, idescf, nomfon, coefm,&
                      iadvec, inumor, fondep, fonvit, fonacc,&
                      neq, typbas, basemo, nbmode, riggen,&
                      nommot, nomres)
        integer :: nbmode
        integer :: nexci
        integer :: nexcir
        integer :: idescf(*)
        character(len=8) :: nomfon(2*nexci)
        real(kind=8) :: coefm(*)
        integer :: iadvec(*)
        integer :: inumor(*)
        character(len=8) :: fondep(2*nexci)
        character(len=8) :: fonvit(2*nexci)
        character(len=8) :: fonacc(2*nexci)
        integer :: neq
        character(len=16) :: typbas
        character(len=8) :: basemo
        real(kind=8) :: riggen(nbmode)
        character(len=8) :: nommot
        character(len=8) :: nomres
    end subroutine mdrecf
end interface
