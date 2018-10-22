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
subroutine nonlinDSPrintInit(sdsuiv, ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ulopen.h"
#include "asterfort/utmess.h"
!
character(len=24), intent(in) :: sdsuiv
type(NL_DS_Print), intent(inout) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Initializations for printing
!
! --------------------------------------------------------------------------------------------------
!
! In  sdsuiv           : datastructure for DOF monitoring
! IO  ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_col, i_dof_monitor, nb_dof_monitor, nb_cols, i_col_name
    type(NL_DS_Table) :: table_cvg
    type(NL_DS_Column) :: col
    character(len=24) :: col_name
    character(len=1) :: indsui
    character(len=24) :: sdsuiv_info
    integer, pointer :: v_sdsuiv_info(:) => null()
    character(len=24) :: sdsuiv_titr
    character(len=16), pointer :: v_sdsuiv_titr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_9')
    endif
!
! - Get convergence table
!
    table_cvg = ds_print%table_cvg
!
! - Set convergence table
!
    table_cvg%title_height = 3
    table_cvg%l_csv        = ds_print%l_tcvg_csv
    table_cvg%unit_csv     = ds_print%tcvg_unit
    nb_cols                = table_cvg%nb_cols
!
! - Get number of columns for DOF monitoring
!
    sdsuiv_info = sdsuiv(1:14)//'     .INFO'
    call jeveuo(sdsuiv_info, 'L', vi = v_sdsuiv_info)
    nb_dof_monitor = v_sdsuiv_info(2)
    if (nb_dof_monitor .gt. 9) then
        call utmess('F', 'IMPRESSION_3', si=nb_dof_monitor)
    endif
!
! - Title of columns for DOF monitoring
!
    if (nb_dof_monitor .ne. 0) then
        sdsuiv_titr = sdsuiv(1:14)//'     .TITR'
        call jeveuo(sdsuiv_titr, 'L', vk16 = v_sdsuiv_titr)
    endif
!
! - Set list of columns for DOF monitor in convergence table
!
    do i_dof_monitor = 1, nb_dof_monitor    
!
! ----- Name of the column
!
        write(indsui,'(I1)') i_dof_monitor
        col_name        = 'SUIVDDL'//indsui
!
! ----- Look for column index
!
        i_col_name = 0
        do i_col = 1, nb_cols
            if (table_cvg%cols(i_col)%name .eq. col_name) then
                ASSERT(i_col_name.eq.0)
                i_col_name = i_col
            endif
        end do
        ASSERT(i_col_name.ne.0)
!
! ----- Set column
!
        col = table_cvg%cols(i_col_name)
        col%l_vale_real = ASTER_TRUE
        col%title(1)    = v_sdsuiv_titr(3*(i_dof_monitor-1)+1)
        col%title(2)    = v_sdsuiv_titr(3*(i_dof_monitor-1)+2)
        col%title(3)    = v_sdsuiv_titr(3*(i_dof_monitor-1)+3)
        table_cvg%cols(i_col_name)  = col
    end do
!
! - Prepare file output
!
    if (ds_print%l_tcvg_csv) then
        call ulopen(ds_print%tcvg_unit, ' ', ' ', 'NEW', 'O')
    endif
!
! - Print every step time (default)
!
    ds_print%l_print = ASTER_TRUE
!
! - Set convergence table
!
    ds_print%table_cvg = table_cvg
!
end subroutine
