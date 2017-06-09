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

subroutine elref1(elrefe)
use calcul_module, only : calcul_status, ca_jnbelr_, ca_jnoelr_, ca_nute_
implicit none
! person_in_charge: jacques.pellet at edf.fr
#include "jeveux.h"
#include "asterfort/assert.h"
    character(len=8) :: elrefe
!----------------------------------------------------------------------
! but: recuperer l'elrefe d'un type_elem dans une routine te00ij
!----------------------------------------------------------------------
! Argument:
!   elrefe out  k8   :
!     - nom du elrefe "principal" du type_elem
!       associe a l'element fini que l'on traite dans la routine te00ij
!     - si le type_elem n'a pas d'elrefe :  elrefe='XXXXXXXX'
!----------------------------------------------------------------------

    ASSERT(calcul_status().eq.3)
    if (zi(ca_jnbelr_-1+2* (ca_nute_-1)+2) .eq. 0) then
        elrefe = 'XXXXXXXX'
    else
        elrefe = zk8(ca_jnoelr_-1+zi(ca_jnbelr_-1+2* (ca_nute_-1)+2))
    endif
    ASSERT(elrefe.ne.' ')
end subroutine
