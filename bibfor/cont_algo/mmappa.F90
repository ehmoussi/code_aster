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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmappa(mesh, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/apcalc.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisl.h"
#include "asterfort/infdbg.h"
#include "asterfort/mmapre.h"
#include "asterfort/mmpoin.h"
#include "asterfort/mmptch.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: mesh
type(NL_DS_Contact), intent(inout) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue method - Pairing 
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! IO  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_cont_lac, l_cont_cont
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','CONTACT5_17')
    endif
!
! - Get parameters
!
    l_cont_cont  = cfdisl(ds_contact%sdcont_defi,'FORMUL_CONTINUE')
    l_cont_lac   = cfdisl(ds_contact%sdcont_defi,'FORMUL_LAC')
!
! - Pairing
!
    if (l_cont_cont) then
!
! ----- Set pairing datastructure
!
        call mmpoin(mesh, ds_contact)
!
! ----- Pairing
!
        call apcalc('N_To_S', mesh, ds_contact)
!
! ----- Save pairing in contact datastructures
!
        call mmapre(mesh, ds_contact)
    elseif (l_cont_lac) then
!
! ----- Set pairing datastructure (MPI)
!
        call mmptch(ds_contact)    
!
! ----- Pairing
!
        call apcalc('S_To_S', mesh, ds_contact)
!
! ----- Need new contact elements
!
        ds_contact%l_renumber = .true.
    else
        ASSERT(.false.)
    endif
!
end subroutine
