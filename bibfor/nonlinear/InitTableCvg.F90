! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine InitTableCvg(list_func_acti, sdsuiv, ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/SetTableColumn.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=24), intent(in) :: sdsuiv
type(NL_DS_Print), intent(inout) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Initializations for convergence table
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  sdsuiv           : datastructure for DOF monitoring
! IO  ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_dof_monitor, nb_dof_monitor
    type(NL_DS_Table) :: table_cvg
    aster_logical :: l_line_search, l_pilo, l_cont_disc, l_cont_cont, l_hrom, l_rom
    aster_logical :: l_deborst, l_refe_rela, l_comp_rela
    aster_logical :: l_loop_cont, l_loop_frot, l_loop_geom, l_cont_all_verif
    aster_logical :: l_newt_frot, l_newt_cont, l_newt_geom
    aster_logical :: l_info_resi
    aster_logical :: l_pena_cont
    character(len=1) :: indsui
    character(len=24) :: col_name
    character(len=512) :: sep_line
    character(len=24) :: sdsuiv_info
    integer, pointer :: v_sdsuiv_info(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    sep_line = ' '
!
! - Get convergence table
!
    table_cvg   = ds_print%table_cvg
!
! - Get parameters
!
    l_info_resi = ds_print%l_info_resi
!
! - Active functionnalities
!
    l_line_search    = isfonc(list_func_acti,'RECH_LINE')
    l_pilo           = isfonc(list_func_acti,'PILOTAGE')
    l_cont_disc      = isfonc(list_func_acti,'CONT_DISCRET')
    l_cont_cont      = isfonc(list_func_acti,'CONT_CONTINU')
    l_refe_rela      = isfonc(list_func_acti,'RESI_REFE')
    l_deborst        = isfonc(list_func_acti,'DEBORST')
    l_loop_frot      = isfonc(list_func_acti,'BOUCLE_EXT_FROT')
    l_loop_geom      = isfonc(list_func_acti,'BOUCLE_EXT_GEOM')
    l_loop_cont      = isfonc(list_func_acti,'BOUCLE_EXT_CONT')
    l_newt_frot      = isfonc(list_func_acti,'FROT_NEWTON')
    l_newt_cont      = isfonc(list_func_acti,'CONT_NEWTON')
    l_newt_geom      = isfonc(list_func_acti,'GEOM_NEWTON')
    l_comp_rela      = isfonc(list_func_acti,'RESI_COMP')
    l_cont_all_verif = isfonc(list_func_acti,'CONT_ALL_VERIF')
    l_rom            = isfonc(list_func_acti,'ROM')
    l_hrom           = isfonc(list_func_acti,'HROM')
    l_pena_cont      = isfonc(list_func_acti,'EXIS_PENA')
!
! - No cols activated
!
    call SetTableColumn(table_cvg, flag_acti_ = ASTER_FALSE)
!
! - Newton iterations
!
    call SetTableColumn(table_cvg, name_ = 'ITER_NUME', flag_acti_ = ASTER_TRUE)
!
! - RESI_GLOB_RELA
!
    call SetTableColumn(table_cvg, name_ = 'RESI_RELA', flag_acti_ = ASTER_TRUE)
    if (l_info_resi) then
        call SetTableColumn(table_cvg, name_ = 'RELA_NOEU', flag_acti_ = ASTER_TRUE)
    endif
!
! - RESI_GLOB_MAXI
!
    call SetTableColumn(table_cvg, name_ = 'RESI_MAXI', flag_acti_ = ASTER_TRUE)
    if (l_info_resi) then
        call SetTableColumn(table_cvg, name_ = 'MAXI_NOEU', flag_acti_ = ASTER_TRUE)
    endif
!
! - RESI_REFE_RELA
!
    if (l_refe_rela) then
        call SetTableColumn(table_cvg, name_ = 'RESI_REFE', flag_acti_ = ASTER_TRUE)
        if (l_info_resi) then
            call SetTableColumn(table_cvg, name_ = 'REFE_NOEU', flag_acti_ = ASTER_TRUE)
        endif
    endif
!
! - RESI_COMP_RELA
!
    if (l_comp_rela) then
        call SetTableColumn(table_cvg, name_ = 'RESI_COMP', flag_acti_ = ASTER_TRUE)
        if (l_info_resi) then
            call SetTableColumn(table_cvg, name_ = 'COMP_NOEU', flag_acti_ = ASTER_TRUE)
        endif
    endif
!
! - Contact
!
    if (l_loop_geom) then
        call SetTableColumn(table_cvg, name_ = 'BOUC_GEOM', flag_acti_ = ASTER_TRUE)
    endif
    if (l_loop_frot) then
        call SetTableColumn(table_cvg, name_ = 'BOUC_FROT', flag_acti_ = ASTER_TRUE)
    endif
    if (l_loop_cont) then
        call SetTableColumn(table_cvg, name_ = 'BOUC_CONT', flag_acti_ = ASTER_TRUE)
    endif
    if (l_cont_disc .and. (.not.l_cont_all_verif)) then
        call SetTableColumn(table_cvg, name_ = 'CTCD_NBIT', flag_acti_ = ASTER_TRUE)
    endif
    if (l_cont_cont .and. (.not.l_cont_all_verif)) then
        call SetTableColumn(table_cvg, name_ = 'CTCC_CYCL', flag_acti_ = ASTER_TRUE)
    endif
!
! - Contact (generalized Newton)
!
    if (l_newt_geom) then
        call SetTableColumn(table_cvg, name_ = 'GEOM_NEWT', flag_acti_ = ASTER_TRUE)
        if (l_info_resi) then
            call SetTableColumn(table_cvg, name_ = 'GEOM_NOEU', flag_acti_ = ASTER_TRUE)
        endif
    endif
    if (l_newt_frot) then
        call SetTableColumn(table_cvg, name_ = 'FROT_NEWT', flag_acti_ = ASTER_TRUE)
        if (l_info_resi) then
            call SetTableColumn(table_cvg, name_ = 'FROT_NOEU', flag_acti_ = ASTER_TRUE)
        endif
    endif
    if (l_newt_cont .and. (.not.l_cont_all_verif)) then
        call SetTableColumn(table_cvg, name_ = 'CONT_NEWT', flag_acti_ = ASTER_TRUE)
    endif
    
    if (l_pena_cont) then
        call SetTableColumn(table_cvg, name_ = 'PENE_MAXI', flag_acti_ = ASTER_TRUE)
    endif
!
! - Contact (fixed points)
!
    if (l_loop_geom .or. l_loop_frot .or. l_loop_cont) then
        call SetTableColumn(table_cvg, name_ = 'BOUC_VALE', flag_acti_ = ASTER_TRUE)
        if (l_info_resi) then
            call SetTableColumn(table_cvg, name_ = 'BOUC_NOEU', flag_acti_ = ASTER_TRUE)
        endif
    endif
!
! - DE BORST method (stress planes)
!
    if (l_deborst) then
        call SetTableColumn(table_cvg, name_ = 'DEBORST  ', flag_acti_ = ASTER_TRUE)
    endif
!
! - Line search
!
    if (l_line_search) then
        call SetTableColumn(table_cvg, name_ = 'RELI_NBIT', flag_acti_ = ASTER_TRUE)
        call SetTableColumn(table_cvg, name_ = 'RELI_COEF', flag_acti_ = ASTER_TRUE)
    endif
!
! - Pilotage (continuation methods)
!
    if (l_pilo) then
        call SetTableColumn(table_cvg, name_ = 'PILO_COEF', flag_acti_ = ASTER_TRUE)
    endif
!
! - Matrix option
!
    call SetTableColumn(table_cvg, name_ = 'MATR_ASSE', flag_acti_ = ASTER_TRUE)
!
! - Hyper-reduction
!
    if (l_hrom) then
        call SetTableColumn(table_cvg, name_ = 'BOUC_HROM', flag_acti_ = ASTER_TRUE)
    endif
!
! - ROM error indicator
!
    if (l_rom .and. .not. l_hrom) then
        call SetTableColumn(table_cvg, name_ = 'EREF_ROM ', flag_acti_ = ASTER_TRUE)
    endif
!
! - For DOF monitoring
!
    sdsuiv_info = sdsuiv(1:14)//'     .INFO'
    call jeveuo(sdsuiv_info, 'L', vi = v_sdsuiv_info)
    nb_dof_monitor = v_sdsuiv_info(2)
    do i_dof_monitor = 1, nb_dof_monitor
        write(indsui,'(I1)') i_dof_monitor
        col_name        = 'SUIVDDL'//indsui
        call SetTableColumn(table_cvg, name_ = col_name, flag_acti_ = ASTER_TRUE)
    end do
!
! - Set convergence table
!
    ds_print%table_cvg = table_cvg
!
end subroutine
