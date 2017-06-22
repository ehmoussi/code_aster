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
    subroutine mdfedy(nbpal, nbmode, numpas, dt, dtsto,&
                      tcf, vrotat, dplmod, depgen, vitgen,&
                      fexgen, typal, finpal, cnpal, prdeff,&
                      conv, fsauv)
        integer :: nbmode
        integer :: nbpal
        integer :: numpas
        real(kind=8) :: dt
        real(kind=8) :: dtsto
        real(kind=8) :: tcf
        real(kind=8) :: vrotat
        real(kind=8) :: dplmod(nbpal, nbmode, *)
        real(kind=8) :: depgen(*)
        real(kind=8) :: vitgen(*)
        real(kind=8) :: fexgen(*)
        character(len=6) :: typal(20)
        character(len=3) :: finpal(20)
        character(len=8) :: cnpal(20)
        aster_logical :: prdeff
        real(kind=8) :: conv
        real(kind=8) :: fsauv(20, 3)
    end subroutine mdfedy
end interface
