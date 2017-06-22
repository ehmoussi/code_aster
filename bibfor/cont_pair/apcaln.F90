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

subroutine apcaln(mesh, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/aptgen.h"
#include "asterfort/aptgno.h"
#include "asterfort/apverl.h"
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
! Compute tangents
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
    aster_logical :: one_proc
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('APPARIEMENT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<Pairing> . Compute tangents'
    endif
!
! - Inititializations
!
    one_proc = .false._1
!
! - Pairing datastructure
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
!
! - New geometry name
!
    newgeo = ds_contact%sdcont_solv(1:14)//'.NEWG'
!
! - Compute tangents at each node for each element
!
    call aptgen(sdappa, mesh, ds_contact%sdcont_defi, newgeo)
!
! - All-reduce for tangents field by element
!
    if (.not. one_proc) then
        call sdmpic('SD_APPA_TGEL',sdappa)
    endif
!
! - Compute 
!
    call aptgno(sdappa, mesh, ds_contact%sdcont_defi)
!
! - All-reduce for tangents at each node field
!
    if (.not. one_proc) then
        call sdmpic('SD_APPA_TGNO',sdappa)   
    endif 
!
! - Check normals discontinuity
!
    call apverl(sdappa, mesh, ds_contact%sdcont_defi)
!
end subroutine
