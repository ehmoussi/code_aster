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
subroutine cfmmma(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/cfmmci.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue/Discrete method - Create datastructures for DISCRETE/CONTINUE methods
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_cont_poin, nb_cont_node_c, nb_cont_zone
    aster_logical :: l_cont_disc
    integer :: zeven, ztaco
    character(len=24) :: sdcont_evenco
    real(kind=8), pointer :: v_sdcont_evenco(:) => null()
    character(len=24) :: sdcont_evenpe
    real(kind=8), pointer :: v_sdcont_evenpe(:) => null()
    character(len=24) :: sdcont_jsupco
    real(kind=8), pointer :: v_sdcont_jsupco(:) => null()
    character(len=24) :: sdcont_tabcof
    real(kind=8), pointer :: v_sdcont_tabcof(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','CONTACT5_3')
    endif
!
! - Get parameters
!
    l_cont_disc    = cfdisl(ds_contact%sdcont_defi,'FORMUL_DISCRETE')
    nb_cont_poin   = cfdisi(ds_contact%sdcont_defi,'NTPC' )
    nb_cont_node_c = cfdisi(ds_contact%sdcont_defi,'NTNOEC')
    nb_cont_zone   = cfdisi(ds_contact%sdcont_defi,'NZOCO' )
    zeven          = cfmmvd('ZEVEN')
    ztaco          = cfmmvd('ZTACO')
!
! - Create datastructure for user's gaps
!
    sdcont_jsupco = ds_contact%sdcont_solv(1:14)//'.JSUPCO'
    call wkvect(sdcont_jsupco, 'V V R', nb_cont_poin, vr = v_sdcont_jsupco)
!
! - Create datastructure for event-driven management
!
    sdcont_evenco = ds_contact%sdcont_solv(1:14)//'.EVENCO'
    call wkvect(sdcont_evenco, 'V V R', zeven*nb_cont_poin, vr = v_sdcont_evenco)
    sdcont_evenpe = ds_contact%sdcont_solv(1:14)//'.EVENPE'
    call wkvect(sdcont_evenpe, 'V V R', 3*nb_cont_zone    , vr = v_sdcont_evenpe)
!
! - Print
!
    call utmess('I', 'CONTACT5_8', si=nb_cont_node_c)
!
! - Create datastructure for coefficients
! 
    sdcont_tabcof = ds_contact%sdcont_solv(1:14)//'.TABL.COEF'
    call wkvect(sdcont_tabcof, 'V V R', nb_cont_zone*ztaco, vr = v_sdcont_tabcof)
!
! - Fill datastructure for coefficients
!
    if (l_cont_disc) then
        call cfmmci(ds_contact)
    endif
!
end subroutine
