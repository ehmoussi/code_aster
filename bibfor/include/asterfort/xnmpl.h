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
    subroutine xnmpl(nnop, nfh, nfe, ddlc, ddlm,&
                     igeom, instam, instap, ideplp, sigm,&
                     vip, typmod, option, imate, compor,&
                     lgpg, carcri, jpintt, cnset, heavt,&
                     lonch, basloc, idepl, lsn, lst,&
                     sig, vi, matuu, ivectu, codret,&
                     jpmilt, nfiss, jheavn, jstno)
        integer :: nfiss
        integer :: nnop
        integer :: nfh
        integer :: nfe
        integer :: ddlc
        integer :: ddlm
        integer :: igeom
        real(kind=8) :: instam
        real(kind=8) :: instap
        integer :: ideplp
        real(kind=8) :: sigm(*)
        real(kind=8) :: vip(*)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        integer :: imate
        character(len=16) :: compor(*)
        integer :: lgpg
        real(kind=8) :: carcri(*)
        integer :: jpintt
        integer :: cnset(128)
        integer :: heavt(*)
        integer :: lonch(10)
        real(kind=8) :: basloc(*)
        integer :: idepl
        real(kind=8) :: lsn(nnop)
        real(kind=8) :: lst(nnop)
        real(kind=8) :: sig(*)
        real(kind=8) :: vi(*)
        real(kind=8) :: matuu(*)
        integer :: ivectu
        integer :: codret
        integer :: jpmilt
        integer :: jheavn
        integer :: jstno
    end subroutine xnmpl
end interface
