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
    subroutine xxbsig(elrefp, elrese, ndim, coorse,&
                      igeom, he, nfh, ddlc, ddlm,&
                      nfe, basloc, nnop, npg, sigma,&
                      compor, idepl, lsn, lst, nfiss,&
                      heavn, jstno, codopt, ivectu, imate)
        integer :: codopt
        integer :: nfiss
        integer :: npg
        integer :: nnop
        integer :: nfe
        integer :: nfh
        integer, optional :: imate
        integer :: ndim
        character(len=8) :: elrefp
        character(len=8) :: elrese
        real(kind=8) :: coorse(*)
        integer :: igeom
        real(kind=8) :: he(nfiss)
        integer :: ddlc
        integer :: ddlm
        real(kind=8) :: basloc(3*ndim*nnop)
        real(kind=8) :: sigma(codopt*(2*ndim-1)+1, codopt*(npg-1)+1)
        character(len=16) :: compor(4)
        integer :: idepl
        real(kind=8) :: lsn(nnop)
        real(kind=8) :: lst(nnop)
        integer :: heavn(nnop, 5)
        integer :: ivectu
        integer :: jstno
    end subroutine xxbsig
end interface
