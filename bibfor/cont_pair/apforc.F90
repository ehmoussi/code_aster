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

subroutine apforc(mesh, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/aprema.h"
#include "asterfort/aprend.h"
#include "asterfort/infdbg.h"
#include "asterfort/sdmpic.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Pairing by "brute" force
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: newgeo, sdappa
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('APPARIEMENT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<Pairing> . Brut force'
    endif
!
! - Pairing datastructure
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
!
! - New geometry name
!
    newgeo = ds_contact%sdcont_solv(1:14)//'.NEWG'
!
! - Find nearest master node from current contact point
!
    call aprend(sdappa, ds_contact%sdcont_defi, newgeo)
!
! - Find nearest element from current contact point
!
    call aprema(sdappa, mesh, ds_contact%sdcont_defi, newgeo)
!
! - All-reduce pairing data structure
!
    call sdmpic('SD_APPA',sdappa)

!
end subroutine
