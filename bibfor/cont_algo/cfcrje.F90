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

subroutine cfcrje(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/cfdisi.h"
#include "asterfort/infdbg.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Discrete methods - Create datastructures for gaps
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nt_cont_poin
    character(len=24) :: sdcont_jeuite, sdcont_jeusav, sdcont_jeux
    integer :: jv_sdcont_jeuite, jv_sdcont_jeusav, jv_sdcont_jeux
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> ...... CREATION DES SD POUR LES JEUX'
    endif
!
! - Get contact parameters
!
    nt_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC')
!
! - Updated gaps
!
    sdcont_jeuite = ds_contact%sdcont_solv(1:14)//'.JEUITE'
    call wkvect(sdcont_jeuite, 'V V R', 3*nt_cont_poin, jv_sdcont_jeuite)
!
! - Gaps at beginning of step time (for cut management)
!
    sdcont_jeusav = ds_contact%sdcont_solv(1:14)//'.JEUSAV'
    call wkvect(sdcont_jeusav, 'V V R', 3*nt_cont_poin, jv_sdcont_jeusav)
!
! - Gaps
!
    sdcont_jeux = ds_contact%sdcont_solv(1:14)//'.JEUX'
    call wkvect(sdcont_jeux, 'V V R', 3*nt_cont_poin, jv_sdcont_jeux)
!
end subroutine
