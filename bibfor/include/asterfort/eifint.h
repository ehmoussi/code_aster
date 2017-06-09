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
    subroutine eifint(ndim, axi, nno1, nno2, npg,&
                      wref, vff1, vff2, dffr2, geom,&
                      ang, typmod, option, mat, compor,&
                      lgpg, crit, instam, instap, ddlm,&
                      ddld, iu, im, vim, sigp,&
                      vip, matr, vect, codret)
        integer :: lgpg
        integer :: npg
        integer :: nno2
        integer :: nno1
        integer :: ndim
        aster_logical :: axi
        real(kind=8) :: wref(npg)
        real(kind=8) :: vff1(nno1, npg)
        real(kind=8) :: vff2(nno2, npg)
        real(kind=8) :: dffr2(ndim-1, nno2, npg)
        real(kind=8) :: geom(ndim, nno2)
        real(kind=8) :: ang(*)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        integer :: mat
        character(len=16) :: compor(*)
        real(kind=8) :: crit(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        real(kind=8) :: ddlm(2*nno1*ndim+nno2*ndim)
        real(kind=8) :: ddld(2*nno1*ndim+nno2*ndim)
        integer :: iu(3, 18)
        integer :: im(3, 9)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: sigp(2*ndim, npg)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: matr(*)
        real(kind=8) :: vect(2*nno1*ndim+nno2*ndim)
        integer :: codret
    end subroutine eifint
end interface
