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
    subroutine xbsig(ndim, nnop, nfh, nfe,&
                     ddlc, ddlm, igeom, compor, jpintt,&
                     cnset, heavt, lonch, basloc, sigma,&
                     nbsig, idepl, lsn, lst, ivectu,&
                     jpmilt, nfiss, jheavn, jstno, imate)
        integer :: nfiss
        integer :: nnop
        integer :: ndim
        integer :: nfh
        integer :: nfe
        integer :: ddlc
        integer :: ddlm
        integer :: igeom
        integer :: imate
        character(len=16) :: compor(*)
        integer :: jpintt
        integer :: cnset(128)
        integer :: heavt(*)
        integer :: lonch(10)
        real(kind=8) :: basloc(*)
        real(kind=8) :: sigma(*)
        integer :: nbsig
        integer :: idepl
        real(kind=8) :: lsn(nnop)
        real(kind=8) :: lst(nnop)
        integer :: ivectu
        integer :: jpmilt
        integer :: jheavn
        integer :: jstno
    end subroutine xbsig
end interface
