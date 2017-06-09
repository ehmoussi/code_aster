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
    subroutine xrige3(elrefp, ndim, coorse, igeom, he,&
                      heavn, ddlh, ddlc, nfe, basloc,&
                      nnop, npg, lsn, lst, sig,&
                      matuu, jstno, imate)
        integer :: nnop
        integer :: ndim
        character(len=8) :: elrefp
        real(kind=8) :: coorse(*)
        integer :: igeom
        real(kind=8) :: he
        integer :: heavn(27,5)
        integer :: ddlh
        integer :: ddlc
        integer :: nfe
        integer :: jstno
        integer :: imate
        real(kind=8) :: basloc(9*nnop)
        integer :: npg
        real(kind=8) :: lsn(nnop)
        real(kind=8) :: lst(nnop)
        real(kind=8) :: sig(90)
        real(kind=8) :: matuu(*)
    end subroutine xrige3
end interface
