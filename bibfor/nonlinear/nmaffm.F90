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

subroutine nmaffm(sderro, ds_print, loop_name)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmerge.h"
#include "asterfort/SetTableColumn.h"
#include "asterfort/nmlecv.h"
#include "asterfort/nmltev.h"
#include "asterfort/nmimck.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: sderro
    type(NL_DS_Print), intent(inout) :: ds_print
    character(len=4), intent(in) :: loop_name
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Set marks in cols
!
! --------------------------------------------------------------------------------------------------
!
! In  sderro           : name of datastructure for error management (events)
! IO  ds_print         : datastructure for printing parameters
! In  loop_name        : name of current loop
!               'RESI' - Loop on residuals
!               'NEWT' - Newton loop
!               'FIXE' - Fixed points loop
!               'INST' - Step time loop
!               'CALC' - Computation
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: dvrela, dvmaxi, dvrefe, dvcomp
    aster_logical :: dvfixc, dvfixf, dvfixg, dvfrot, dvcont, dvgeom
    aster_logical :: dvdebo, cvpilo
    aster_logical :: cvnewt, lerrne
    aster_logical :: erctcg, erctcf, erctcc
    character(len=16) :: debors
    type(NL_DS_Table) :: table_cvg
!
! --------------------------------------------------------------------------------------------------
!
!
! - Get convergence table
!
    table_cvg = ds_print%table_cvg
!
! - Get events
!
    debors = ' DE BORST...    '
    call nmerge(sderro, 'DIVE_CTCC', dvcont)
    call nmerge(sderro, 'DIVE_DEBO', dvdebo)
    call nmerge(sderro, 'DIVE_RELA', dvrela)
    call nmerge(sderro, 'DIVE_MAXI', dvmaxi)
    call nmerge(sderro, 'DIVE_REFE', dvrefe)
    call nmerge(sderro, 'DIVE_COMP', dvcomp)
    call nmerge(sderro, 'DIVE_FROT', dvfrot)
    call nmerge(sderro, 'DIVE_GEOM', dvgeom)
    call nmerge(sderro, 'DIVE_FIXG', dvfixg)
    call nmerge(sderro, 'DIVE_FIXF', dvfixf)
    call nmerge(sderro, 'DIVE_FIXC', dvfixc)
    call nmerge(sderro, 'CONV_PILO', cvpilo)
    call nmlecv(sderro, 'NEWT', cvnewt)
    call nmltev(sderro, 'ERRI', 'NEWT', lerrne)
    call nmerge(sderro, 'ERRE_CTCG', erctcg)
    call nmerge(sderro, 'ERRE_CTCF', erctcf)
    call nmerge(sderro, 'ERRE_CTCC', erctcc)
!
! - Set marks in cols
!
    if (loop_name .eq. 'NEWT') then
        call SetTableColumn(table_cvg, name_ = 'RESI_RELA', mark_ = ' ')
        call SetTableColumn(table_cvg, name_ = 'RESI_RELA', mark_ = ' ')
        call SetTableColumn(table_cvg, name_ = 'RESI_MAXI', mark_ = ' ')
        call SetTableColumn(table_cvg, name_ = 'RESI_REFE', mark_ = ' ')
        call SetTableColumn(table_cvg, name_ = 'RESI_COMP', mark_ = ' ')
        if (dvrela) then
            call SetTableColumn(table_cvg, name_ = 'RESI_RELA', mark_ = 'X')
        endif
        if (dvmaxi) then
            call SetTableColumn(table_cvg, name_ = 'RESI_MAXI', mark_ = 'X')
        endif
        if (dvrefe) then
            call SetTableColumn(table_cvg, name_ = 'RESI_REFE', mark_ = 'X')
        endif
        if (dvcomp) then
            call SetTableColumn(table_cvg, name_ = 'RESI_COMP', mark_ = 'X')
        endif
        call SetTableColumn(table_cvg, name_ = 'GEOM_NEWT', mark_ = ' ')
        call SetTableColumn(table_cvg, name_ = 'FROT_NEWT', mark_ = ' ')
        call SetTableColumn(table_cvg, name_ = 'CONT_NEWT', mark_ = ' ')
        call SetTableColumn(table_cvg, name_ = 'PILO_COEF', mark_ = ' ')
        call SetTableColumn(table_cvg, name_ = 'CTCD_NBIT', mark_ = ' ')
        if (dvgeom) then
            call SetTableColumn(table_cvg, name_ = 'GEOM_NEWT', mark_ = 'X')
        endif
        if (dvfrot) then
            call SetTableColumn(table_cvg, name_ = 'FROT_NEWT', mark_ = 'X')
        endif
        if (dvcont) then
            call SetTableColumn(table_cvg, name_ = 'CONT_NEWT', mark_ = 'X')
        endif
        if (cvpilo) then
            call SetTableColumn(table_cvg, name_ = 'PILO_COEF', mark_ = 'B')
        endif
        call SetTableColumn(table_cvg, name_ = 'ITER_NUME', mark_ = 'X')
        if (cvnewt) then
            call SetTableColumn(table_cvg, name_ = 'ITER_NUME', mark_ = ' ')
        endif
        if (lerrne) then
            call SetTableColumn(table_cvg, name_ = 'ITER_NUME', mark_ = 'E')
        endif
        call SetTableColumn(table_cvg, name_ = 'BOUC_GEOM', mark_ = 'X')
        call SetTableColumn(table_cvg, name_ = 'BOUC_FROT', mark_ = 'X')
        call SetTableColumn(table_cvg, name_ = 'BOUC_CONT', mark_ = 'X')
        if (dvdebo) then
            call nmimck(ds_print, 'DEBORST  ', debors, .true._1)
        endif
    else if (loop_name.eq.'FIXE') then
        call SetTableColumn(table_cvg, name_ = 'BOUC_GEOM', mark_ = 'X')
        call SetTableColumn(table_cvg, name_ = 'BOUC_FROT', mark_ = 'X')
        call SetTableColumn(table_cvg, name_ = 'BOUC_CONT', mark_ = 'X')
        if (.not.dvfixg) then
            call SetTableColumn(table_cvg, name_ = 'BOUC_GEOM', mark_ = ' ')
        endif
        if (.not.dvfixf) then
            call SetTableColumn(table_cvg, name_ = 'BOUC_FROT', mark_ = ' ')
        endif
        if (.not.dvfixc) then
            call SetTableColumn(table_cvg, name_ = 'BOUC_CONT', mark_ = ' ')
        endif
        if (dvfixc) then
            call SetTableColumn(table_cvg, name_ = 'BOUC_GEOM', mark_ = 'X')
            call SetTableColumn(table_cvg, name_ = 'BOUC_FROT', mark_ = 'X')
        endif
        if (dvfixf) then
            call SetTableColumn(table_cvg, name_ = 'BOUC_GEOM', mark_ = 'X')
        endif
        if (erctcg) then
            call SetTableColumn(table_cvg, name_ = 'BOUC_GEOM', mark_ = 'E')
        endif
        if (erctcf) then
            call SetTableColumn(table_cvg, name_ = 'BOUC_FROT', mark_ = 'E')
        endif
        if (erctcc) then
            call SetTableColumn(table_cvg, name_ = 'BOUC_CONT', mark_ = 'E')
        endif
    endif
!
! - Set convergence table
!
    ds_print%table_cvg = table_cvg
!
end subroutine
