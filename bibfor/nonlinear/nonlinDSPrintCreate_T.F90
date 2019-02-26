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
subroutine nonlinDSPrintCreate_T(ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nonlinDSColumnVoid.h"
!
type(NL_DS_Print), intent(out) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! THER_NON_LINE - Print management
!
! Create printing datastructure
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_cols_defi = 10
    integer :: i_col
    type(NL_DS_Table) :: table_cvg
    type(NL_DS_Column) :: column
!
    character(len=24), parameter :: cols_name(nb_cols_defi) = (/&
                  'INCR_INST','ITER_NUME','RESI_RELA','RELA_NOEU',&
                  'RESI_MAXI','MAXI_NOEU','RELI_NBIT','RELI_COEF',&
                  'MATR_ASSE','ITER_TIME'/)
    character(len=16), parameter :: cols_title_1(nb_cols_defi) = (/&
                  '   INCREMENT    ','     NEWTON     ','     RESIDU     ','     RESIDU     ',&
                  '     RESIDU     ','     RESIDU     ','  RECH.  LINE.  ','  RECH.  LINE.  ',&
                  '     OPTION     ','     NEWTON     '/)
    character(len=16), parameter :: cols_title_2(nb_cols_defi) = (/&
                  '    INSTANT     ','    ITERATION   ','     RELATIF    ','     MAXIMUM    ',&
                  '     ABSOLU     ','     MAXIMUM    ','    NB. ITER    ','  COEFFICIENT   ',&
                  '   ASSEMBLAGE   ','  TEMPS CALCUL  '/)
    character(len=16), parameter :: cols_title_3(nb_cols_defi) = (/&
                  '                ','                ',' RESI_GLOB_RELA ','    AU POINT    ',&
                  ' RESI_GLOB_MAXI ','    AU POINT    ','                ','      RHO       ',&
                  '                ','    VALEUR      '/)
    character(len=1), parameter :: cols_type(nb_cols_defi) = (/&
                  'R','I','R','K',&
                  'R','K','I','R',&
                  'K','R'/)
!
! --------------------------------------------------------------------------------------------------
!

!
! - Set list of columns in convergence table
!
    do i_col = 1, nb_cols_defi
        call nonlinDSColumnVoid(column)
        column%name          = cols_name(i_col)(1:16)
        if (cols_type(i_col).eq.'R') then
            column%l_vale_real   = ASTER_TRUE
        elseif (cols_type(i_col).eq.'I') then
            column%l_vale_inte   = ASTER_TRUE
        elseif (cols_type(i_col).eq.'K') then
            column%l_vale_strg   = ASTER_TRUE
        else
            ASSERT(ASTER_FALSE)
        endif
        column%title(1)    = cols_title_1(i_col)
        column%title(2)    = cols_title_2(i_col)
        column%title(3)    = cols_title_3(i_col)
        table_cvg%cols(i_col)        = column
        table_cvg%l_cols_acti(i_col) = ASTER_FALSE
    end do
!
! - Checks
! 
    table_cvg%nb_cols = nb_cols_defi
    ASSERT(table_cvg%nb_cols .le. table_cvg%nb_cols_maxi)
!
! - Set convergence table
!
    ds_print%table_cvg = table_cvg
!
end subroutine
