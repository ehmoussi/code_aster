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

subroutine apcalc(pair_category, mesh, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/infdbg.h"
#include "asterfort/apstos.h"
#include "asterfort/apntos.h"
#include "asterfort/apimpr.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=6), intent(in) :: pair_category
    character(len=8), intent(in) :: mesh
    type(NL_DS_Contact), intent(inout) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Pairing
!
! --------------------------------------------------------------------------------------------------
!
! In  pair_category    : type of pairing Segment_To_Segment or Node_To_Segment
! In  mesh             : name of mesh
! IO  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('APPARIEMENT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<Pairing> Compute ...'
    endif
!
! - Pairing
!
    if (pair_category .eq. 'N_To_S') then
        call apntos(mesh, ds_contact)
    elseif (pair_category .eq. 'S_To_S') then
        call apstos(mesh, ds_contact)
    else
        ASSERT(.false.)
    endif
!
! - Debug print
!
    if (niv .ge. 2) then
        call apimpr(pair_category, ifm, mesh, ds_contact)
    endif
!
end subroutine
