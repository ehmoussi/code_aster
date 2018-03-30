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
subroutine cfmxpo(mesh      , model_   , ds_contact, nume_inst  , sddisc,&
                  ds_measure, hval_algo, hval_incr )
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdeco.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfmxre.h"
#include "asterfort/cfverl.h"
#include "asterfort/mmdeco.h"
#include "asterfort/mldeco.h"
#include "asterfort/xmdeco.h"
!
character(len=8), intent(in) :: mesh
character(len=*), intent(in) :: model_
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Contact), intent(inout) :: ds_contact
integer, intent(in) :: nume_inst
character(len=19), intent(in) :: sddisc
character(len=19), intent(in) :: hval_algo(*)
character(len=19), intent(in) :: hval_incr(*)
!
! --------------------------------------------------------------------------------------------------
!
! Contact
!
! Post-treatment for contact
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! IO  ds_measure       : datastructure for measure and statistics management
! IO  ds_contact       : datastructure for contact management
! In  nume_inst        : index of current time step
! In  sddisc           : datastructure for discretization
! In  hval_algo        : hat-variable for algorithms fields
! In  hval_incr        : hat-variable for incremental values fields
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_cont_cont, l_cont_disc, l_cont_xfem, l_all_verif, l_cont_lac
!
! --------------------------------------------------------------------------------------------------
!
    l_cont_cont = cfdisl(ds_contact%sdcont_defi,'FORMUL_CONTINUE')
    l_cont_disc = cfdisl(ds_contact%sdcont_defi,'FORMUL_DISCRETE')
    l_cont_xfem = cfdisl(ds_contact%sdcont_defi,'FORMUL_XFEM')
    l_cont_lac  = cfdisl(ds_contact%sdcont_defi,'FORMUL_LAC')
    l_all_verif = cfdisl(ds_contact%sdcont_defi,'ALL_VERIF') 
!
! - Time step cut management
!
    if (.not.l_all_verif) then
        if (l_cont_disc) then
            call cfdeco(ds_contact)
        else if (l_cont_cont) then
            call mmdeco(ds_contact)
        else if (l_cont_lac) then
            call mldeco(ds_contact)    
        else if (l_cont_xfem) then
            call xmdeco(ds_contact)
        endif
    endif
!
! - Check normals
!
    if (l_cont_cont .or. l_cont_disc) then
        call cfverl(ds_contact)
    endif
!
! - Save post-treatment fields for contact
!
    call cfmxre(mesh  , model_   , ds_measure, ds_contact , nume_inst,&
                sddisc, hval_algo, hval_incr )
!
end subroutine
