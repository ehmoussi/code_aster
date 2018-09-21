! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
                      sigp, dsidep, pk2m, pk2p, codret)
        aster_logical, intent(in) :: resi
        aster_logical, intent(in) :: rigi
        aster_logical, intent(in) :: cplan
        real(kind=8), intent(in) :: tn(6)
        real(kind=8), intent(in) :: tp(6)
        real(kind=8), intent(in) :: fm(3, 3)
        real(kind=8), intent(in) :: fp(3, 3)
        integer, intent(in) :: ndim
        integer, intent(in) :: lgpg
        real(kind=8), intent(out) :: vip(lgpg)
        integer, intent(in) :: g
        real(kind=8), intent(in) :: dtde(6,6)
        real(kind=8), intent(in) :: sigm(2*ndim)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: mate
        real(kind=8), intent(in) :: instp
        real(kind=8), intent(in) :: angmas(*)
        real(kind=8), intent(in) :: gn(3, 3)
        real(kind=8), intent(in) :: lamb(3)
        real(kind=8), intent(in) :: logl(3)
        real(kind=8), intent(out) :: sigp(2*ndim)
        real(kind=8), intent(out) :: dsidep(6, 6)
        real(kind=8), intent(out) :: pk2m(6)
        real(kind=8), intent(out) :: pk2p(6)
        integer, intent(out) :: codret
    end subroutine poslog
end interface
