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

subroutine mreacg(mesh, ds_contact, field_update_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/infdbg.h"
#include "asterfort/mmfield_prep.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    type(NL_DS_Contact), intent(in) :: ds_contact
    character(len=*), optional, intent(in) :: field_update_
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue method - Geometry update
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  ds_contact       : datastructure for contact management
! In  field_update     : displacement field to use for update. If not present, using DEPGEO
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=24) :: depgeo, oldgeo
    character(len=19) :: newgeo, field_update
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> ... Geometry update'
    endif
!
! - Name of objects
!
    oldgeo = mesh(1:8)//'.COORDO'
    depgeo = ds_contact%sdcont_solv(1:14)//'.DEPG'
    newgeo = ds_contact%sdcont_solv(1:14)//'.NEWG'
    if (present(field_update_)) then
        field_update = field_update_
    else
        field_update = depgeo(1:19)
    endif
!
! - Update
!
    call mmfield_prep(oldgeo, newgeo,&
                      l_update_ = .true._1, field_update_ = field_update, alpha_ = 1.d0)
!
end subroutine
