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

subroutine mm_pene_crsd(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/cfdisi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Manage the penetration wit penalization method
!
! Creating data structures
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cont_poin, nb_cont_zone
    character(len=24) :: sdcont_pene
    real(kind=8), pointer :: p_sdcont_pene(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    nb_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC' )
    nb_cont_zone  = cfdisi(ds_contact%sdcont_defi,'NZOCO' )
!
! - Pentration saving 
!
    sdcont_pene = ds_contact%sdcont_solv(1:14)//'.PENETR'

!
! - Creating penetration management objects
!
!   p_sdcont_pene_zone : 1 --> store the computed penetration (=0. if standard methods)
!   p_sdcont_pene_zone : 2 --> store the current zone for print in convergence table (=0 if standard)
!   see mmopti for initialization
    call wkvect(sdcont_pene, 'V V R', nb_cont_poin, vr = p_sdcont_pene)
!
    call jedema()
end subroutine
