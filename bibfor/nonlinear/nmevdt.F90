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

subroutine nmevdt(ds_measure, sderro, timer)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/etausr.h"
#include "asterfort/asmpi_comm_vect.h"
#include "asterfort/assert.h"
#include "asterfort/nmcrel.h"
#include "asterfort/nmleeb.h"
#include "asterfort/nmtima.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Measure), intent(inout) :: ds_measure
    character(len=24), intent(in) :: sderro
    character(len=3), intent(in) :: timer
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! VERIFICATION DU DECLENCHEMENT DES EVENT-DRIVEN TIMER ET INTERRUPTION
!
! ----------------------------------------------------------------------
!
! IN  SDERRO : SD GESTION DES ERREURS
! IO  ds_measure       : datastructure for measure and statistics management
! IN  TIMER  : NOM DU TIMER
!                'PAS'   TIMER POUR UN PAS DE TEMPS
!                'ITE'   TIMER POUR UNE ITERATION DE NEWTON
!
! ----------------------------------------------------------------------
!
    aster_logical :: mtcpup, mtcpui, stopus
    character(len=4) :: etnewt
    integer :: itcpup, itcpui, isusr1
!
! ----------------------------------------------------------------------
!
    itcpup = 0
    itcpui = 0
    isusr1 = 0
!
! - Enough time ?
!
    if (timer .eq. 'PAS') then
        call nmtima(ds_measure, 'Time_Step', itcpup)
    else if (timer.eq.'ITE') then
        call nmleeb(sderro, 'NEWT', etnewt)
        if (etnewt .ne. 'CONV') then
            call nmtima(ds_measure, 'Newt_Iter', itcpui)
        endif
    else
        ASSERT(.false.)
    endif
!
! --- INTERRUPTION DEMANDEE PAR SIGNAL ?
!
    isusr1 = etausr()
!
! --- SYNCHRONISATION DES PROCESSUS PARALLELES
!
    call asmpi_comm_vect('MPI_MAX', 'I', sci=itcpui)
    call asmpi_comm_vect('MPI_MAX', 'I', sci=itcpup)
    call asmpi_comm_vect('MPI_MAX', 'I', sci=isusr1)
!
! --- SAUVEGARDE DES EVENEMENTS
!
    mtcpui = itcpui.eq.1
    mtcpup = itcpup.eq.1
    stopus = isusr1.eq.1
    call nmcrel(sderro, 'ERRE_TIMP', mtcpup)
    call nmcrel(sderro, 'ERRE_TIMN', mtcpui)
    call nmcrel(sderro, 'ERRE_EXCP', stopus)
!
end subroutine
