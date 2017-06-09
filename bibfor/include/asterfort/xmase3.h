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
    subroutine xmase3(elrefp, ndim, coorse, igeom, he,&
                      nfh, ddlc, nfe, basloc, nnop,&
                      npg, imate, lsn, lst, matuu, heavn,&
                      jstno, nnops, ddlm)
        integer :: nnop
        integer :: nfe
        integer :: ddlc
        integer :: nfh
        integer :: ndim
        integer :: jstno
        integer :: ddlm
        integer :: nnops
        character(len=8) :: elrefp
        real(kind=8) :: coorse(*)
        integer :: igeom
        real(kind=8) :: he
        real(kind=8) :: basloc(9*nnop)
        integer :: npg
        integer :: imate
        real(kind=8) :: lsn(nnop)
        real(kind=8) :: lst(nnop)
        real(kind=8) :: matuu(*)
        integer :: heavn(27,5)
    end subroutine xmase3
end interface
