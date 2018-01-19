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
subroutine nonlinDSPrintRead(ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/infdbg.h"
!
type(NL_DS_Print), intent(inout) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Read parameters for printing
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=16) :: keywf, repk
    aster_logical :: l_csv, l_info_resi, l_info_time
    integer :: noc, unit_csv, reac_print
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> . Read parameters for printing'
    endif
!
! - Initializations
!
    keywf       = 'AFFICHAGE'
    l_info_resi = ASTER_FALSE
    l_info_time = ASTER_FALSE
    unit_csv    = 0
    reac_print  = 1
    l_csv       = ASTER_FALSE
    repk        = 'NON'
!
! - Read parameters
!
    call getvtx(keywf, 'INFO_RESIDU', iocc=1, scal=repk, nbret=noc)
    if (noc .ne. 0) then
        l_info_resi = repk .eq. 'OUI'
    endif
    call getvtx(keywf, 'INFO_TEMPS', iocc=1, scal=repk, nbret=noc)
    if (noc .ne. 0) then
        l_info_time = repk .eq. 'OUI'
    endif
    call getvis(keywf, 'UNITE', iocc=1, scal=unit_csv, nbret=noc)
    if (noc .eq. 0) then
        l_csv = ASTER_FALSE
    else
        if (unit_csv .eq. 0) then
            l_csv = ASTER_FALSE
        else
            l_csv = ASTER_TRUE
        endif
    endif
    call getvis(keywf, 'PAS', iocc=1, scal=reac_print, nbret=noc)
    if (noc .eq. 0) then
        reac_print = 1
    endif
!
! - Save parameters
!
    ds_print%l_info_resi = l_info_resi
    ds_print%l_info_time = l_info_time
    ds_print%l_tcvg_csv  = l_csv
    ds_print%tcvg_unit   = unit_csv
    ds_print%reac_print  = reac_print
!
end subroutine
