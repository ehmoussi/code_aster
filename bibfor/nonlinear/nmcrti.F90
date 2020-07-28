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
! aslint: disable=W1303
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmcrti(list_func_acti, resultName, ds_contact, ds_measure)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/cfdisl.h"
#include "asterfort/isfonc.h"
#include "asterfort/ulopen.h"
#include "asterfort/uttcpu.h"
#include "asterfort/utmess.h"
#include "asterfort/nonlinDSColumnWriteValue.h"
#include "asterfort/ActivateDevice.h"
#include "asterfort/nonlinDSTableIOCreate.h"
#include "asterfort/nonlinDSTableIOSetPara.h"
#include "asterfort/nonlinDSTableIOGetName.h"
#include "asterfort/SetTableColumn.h"
#include "asterfort/ComputeTableHead.h"
#include "asterfort/ComputeTableWidth.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=8), intent(in) :: resultName
type(NL_DS_Contact), intent(in) :: ds_contact
type(NL_DS_Measure), intent(inout) :: ds_measure
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Measure and statistics management
!
! Initializations for measure and statistics management
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  resultName       : name of results datastructure
! In  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_timer, nb_timer, i_device, i_col, line_width, nb_cols_active
    character(len=24) :: cpu_name
    character(len=512) :: table_head(3)
    aster_logical :: l_line_search
    aster_logical :: l_cont, l_fric, l_cont_disc, l_cont_cont,l_cont_lac
    aster_logical :: l_loop_cont, l_loop_fric, l_loop_geom, l_newt_geom
    aster_logical :: l_all_verif, l_device_acti, l_hho
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_5')
    endif
!
! - Get active functionnalities
!
    l_all_verif   = .false.
    l_fric        = .false.
    l_line_search = isfonc(list_func_acti,'RECH_LINE')
    l_cont        = isfonc(list_func_acti, 'CONTACT' )
    l_cont_disc   = isfonc(list_func_acti, 'CONT_DISCRET')
    l_cont_cont   = isfonc(list_func_acti, 'CONT_CONTINU')
    l_cont_lac    = isfonc(list_func_acti, 'CONT_LAC')
    l_loop_cont   = isfonc(list_func_acti, 'BOUCLE_EXT_CONT')
    l_loop_fric   = isfonc(list_func_acti, 'BOUCLE_EXT_FROT')
    l_loop_geom   = isfonc(list_func_acti, 'BOUCLE_EXT_GEOM')
    l_newt_geom   = isfonc(list_func_acti, 'GEOM_NEWTON')
    l_hho         = isfonc(list_func_acti, 'HHO' )
    if (l_cont) then
        l_all_verif = cfdisl(ds_contact%sdcont_defi, 'ALL_VERIF')
        l_fric      = cfdisl(ds_contact%sdcont_defi, 'FROTTEMENT')
    endif
!
! - Activate devices (standard)
!
    call ActivateDevice(ds_measure, 'Compute')
    call ActivateDevice(ds_measure, 'Time_Step')
    call ActivateDevice(ds_measure, 'Newt_Iter')
    call ActivateDevice(ds_measure, 'Integrate')
    call ActivateDevice(ds_measure, 'Matr_Asse')
    call ActivateDevice(ds_measure, 'Factor')
    call ActivateDevice(ds_measure, '2nd_Member')
    call ActivateDevice(ds_measure, 'Solve')
    call ActivateDevice(ds_measure, 'Store')
    call ActivateDevice(ds_measure, 'Post')
    call ActivateDevice(ds_measure, 'Lost_Time')
    call ActivateDevice(ds_measure, 'Other')
    if (l_line_search) then
        call ActivateDevice(ds_measure, 'LineSearch')
    endif
    if (l_hho) then
        call ActivateDevice(ds_measure, 'HHO_Cond')
        call ActivateDevice(ds_measure, 'HHO_Comb')
        call ActivateDevice(ds_measure, 'HHO_Prep')
    end if
