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
    subroutine rc32fp(nbsigr, nocc, nom, situ, sigr, fuij,&
                      comb, lieu, ug, factus, factus2, ugenv, fatiguenv)
        integer :: nbsigr
        integer :: nocc(*)
        character(len=24) :: nom(*)
        integer :: situ(*)
        integer :: sigr(*)
        real(kind=8) :: fuij(*)
        real(kind=8) :: comb(*)
        character(len=4) :: lieu
        real(kind=8) :: ug
        real(kind=8) :: factus(*)
        character(len=24) :: factus2(*)
        real(kind=8) :: ugenv
        aster_logical :: fatiguenv
    end subroutine rc32fp
end interface
