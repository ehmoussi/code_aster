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
subroutine nonlinDSMeasureRead(ds_measure)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
!
type(NL_DS_Measure), intent(inout) :: ds_measure
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Contact management
!
! Read parameters for measure and statistics management
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_measure       : datastructure for measure and statistics management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=16) :: keywfact, answer
    aster_logical :: l_csv, l_table
    integer :: unit_csv, noc
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> . Read parameters for measure and statistics management'
    endif
!
! - Initializations
!
    keywfact = 'MESURE'
    unit_csv = 0
    l_table  = ASTER_FALSE
    l_csv    = ASTER_FALSE
!
! - Read parameters
!
    call getvtx(keywfact, 'TABLE', iocc=1, scal=answer)
    l_table = answer.eq.'OUI'
    call getvis(keywfact, 'UNITE', iocc=1, scal=unit_csv, nbret=noc)
    if (noc .eq. 0) then
        l_csv = ASTER_FALSE
    else
        if (unit_csv .eq. 0) then
            l_csv = ASTER_FALSE
        else
            l_csv = ASTER_TRUE
        endif
    endif
!
! - Save parameters
!
    ds_measure%l_table        = l_table
    ds_measure%table%l_csv    = l_csv
    ds_measure%table%unit_csv = unit_csv
!
end subroutine
