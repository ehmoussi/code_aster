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
    subroutine zlahqr(wantt, wantz, n, ilo, ihi,&
                      h, ldh, w, iloz, ihiz,&
                      z, ldz, info)
        integer, intent(in) :: ldz
        integer, intent(in) :: ldh
        aster_logical, intent(in) :: wantt
        aster_logical, intent(in) :: wantz
        integer, intent(in) :: n
        integer, intent(in) :: ilo
        integer, intent(in) :: ihi
        complex(kind=8) ,intent(inout) :: h(ldh, *)
        complex(kind=8) ,intent(out) :: w(*)
        integer, intent(in) :: iloz
        integer, intent(in) :: ihiz
        complex(kind=8) ,intent(inout) :: z(ldz, *)
        blas_int, intent(out) :: info
    end subroutine zlahqr
end interface
