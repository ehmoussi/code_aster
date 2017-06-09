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
    subroutine xsifle(ndim, ifa, jptint, cface,&
                      igeom, nfh, jheavn, singu, nfe, ddlc,&
                      ddlm, jlsn, jlst, jstno, ipres, ipref, itemps,&
                      idepl, nnop, valres, basloc, ithet,&
                      nompar, option, igthet, jbasec,&
                      contac)
        integer :: nnop
        integer :: ndim
        integer :: ifa
        integer :: jptint
        integer :: cface(30, 6)
        integer :: igeom
        integer :: nfh
        integer :: singu
        integer :: nfe
        integer :: ddlc
        integer :: ddlm
        integer :: jlst
        integer :: jheavn
        integer :: ipres
        integer :: ipref
        integer :: itemps
        integer :: idepl
        integer :: jstno
        integer :: jlsn
        real(kind=8) :: valres(3)
        real(kind=8) :: basloc(9*nnop)
        integer :: ithet
        character(len=8) :: nompar(4)
        character(len=16) :: option
        integer :: igthet
        integer :: jbasec
        integer :: contac
    end subroutine xsifle
end interface
