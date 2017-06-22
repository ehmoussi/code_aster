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
interface
    subroutine xdvois(typma, ino, noma, numa, jlsnd, jlsnl, jconx2,&
                      ch2 , lsn, nbmano, jma, adrma, ndim, coupee,&
                      nno, arete, milieu, lsno, voisin)
        character(len=8) :: typma
        integer :: ino
        character(len=8) :: noma
        integer :: numa
        integer :: jlsnd
        integer :: jlsnl
        character(len=19) :: ch2
        real(kind=8) :: lsn(4)
        integer :: nbmano
        integer :: jma
        integer :: adrma
        integer :: ndim
        aster_logical :: coupee
        character(len=8) :: arete
        aster_logical :: milieu
        real(kind=8) :: lsno(3)
        integer :: voisin(3)
        integer :: jconx2
        integer :: nno
    end subroutine xdvois
end interface
