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

subroutine tbajvk(table, nbpara, nompar, vk, livk)
    implicit none
#include "asterfort/tbajva.h"
    integer :: nbpara
    character(len=*) :: table, nompar, vk, livk(*)
!
!     BUT:
!       ROUTINE CHAPEAU D'APPEL A TBAJVA POUR NE PASSER QUE DES CHAINES
!
! ----------------------------------------------------------------------
!
    integer :: vi, livi(1)
!
    real(kind=8) :: vr, livr(1)
!
    complex(kind=8) :: vc, livc(1)
!
! ----------------------------------------------------------------------
!
    vi = 0
    livi(1) = 0
    vr = 0.d0
    livr(1) = 0.d0
    vc = dcmplx(0.d0,0.d0)
    livc(1) = dcmplx(0.d0,0.d0)
!
    call tbajva(table, nbpara, nompar, vi, livi,&
                vr, livr, vc, livc, vk,&
                livk)
!
end subroutine
