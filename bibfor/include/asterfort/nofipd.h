! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine nofipd(ndim, nnod, nnop, nnog, npg,&
                      iw, vffd, vffp, vffg, idffd,&
                      vu, vp, vpi, geomi, typmod,&
                      option, nomte, mate, compor, lgpg,&
                      carcri, instm, instp, ddlm, ddld,&
                      angmas, sigm, vim, sigp, vip,&
                      vect, matr, codret,&
                      lSigm, lVect, lMatr)
        integer :: lgpg
        integer :: npg
        integer :: nnog
        integer :: nnop
        integer :: nnod
        integer :: ndim
        integer :: iw
        real(kind=8) :: vffd(nnod, npg)
        real(kind=8) :: vffp(nnop, npg)
        real(kind=8) :: vffg(nnog, npg)
        integer :: idffd
        integer :: vu(3, 27)
        integer :: vp(27)
        integer :: vpi(3, 27)
        real(kind=8) :: geomi(ndim, nnod)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        character(len=16) :: nomte
        integer :: mate
        character(len=16) :: compor(*)
        real(kind=8) :: carcri(*)
        real(kind=8) :: instm
        real(kind=8) :: instp
        real(kind=8) :: ddlm(*)
        real(kind=8) :: ddld(*)
        real(kind=8) :: angmas(*)
        real(kind=8) :: sigm(2*ndim+1, npg)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: sigp(2*ndim+1, npg)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: vect(*)
        real(kind=8) :: matr(*)
        integer :: codret
        aster_logical, intent(in) :: lSigm, lVect, lMatr
    end subroutine nofipd
end interface
