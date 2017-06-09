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
    subroutine pipeei(ndim, axi, nno1, nno2, npg,&
                      wref, vff1, vff2, dffr2, geom,&
                      ang, mat, compor, lgpg, ddlm,&
                      ddld, ddl0, ddl1, dtau, vim,&
                      iu, im, copilo)
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
        integer :: mat
        character(len=16) :: compor
        real(kind=8) :: ddlm(2*nno1*ndim+nno2*ndim)
        real(kind=8) :: ddld(2*nno1*ndim+nno2*ndim)
        real(kind=8) :: ddl0(2*nno1*ndim+nno2*ndim)
        real(kind=8) :: ddl1(2*nno1*ndim+nno2*ndim)
        real(kind=8) :: dtau
        real(kind=8) :: vim(lgpg, npg)
        integer :: iu(3, 18)
        integer :: im(3, 9)
        real(kind=8) :: copilo(5, npg)
    end subroutine pipeei
end interface
