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

subroutine cfliin(mesh, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfecrd.h"
#include "asterfort/cfimp1.h"
#include "asterfort/cfinal.h"
#include "asterfort/infdbg.h"
#include "asterfort/mmbouc.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    type(NL_DS_Contact), intent(inout) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Discrete methods - Set initial links
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! IO  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbliac
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> ......... DETECTION DES LIAISONS INITIALES'
    endif
!
! - Get total number of initial links
!
    nbliac = 0
!
! - Set initial links
!
    call cfinal(ds_contact, nbliac)
!
! - Save initial links
!
    call cfecrd(ds_contact%sdcont_solv, 'NBLIAC', nbliac)
!
! - Print
!
    if (niv .ge. 2) then
        call cfimp1('INI', mesh, ds_contact%sdcont_defi, ds_contact%sdcont_solv, ifm)
    endif
!
end subroutine
