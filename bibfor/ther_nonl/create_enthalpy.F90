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

subroutine create_enthalpy(rhocp, enthalpy)
    implicit none
!   ----------------------------------------------------------------------------
!   Integrate the rho_cp function by adding a point at T=0 K
!   to be sure to always manipulate a positive enthalpy.
!
!   The constant of integration does not modify the solved equations (r5.02.02)
!
!   rhocp (in): Name of the rhocp function.
!   enthalpy (in): Name of the enthalpy function as result.
!   ----------------------------------------------------------------------------

#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/focain.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"

    character(len=19), intent(in) :: rhocp, enthalpy

    real(kind=8) :: rhomoy, beta0
    integer :: nbval
    real(kind=8), pointer :: values(:) => null()
    character(len=24), pointer :: prol1(:) => null(), prol2(:) => null()
    aster_logical :: is_cste

    call jemarq()
    call jeveuo(rhocp//'.PROL', 'L', vk24=prol1)

    ! Calculate the constant of integration = \int_0K^T0 rhocp.dT
    call jelira(rhocp//'.VALE', 'LONUTI', nbval)
    call jeveuo(rhocp//'.VALE', 'L', vr=values)
    is_cste = nbval .eq. 2

    if (.not. is_cste) then
        rhomoy = values(nbval/2 + 2) + values(nbval/2 + 1)
        beta0 = 0.5d0 * rhomoy * (-273.15 - values(1))
    else
        beta0 = values(2) * (-273.15 - values(1))
    endif

    call focain('TRAPEZE', rhocp, -beta0, enthalpy, 'G')

    call jeveuo(enthalpy//'.PROL', 'E', vk24=prol2)
    ! The extension on the left is necessarly linear.
    ! If rho_cp has a constant extension, the enthalpy extension is linear.
    prol2(5)(1:1) = 'L'
    if (prol1(5)(2:2) .eq. 'C') then
        prol2(5)(2:2) = 'L'
    endif

    call jedema()

end subroutine
