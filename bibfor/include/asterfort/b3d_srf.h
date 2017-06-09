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
    subroutine b3d_srf(sigal6, vss33, spl6, long3, eps23,&
                       wfeff3, wfm6, vss33t, sigaf6, xnu0,&
                       e0, dtpic, rc, wref, tanphi,&
                       d66, erreur, dlt3, ssl6, ept0,&
                       sigel6, sref, fl3d, eve6, vve6,&
                       sve6, y1sy, tau1, tau2, cc2,&
                       teta1, eafluage, dt, vm6, maj0,&
                       depst6, sigef06, xloc)
#include "asterf_types.h"
        real(kind=8) :: sigal6(6)
        real(kind=8) :: vss33(3, 3)
        real(kind=8) :: spl6(6)
        real(kind=8) :: long3(3)
        real(kind=8) :: eps23(3)
        real(kind=8) :: wfeff3(3)
        real(kind=8) :: wfm6(6)
        real(kind=8) :: vss33t(3, 3)
        real(kind=8) :: sigaf6(6)
        real(kind=8) :: xnu0
        real(kind=8) :: e0
        real(kind=8) :: dtpic
        real(kind=8) :: rc
        real(kind=8) :: wref
        real(kind=8) :: tanphi
        real(kind=8) :: d66(6, 6)
        integer :: erreur
        real(kind=8) :: dlt3(3)
        real(kind=8) :: ssl6(6)
        real(kind=8) :: ept0
        real(kind=8) :: sigel6(6)
        real(kind=8) :: sref
        aster_logical :: fl3d
        real(kind=8) :: eve6(6)
        real(kind=8) :: vve6(6)
        real(kind=8) :: sve6(6)
        real(kind=8) :: y1sy
        real(kind=8) :: tau1
        real(kind=8) :: tau2
        real(kind=8) :: cc2
        real(kind=8) :: teta1
        real(kind=8) :: eafluage
        real(kind=8) :: dt
        real(kind=8) :: vm6(6)
        aster_logical :: maj0
        real(kind=8) :: depst6(6)
        real(kind=8) :: sigef06(6)
        real(kind=8) :: xloc
    end subroutine b3d_srf
end interface 
