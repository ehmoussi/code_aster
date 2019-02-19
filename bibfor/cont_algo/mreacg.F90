! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mreacg(mesh, ds_contact, field_update)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/infdbg.h"
#include "asterfort/mmfield_prep.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: mesh
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=*), intent(in) :: field_update
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! LAC and continue methods - Geometry update
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  ds_contact       : datastructure for contact management
! In  field_update     : displacement field to use for update
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=24) :: oldgeo
    character(len=19) :: newgeo
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','CONTACT5_16')
    endif
!
! - Name of objects
!
    oldgeo = mesh(1:8)//'.COORDO'
    newgeo = ds_contact%sdcont_solv(1:14)//'.NEWG'
!
! - Update
!
    call mmfield_prep(oldgeo, newgeo,&
                      l_update_ = ASTER_TRUE, field_update_ = field_update, alpha_ = 1.d0)
!
end subroutine
