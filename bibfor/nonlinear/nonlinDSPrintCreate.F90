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
subroutine nonlinDSPrintCreate(ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/impfoi.h"
#include "asterfort/infdbg.h"
#include "asterfort/CreateVoidColumn.h"
!
type(NL_DS_Print), intent(out) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Create printing datastructure
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_cols_defi = 30
    integer, parameter :: nb_cols_dof_defi = 9
    integer :: ifm, niv
    integer :: i_col, i_cols_dof
    character(len=1) :: indsui
    type(NL_DS_Table) :: table_cvg
    type(NL_DS_Column) :: column
!
    character(len=24), parameter :: cols_name(nb_cols_defi) = (/&
                  'INCR_INST','BOUC_HROM','BOUC_GEOM','BOUC_FROT',&
                  'BOUC_CONT','ITER_NUME','RESI_RELA',&
                  'RELA_NOEU','RESI_MAXI','MAXI_NOEU',&
                  'RESI_REFE','REFE_NOEU','RESI_COMP',&
                  'COMP_NOEU','RELI_NBIT','RELI_COEF',&
                  'PILO_COEF','MATR_ASSE','DEBORST  ',&
                  'CTCD_NBIT','CONT_NEWT','FROT_NEWT',&
                  'GEOM_NEWT','CTCC_CYCL','BOUC_VALE',&
                  'BOUC_NOEU','FROT_NOEU','GEOM_NOEU',&
                  'PENE_MAXI','ITER_TIME'/)
!
    character(len=16), parameter :: cols_title_1(nb_cols_defi) = (/&
              '   INCREMENT    ','     CALCUL     ','     CONTACT    ','     CONTACT    ',&
              '     CONTACT    ','     NEWTON     ','     RESIDU     ',&
              '     RESIDU     ','     RESIDU     ','     RESIDU     ',&
              '     RESIDU     ','     RESIDU     ',' RESI_COMP_RELA ',&
              '     RESIDU     ','  RECH.  LINE.  ','  RECH.  LINE.  ',&
              '    PILOTAGE    ','     OPTION     ','     DEBORST    ',&
              '     CONTACT    ','     CONTACT    ','     CONTACT    ',&
              '     CONTACT    ','     CONTACT    ','     CONTACT    ',&
              '     CONTACT    ','     CONTACT    ','     CONTACT    ',&
              '     CONTACT    ','     NEWTON     '/)
    character(len=16), parameter :: cols_title_2(nb_cols_defi) = (/&
              '    INSTANT     ','      HYPER     ','    BCL. GEOM.  ','    BCL. FROT.  ',&
              '    BCL. CONT.  ','    ITERATION   ','     RELATIF    ',&
              '     MAXIMUM    ','     ABSOLU     ','     MAXIMUM    ',&
              '  PAR REFERENCE ','     MAXIMUM    ',' PAR COMPOSANTE ',&
              '     MAXIMUM    ','    NB. ITER    ','  COEFFICIENT   ',&
              '  COEFFICIENT   ','   ASSEMBLAGE   ','                ',&
              '    DISCRET     ','   NEWTON GENE  ','   NEWTON GENE  ',&
              '   NEWTON GENE  ','      INFOS     ','     CRITERE    ',&
              '     CRITERE    ','   NEWTON GENE  ','   NEWTON GENE  ',&
              '  PENETRATION   ','  TEMPS CALCUL  '/)
    character(len=16), parameter :: cols_title_3(nb_cols_defi) = (/&
              '                ','      REDUIT    ','    ITERATION   ','    ITERATION   ',&
              '    ITERATION   ','                ',' RESI_GLOB_RELA ',&
              '    AU POINT    ',' RESI_GLOB_MAXI ','    AU POINT    ',&
              ' RESI_REFE_RELA ','    AU POINT    ',' RESI_COMP_RELA ',&
              '    AU POINT    ','                ','      RHO       ',&
              '      ETA       ','                ','                ',&
              '    NB. ITER    ','   VARI. CONT.  ','   CRIT. FROT.  ',&
              '   CRIT. GEOM.  ','    CYCLAGES    ','    VALEUR      ',&
              '    MAX. LIEU   ',' LIEU MAX FROT. ',' LIEU MAX GEOM. ',&
              '                ','    VALEUR      '/)
!
    character(len=1), parameter :: cols_type(nb_cols_defi) = (/&
                  'R','K','I','I',&
                  'I','I','R',&
                  'K','R','K',&
                  'R','K','R',&
                  'K','I','R',&
                  'R','K','K',&
                  'I','I','R',&
                  'R','I','R',&
                  'K','K','K',&
                  'R','R'/)
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> . Create printing management datastructure'
    endif
!
! - Set list of columns in convergence table
!
    do i_col = 1, nb_cols_defi
        call CreateVoidColumn(column)
        column%name          = cols_name(i_col)(1:16)
        if (cols_type(i_col).eq.'R') then
            column%l_vale_real   = ASTER_TRUE
        elseif (cols_type(i_col).eq.'I') then
            column%l_vale_inte   = ASTER_TRUE
        elseif (cols_type(i_col).eq.'K') then
            column%l_vale_strg   = ASTER_TRUE
        else
            ASSERT(.false.)
        endif
        column%title(1)    = cols_title_1(i_col)
        column%title(2)    = cols_title_2(i_col)
        column%title(3)    = cols_title_3(i_col)
        table_cvg%cols(i_col)        = column
        table_cvg%l_cols_acti(i_col) = ASTER_FALSE
    end do
!
! - Set list of columns for DOF monitor in convergence table
!
    i_col = nb_cols_defi
    do i_cols_dof = 1, nb_cols_dof_defi
        i_col = i_col+1
        call CreateVoidColumn(column)
        call impfoi(0, 1, i_cols_dof, indsui)
        column%name          = 'SUIVDDL'//indsui
        column%title(1)      = '   SUIVI DDL'//indsui
        table_cvg%cols(i_col)        = column
        table_cvg%l_cols_acti(i_col) = ASTER_FALSE
    end do
!
! - Checks
! 
    table_cvg%nb_cols = nb_cols_dof_defi+nb_cols_defi
    ASSERT(table_cvg%nb_cols.le.table_cvg%nb_cols_maxi)
!
! - Set convergence table
!
    ds_print%table_cvg = table_cvg
!
end subroutine
