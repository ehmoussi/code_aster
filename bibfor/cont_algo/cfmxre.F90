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
subroutine cfmxre(mesh  , model_   , ds_measure, ds_contact , nume_inst,&
                  sddisc, hval_algo, hval_incr )
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfmmve.h"
#include "asterfort/cfresu.h"
#include "asterfort/cfmxr0_lac.h"
#include "asterfort/cnscno.h"
#include "asterfort/diinst.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mmmcpt.h"
#include "asterfort/mmmres.h"
#include "asterfort/nmchex.h"
#include "asterfort/xmmres.h"
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
! Contact - Post-treatment
!
! All methods - Save post-treatment fields for contact
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
    aster_logical :: l_cont_cont, l_cont_disc, l_cont_xfem, l_cont_lac
    aster_logical :: l_cont_exiv, l_all_verif, l_cont_node
    character(len=19) :: disp_iter, disp_cumu_inst, disp_curr
    real(kind=8) :: time_curr, time_prev, time_incr
    character(len=19) :: prno
    character(len=8) :: model
    character(len=19) :: cnsinr, cnsper, cnoinr
    integer :: ibid
!
! --------------------------------------------------------------------------------------------------
!
    model = model_
!
! - Contact parameters
!
    l_cont_cont = cfdisl(ds_contact%sdcont_defi,'FORMUL_CONTINUE')
    l_cont_disc = cfdisl(ds_contact%sdcont_defi,'FORMUL_DISCRETE')
    l_cont_xfem = cfdisl(ds_contact%sdcont_defi,'FORMUL_XFEM')
    l_cont_lac  = cfdisl(ds_contact%sdcont_defi, 'FORMUL_LAC')
    l_cont_exiv = cfdisl(ds_contact%sdcont_defi,'EXIS_VERIF')
    l_all_verif = cfdisl(ds_contact%sdcont_defi,'ALL_VERIF') 
    l_cont_node = ds_contact%l_cont_node
!
! - Get fields name
!
    cnsinr = ds_contact%fields_cont_node
    cnoinr = ds_contact%field_cont_node
    cnsper = ds_contact%field_cont_perc
!
! - Times
!
    time_prev = diinst(sddisc,nume_inst-1)
    time_curr = diinst(sddisc,nume_inst)
    time_incr = time_curr - time_prev
!
! - Get fields
!
    call nmchex(hval_algo, 'SOLALG', 'DDEPLA', disp_iter)
    call nmchex(hval_algo, 'SOLALG', 'DEPDEL', disp_cumu_inst)
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', disp_curr)
!
! - Create fields
!
    if (.not. l_all_verif) then
!
! ----- Create fields
!
        if (l_cont_xfem) then
            call xmmres(disp_cumu_inst, model, cnsinr, ds_contact)
        else if (l_cont_cont) then
            if (l_cont_node) then
                call mmmres(mesh  , time_incr, ds_contact, disp_cumu_inst, sddisc,&
                            cnsinr, cnsper)
                call mmmcpt(mesh, ds_measure, ds_contact, cnsinr)
            endif
        else if (l_cont_disc) then
            call cfresu(time_incr, sddisc, ds_contact, disp_cumu_inst, disp_iter,&
                        cnsinr   , cnsper)
        else if (l_cont_lac) then   
            call cfmxr0_lac(mesh, ds_contact, ds_measure)
        else
            ASSERT(ASTER_FALSE)
        endif
    endif
!
! - Create fields - No-computed contact
!
    if (l_cont_exiv) then
        call cfmmve(mesh, ds_contact, hval_incr, time_curr)
    endif
!
! - Transform CHAM_NO_S field
!
    if (.not. l_cont_lac) then
        call dismoi('PROF_CHNO', cnoinr, 'CHAM_NO', repk=prno, arret='C')
        call cnscno(cnsinr, prno, 'NON', 'V', cnoinr, 'F', ibid)
    endif
!
end subroutine
