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

subroutine tbajvr(table, nbpara, nompar, vr, livr)
    implicit none
#include "asterfort/tbajva.h"
    integer :: nbpara
    real(kind=8) :: vr, livr(*)
    character(len=*) :: table, nompar
!
!     BUT:
!       ROUTINE CHAPEAU D'APPEL A TBAJVA POUR NE PASSER QUE DES REELS
!
! ----------------------------------------------------------------------
!
    integer :: vi, livi(1)
!
    character(len=8) :: vk, livk(1)
!
    complex(kind=8) :: vc, livc(1)
!
! ----------------------------------------------------------------------
!
    vi = 0
    livi(1) = 0
    vc = dcmplx(0.d0,0.d0)
    livc(1) = dcmplx(0.d0,0.d0)
    vk = ' '
    livk(1) = ' '
!
    call tbajva(table, nbpara, nompar, vi, livi,&
                vr, livr, vc, livc, vk,&
                livk)
!
end subroutine
