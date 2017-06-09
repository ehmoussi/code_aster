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
    subroutine poslog(resi, rigi, tn, tp, fm,&
                      lgpg, vip, ndim, fp, g,&
                      dtde, sigm, cplan, fami, mate,&
                      instp, angmas, gn, lamb, logl,&
                      sigp, dsidep, pk2m, pk2, codret)
        integer :: ndim
        integer :: lgpg
        aster_logical :: resi
        aster_logical :: rigi
        real(kind=8) :: tn(6)
        real(kind=8) :: tp(6)
        real(kind=8) :: fm(3, 3)
        real(kind=8) :: vip(lgpg)
        real(kind=8) :: fp(3, 3)
        integer :: g
        real(kind=8) :: dtde(6, 6)
        real(kind=8) :: sigm(2*ndim)
        aster_logical :: cplan
        character(len=*) :: fami
        integer :: mate
        real(kind=8) :: instp
        real(kind=8) :: angmas(*)
        real(kind=8) :: gn(3, 3)
        real(kind=8) :: lamb(3)
        real(kind=8) :: logl(3)
        real(kind=8) :: sigp(2*ndim)
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: pk2m(6)
        real(kind=8) :: pk2(6)
        integer :: codret
    end subroutine poslog
end interface
