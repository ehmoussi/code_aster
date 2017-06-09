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

subroutine cfinit(ds_contact, nume_inst)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisl.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mmbouc.h"
#include "asterfort/mminit.h"
#include "asterfort/vtzero.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(inout) :: ds_contact
    integer, intent(in) :: nume_inst
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Discrete methods - Initializations for current time step
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_contact       : datastructure for contact management
! In  nume_inst        : index of current step time
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_autoc1, sdcont_autoc2
!
! --------------------------------------------------------------------------------------------------
!
    sdcont_autoc1 = ds_contact%sdcont_solv(1:14)//'.REA1'
    sdcont_autoc2 = ds_contact%sdcont_solv(1:14)//'.REA2'
!
! - Geometric parameters
!
    call mmbouc(ds_contact, 'Geom', 'Set_Divergence')
    ds_contact%l_first_geom = .true._1
    if (cfdisl(ds_contact%sdcont_defi,'REAC_GEOM_SANS')) then
        if (nume_inst .ne. 1) then
            call mmbouc(ds_contact, 'Geom', 'Set_Convergence')
            ds_contact%l_first_geom = .false._1
        endif
    endif
!
! - Geometric loop counter initialization
!
    call mmbouc(ds_contact, 'Geom', 'Init_Counter')
!
! - First geometric loop counter
!    
    call mmbouc(ds_contact, 'Geom', 'Incr_Counter')
!
! - Vector initialization for REAC_GEOM
!
    call vtzero(sdcont_autoc1)
    call vtzero(sdcont_autoc2)
!
end subroutine