!
! - Activate devices for contact (10)
!
    if (l_cont .and. (.not.l_all_verif)) then
        call ActivateDevice(ds_measure, 'Cont_NCont')
        if (l_fric) then
            call ActivateDevice(ds_measure, 'Cont_NFric')
        endif
        if (l_loop_geom .or. l_newt_geom) then
            call ActivateDevice(ds_measure, 'Cont_Geom')
        endif
        if (l_cont_disc) then
            call ActivateDevice(ds_measure, 'Cont_Algo')
        endif
        if (l_cont_cont .or. l_cont_lac) then
            call ActivateDevice(ds_measure, 'Cont_Prep')
            call ActivateDevice(ds_measure, 'Cont_Elem')
            call ActivateDevice(ds_measure, 'Cont_Cycl1')
            call ActivateDevice(ds_measure, 'Cont_Cycl2')
            call ActivateDevice(ds_measure, 'Cont_Cycl3')
            call ActivateDevice(ds_measure, 'Cont_Cycl4')
        endif
    endif
!
! - Reset all timers
!
    nb_timer  = ds_measure%nb_timer
    do i_timer = 1, nb_timer
        cpu_name  = ds_measure%timer(i_timer)%cpu_name
        call uttcpu(cpu_name, 'INIT', ' ')
        ds_measure%timer(i_timer)%time_init = 0.d0
    end do
!
! - Create table
!
    if (ds_measure%l_table .or. ds_measure%table%l_csv) then

! ----- First column: time
        i_col = 1
        ds_measure%table%l_cols_acti(i_col) = .true._1
        ASSERT(ds_measure%table%cols(i_col)%name(1:4) .eq. 'INST')

! ----- Loop on active devices to activate columns
        do i_device = 1, ds_measure%nb_device
            l_device_acti = ds_measure%l_device_acti(i_device)
            if (l_device_acti) then
                i_col = ds_measure%indx_cols(2*(i_device-1)+1)
                if (i_col .ne. 0) then
                    ds_measure%table%l_cols_acti(i_col) = .true._1
                    ASSERT(ds_measure%table%cols(i_col)%name(1:5) .eq. 'Time_')
                endif
                i_col = ds_measure%indx_cols(2*(i_device-1)+2)
                if (i_col .ne. 0) then
                    ds_measure%table%l_cols_acti(i_col) = .true._1
                    ASSERT(ds_measure%table%cols(i_col)%name(1:6) .eq. 'Count_')
                endif
            endif
        end do

! ----- Activate state and memory
        if (ds_measure%table%l_csv) then
            call SetTableColumn(ds_measure%table, 'State' , flag_acti_ = .true._1)
            call SetTableColumn(ds_measure%table, 'Memory' , flag_acti_ = .true._1)
        endif

! ----- Create list of parameters
        call nonlinDSTableIOSetPara(ds_measure%table)

! ----- Set other parameters
        ds_measure%table%table_io%resultName   = resultName
        ds_measure%table%table_io%tablSymbName = 'STAT'

! ----- Get name of table in results datastructure
        call nonlinDSTableIOGetName(ds_measure%table%table_io)

! ----- Create table in results datastructure
        call nonlinDSTableIOCreate(ds_measure%table%table_io)

! ----- Prepare table in output CSV file
        call ComputeTableWidth(ds_measure%table, line_width, nb_cols_active)
        ds_measure%table%width = line_width

! ----- Print table head in output CSV file
        if (ds_measure%table%l_csv) then
            call ulopen(ds_measure%table%unit_csv, ' ', ' ', 'NEW', 'O')
            call ComputeTableHead(ds_measure%table, ',', table_head)
            call nonlinDSColumnWriteValue(ds_measure%table%width,&
                                          output_unit_ = ds_measure%table%unit_csv,&
                                          value_k_     = table_head(1) )
            call nonlinDSColumnWriteValue(ds_measure%table%width,&
                                          output_unit_ = ds_measure%table%unit_csv,&
                                          value_k_     = table_head(2) )
        endif

    endif
!
end subroutine
