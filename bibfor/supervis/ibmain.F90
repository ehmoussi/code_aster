! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine ibmain()
    implicit none
#include "asterc/inisig.h"
#include "asterfort/assert.h"
#include "asterfort/ib0mai.h"
#include "asterfort/lxinit.h"
#include "asterfort/utgtme.h"
#include "asterfort/utptme.h"

    character(len=8) :: k8tab(1)
    real(kind=8) :: valr(1)
    integer :: iret

!   Initialization of MEM_INIT
    k8tab(1) = 'VMSIZE'
    call utgtme(1, k8tab, valr, iret)
    ASSERT(iret .eq. 0)
    call utptme('MEM_INIT', valr(1), iret)
    ASSERT(iret .eq. 0)

!   Initialization of the internal parser
    call lxinit()

!   Initialization of signal interruption
    call inisig()

!   Initialization of jeveux
    call ib0mai()

end subroutine
