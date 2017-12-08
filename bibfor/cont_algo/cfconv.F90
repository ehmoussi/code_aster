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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine cfconv(mesh      , ds_measure, sderro, hval_algo, ds_print,&
                  ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/cfcgeo.h"
#include "asterfort/cfdisl.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmimci.h"
#include "asterfort/nmimck.h"
#include "asterfort/nmimcr.h"
#include "asterfort/nmlecv.h"
#include "asterfort/nmrvai.h"
#include "asterfort/mmbouc.h"
#include "asterfort/nmcrel.h"
!
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: sderro
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: hval_algo(*)
type(NL_DS_Print), intent(inout) :: ds_print
type(NL_DS_Contact), intent(inout) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Discrete methods - Evaluate convergence
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  sderro           : datastructure for errors during algorithm
! IO  ds_measure       : datastructure for measure and statistics management
! In  hval_algo        : hat-variable for algorithms fields
! IO  ds_print         : datastructure for printing parameters
! IO  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: loop_geom_node
    integer :: nb_cont_iter
    real(kind=8) :: loop_geom_vale
    aster_logical :: l_resi_conv
    aster_logical :: l_all_verif, l_eval_geom, loop_geom_error
!
! --------------------------------------------------------------------------------------------------
!
    l_eval_geom    = .false.
    loop_geom_node = ' '
    loop_geom_vale = r8vide()
    nb_cont_iter = 0
!
! - Get contact parameters
!
    l_all_verif = cfdisl(ds_contact%sdcont_defi,'ALL_VERIF')
    call nmrvai(ds_measure, 'Cont_Algo', phasis = 'N', input_count = nb_cont_iter)
!
! - Values in convergence table: not affected
!
    call nmimck(ds_print, 'BOUC_NOEU', ' ' , .false._1)
    call nmimcr(ds_print, 'BOUC_VALE', 0.d0, .false._1)
!
! - Residuals have converged ?
!
    call nmlecv(sderro, 'RESI', l_resi_conv)
!
! - Evaluate convvergence
!
    if (.not.l_all_verif) then
!
! ----- Evaluate geometry loop
!
        l_eval_geom = .false.
        if (l_resi_conv) then
            call cfcgeo(mesh, hval_algo, ds_contact)
            l_eval_geom = .true.
            call mmbouc(ds_contact, 'Geom', 'Is_Error', loop_state_ = loop_geom_error)
            call nmcrel(sderro, 'ERRE_CTD1', loop_geom_error)
        endif
    endif
!
! - Set values in convergence table for contact geometry informations
!
    if (l_eval_geom) then
        call mmbouc(ds_contact, 'Geom', 'Get_Locus', loop_locus_ = loop_geom_node)
        call mmbouc(ds_contact, 'Geom', 'Get_Vale' , loop_vale_  = loop_geom_vale)
        call nmimck(ds_print, 'BOUC_NOEU', loop_geom_node, .true._1)
        call nmimcr(ds_print, 'BOUC_VALE', loop_geom_vale, .true._1)
    endif
    call nmimci(ds_print, 'CTCD_NBIT', nb_cont_iter, .true._1)
!
end subroutine
