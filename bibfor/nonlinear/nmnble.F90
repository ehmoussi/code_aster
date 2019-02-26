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
subroutine nmnble(mesh     , model    , list_func_acti, sddisc    , nume_inst ,&
                  sddyna   , sdnume   , nume_dof      , ds_measure, ds_contact,&
                  hval_incr, hval_algo)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisl.h"
#include "asterfort/copisd.h"
#include "asterfort/dismoi.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmctce.h"
#include "asterfort/nmctcl.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmtime.h"
#include "asterfort/utmess.h"
#include "asterfort/infdbg.h"
#include "asterfort/nonlinInitDisp.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: model, nume_dof
type(NL_DS_Contact), intent(in) :: ds_contact
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: sddyna, sddisc, sdnume
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
integer, intent(in) :: nume_inst
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algo
!
! External loop management - Initializations for new loop
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  mesh             : name of mesh
! IO  ds_contact       : datastructure for contact management
! In  list_func_acti   : list of active functionnalities
! IO  ds_measure       : datastructure for measure and statistics management
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! In  sddyna           : datastructure for dynamic
! In  sdnume           : datastructure for dof positions
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_all_verif, l_cont_elem, l_dyna
    character(len=19) :: vite_curr, acce_curr
    character(len=19) :: vite_init, acce_init
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
!
! - Active functionnalities
!
    l_cont_elem = isfonc(list_func_acti,'ELT_CONTACT')   
    l_dyna      = ndynlo(sddyna,'DYNAMIQUE')
!
    if (l_cont_elem) then
        l_all_verif = cfdisl(ds_contact%sdcont_defi,'ALL_VERIF')
        if (l_all_verif) then
            goto 99
        endif
! ----- Display
        if (niv .ge. 2) then
            call utmess('I', 'CONTACT5_20')
        endif
! ----- Initializations of displacements for external loop management
        call nonlinInitDisp(list_func_acti, sdnume   , nume_dof,&
                            hval_algo     , hval_incr)
!
! ----- AFIN QUE LE VECTEUR DES FORCES D'INERTIE NE SOIT PAS MODIFIE AU
! ----- COURS DE LA BOUCLE DES CONTRAINTES ACTIVES PAR L'APPEL A OP0070
! ----- ON LE DUPLIQUE ET ON UTILISE CETTE COPIE FIXE (VITINI,ACCINI)
!
        if (l_dyna) then
            call nmchex(hval_incr, 'VALINC', 'VITPLU', vite_curr)
            call nmchex(hval_incr, 'VALINC', 'ACCPLU', acce_curr)
            vite_init = ds_contact%sdcont_solv(1:14)//'.VITI'
            acce_init = ds_contact%sdcont_solv(1:14)//'.ACCI'
            call copisd('CHAMP_GD', 'V', vite_init, vite_curr)
            call copisd('CHAMP_GD', 'V', acce_init, acce_curr)
        endif
! ----- Start timer for preparation of contact
        call nmtime(ds_measure, 'Launch', 'Cont_Prep')
! ----- Create elements for contact
        call nmctcl(model, mesh, ds_contact)
! ----- Create input fields for contact
        call nmctce(model, mesh, ds_contact, sddyna, sddisc, nume_inst)
! ----- Stop timer for preparation of contact
        call nmtime(ds_measure, 'Stop', 'Cont_Prep')
        call nmrinc(ds_measure, 'Cont_Prep')
    endif
!
99  continue
!
end subroutine
