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
    subroutine xgelem(elrefp, ndim, coorse, igeom, jheavt,&
                      ise, nfh, ddlc, ddlm, nfe,&
                      basloc, nnop, idepl, lsn, lst,&
                      igthet, fno, nfiss, jheavn, jstno, incr)
        integer :: nfiss
        integer :: nnop
        integer :: ndim
        character(len=8) :: elrefp
        real(kind=8) :: coorse(*)
        integer :: igeom
        integer :: jheavt
        integer :: ise
        integer :: nfh
        integer :: ddlc
        integer :: ddlm
        integer :: nfe
        real(kind=8) :: basloc(3*ndim*nnop)
        integer :: idepl
        real(kind=8) :: lsn(nnop)
        real(kind=8) :: lst(nnop)
        integer :: igthet
        real(kind=8) :: fno(ndim*nnop)
        integer :: jheavn
        integer :: jstno
        aster_logical :: incr
    end subroutine xgelem
end interface
