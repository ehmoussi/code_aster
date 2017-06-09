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

subroutine cfappa(mesh, ds_contact, time_curr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/apcalc.h"
#include "asterfort/cfapre.h"
#include "asterfort/cfpoin.h"
#include "asterfort/infdbg.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    type(NL_DS_Contact), intent(inout) :: ds_contact
    real(kind=8), intent(in) :: time_curr
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Discrete method - Pairing 
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! IO  ds_contact       : datastructure for contact management
! In  time_curr        : current time
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> .. Pairing'
    endif
!
! - Set pairing datastructure
!
    call cfpoin(mesh, ds_contact)
!
! - Pairing
!
    call apcalc('N_To_S', mesh, ds_contact)
!
! - Save pairing in contact datastructures
!
    call cfapre(mesh, ds_contact, time_curr)
!
end subroutine
