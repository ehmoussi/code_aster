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

subroutine impmem()
    implicit none
!     RENVOIE LA VALEUR EN MEGA OCTETS DE LA MEMOIRE UTILISEE PAR JEVEUX
!
! ======================================================================
#include "asterfort/assert.h"
#include "asterfort/r8inir.h"
#include "asterfort/utgtme.h"
#include "asterfort/utmess.h"
    real(kind=8) :: rval(4)
    character(len=8) :: k8tab(4)
    integer :: iret
!
    call r8inir(4, -1.d0, rval, 1)
    k8tab(1) = 'VMPEAK'
    k8tab(2) = 'VMSIZE'
    k8tab(3) = 'CMAX_JV'
    k8tab(4) = 'CMXU_JV'
    call utgtme(4, k8tab, rval, iret)
    ASSERT(iret .eq. 0)
    if (rval(2) .gt. 0.d0) then
        call utmess('I', 'SUPERVIS2_77', nr=4, valr=rval)
    else
        call utmess('I', 'SUPERVIS2_78', nr=4, valr=rval)
    endif
!
end subroutine
