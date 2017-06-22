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
#include "asterf_types.h"
!
interface
    subroutine nifipd(ndim, nno1, nno2, nno3, npg,&
                      iw, vff1, vff2, vff3, idff1,&
                      vu, vg, vp, geomi, typmod,&
                      option, mate, compor, lgpg, crit,&
                      instm, instp, ddlm, ddld, angmas,&
                      sigm, vim, sigp, vip, resi,&
                      rigi, vect, matr, codret)
        integer :: lgpg
        integer :: npg
        integer :: nno3
        integer :: nno2
        integer :: nno1
        integer :: ndim
        integer :: iw
        real(kind=8) :: vff1(nno1, npg)
        real(kind=8) :: vff2(nno2, npg)
        real(kind=8) :: vff3(nno3, npg)
        integer :: idff1
        integer :: vu(3, 27)
        integer :: vg(27)
        integer :: vp(27)
        real(kind=8) :: geomi(ndim, nno1)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        integer :: mate
        character(len=16) :: compor(*)
        real(kind=8) :: crit(*)
        real(kind=8) :: instm
        real(kind=8) :: instp
        real(kind=8) :: ddlm(*)
        real(kind=8) :: ddld(*)
        real(kind=8) :: angmas(*)
        real(kind=8) :: sigm(2*ndim+1, npg)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: sigp(2*ndim+1, npg)
        real(kind=8) :: vip(lgpg, npg)
        aster_logical :: resi
        aster_logical :: rigi
        real(kind=8) :: vect(*)
        real(kind=8) :: matr(*)
        integer :: codret
    end subroutine nifipd
end interface
