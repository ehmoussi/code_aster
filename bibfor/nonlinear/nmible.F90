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
subroutine nmible(loop_exte     , model     , mesh      , ds_contact,&
                  list_func_acti, ds_measure, ds_print  , ds_algorom)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisl.h"
#include "asterfort/isfonc.h"
#include "asterfort/mmbouc.h"
#include "asterfort/nmctcg.h"
#include "asterfort/nmimci.h"
#include "asterfort/nmimck.h"
!
integer, intent(inout) :: loop_exte
character(len=24), intent(in) :: model
character(len=8), intent(in) :: mesh
type(NL_DS_Contact), intent(inout) :: ds_contact
integer, intent(in):: list_func_acti(*)
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Print), intent(inout) :: ds_print
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algo
!
! External loop management - BEGIN
!
! --------------------------------------------------------------------------------------------------
!
! IO  loop_exte        : level of external loop (see nmtble.F90)
!                        0 - Not use (not contact)
!                        1 - Loop for contact status
!                        2 - Loop for friction triggers
!                        3 - Loop for geometry
!                       10 - External loop for HROM
! In  model            : name of model
! In  mesh             : name of mesh
! IO  ds_contact       : datastructure for contact management
! In  list_func_acti   : list of active functionnalities
! IO  ds_measure       : datastructure for measure and statistics management
! IO  ds_print         : datastructure for printing parameters
! In  ds_algorom       : datastructure for ROM parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: loop_geom_count, loop_cont_count, loop_fric_count
    aster_logical :: l_loop_frot, l_loop_geom, l_loop_cont
    aster_logical :: l_pair, l_geom_sans
!
! --------------------------------------------------------------------------------------------------
!
    if ((loop_exte .ge. 1) .and. (loop_exte .le. 3)) then       
!
! ----- Print geometric loop iteration
!
        call mmbouc(ds_contact, 'Geom', 'Read_Counter', loop_geom_count)
        call nmimci(ds_print  , 'BOUC_GEOM', loop_geom_count, .true._1)
!
! ----- Update pairing ?
!
        l_geom_sans = cfdisl(ds_contact%sdcont_defi, 'REAC_GEOM_SANS')
        l_pair      = (loop_geom_count .gt. 1) .and. (.not.l_geom_sans)
!
! ----- Contact loops
!
        l_loop_frot = isfonc(list_func_acti, 'BOUCLE_EXT_FROT')
        l_loop_geom = isfonc(list_func_acti, 'BOUCLE_EXT_GEOM')
        l_loop_cont = isfonc(list_func_acti, 'BOUCLE_EXT_CONT')
!
! ----- <3 - BEGIN> - Geometric loop
!
        if (loop_exte .ge. 3) then
            if (l_loop_geom) then
                loop_exte = 3
                if (l_pair) then
                    call nmctcg(model, mesh, ds_contact, ds_measure)
                endif
            endif
            call mmbouc(ds_contact, 'Fric', 'Init_Counter')
            call mmbouc(ds_contact, 'Fric', 'Incr_Counter')
            call mmbouc(ds_contact, 'Fric', 'Read_Counter', loop_fric_count)
            call nmimci(ds_print  , 'BOUC_FROT', loop_fric_count, .true._1)
        endif
!
! ----- <2> - Friction loop
!
        if (loop_exte .ge. 2) then
            if (l_loop_frot) then
                loop_exte = 2
            endif
            call mmbouc(ds_contact, 'Cont', 'Init_Counter')
            call mmbouc(ds_contact, 'Cont', 'Incr_Counter')
            call mmbouc(ds_contact, 'Cont', 'Read_Counter', loop_cont_count)
            call nmimci(ds_print  , 'BOUC_CONT', loop_cont_count, .true._1)
        endif
!
! ----- <1> - Contact loop
!
        if (loop_exte .ge. 1) then
            if (l_loop_cont) then
                loop_exte = 1
            endif
        endif

    elseif (loop_exte .eq. 10) then
        if (ds_algorom%phase .eq. 'HROM') then
            call nmimck(ds_print, 'BOUC_HROM', '  HROM', .true._1)
        else if (ds_algorom%phase .eq. 'CORR_EF') then
            call nmimck(ds_print, 'BOUC_HROM', '  CORRECTION EF', .true._1)
        endif
    endif
!
end subroutine
