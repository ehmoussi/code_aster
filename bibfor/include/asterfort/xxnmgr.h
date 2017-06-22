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
    subroutine xxnmgr(elrefp, elrese, ndim, coorse, igeom,&
                      he, nfh, ddlc, ddlm, nfe,&
                      instam, instap, ideplp, sigm, vip,&
                      basloc, nnop, npg, typmod, option,&
                      imate, compor, lgpg, idecpg, crit,&
                      idepl, lsn, lst, nfiss, heavn,&
                      sigp, vi, matuu, ivectu, codret, jstno)
        integer :: nfiss
        integer :: lgpg
        integer :: npg
        integer :: nnop
        integer :: nfe
        integer :: nfh
        integer :: ndim
        character(len=8) :: elrefp
        character(len=8) :: elrese
        real(kind=8) :: coorse(*)
        integer :: igeom
        real(kind=8) :: he(nfiss)
        integer :: ddlc
        integer :: ddlm
        real(kind=8) :: instam
        real(kind=8) :: instap
        integer :: ideplp
        real(kind=8) :: sigm(2*ndim, npg)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: basloc(3*ndim*nnop)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        integer :: imate
        character(len=16) :: compor(4)
        integer :: idecpg
        real(kind=8) :: crit(3)
        integer :: idepl
        real(kind=8) :: lsn(nnop)
        real(kind=8) :: lst(nnop)
        integer :: heavn(nnop, 5)
        real(kind=8) :: sigp(2*ndim, npg)
        real(kind=8) :: vi(lgpg, npg)
        real(kind=8) :: matuu(*)
        integer :: ivectu
        integer :: codret
        integer :: jstno
    end subroutine xxnmgr
end interface
