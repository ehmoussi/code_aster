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

subroutine nmdecv(sddisc, nume_inst, i_event_acti, dtmin, retdec)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterc/r8prem.h"
#include "asterfort/dinins.h"
#include "asterfort/utdidt.h"
#include "asterfort/utmess.h"
    character(len=19) :: sddisc
    integer :: nume_inst, i_event_acti, retdec
    real(kind=8) :: dtmin
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (GESTION DES EVENEMENTS - DECOUPE)
!
! VERIFICATIONS DE LA DECOUPE
!
! ----------------------------------------------------------------------
!
!
! In  sddisc           : datastructure for time discretization
! IN  NUMINS : NUMERO DE L'INSTANT COURANT
! In  i_event_acti     : index of active event
! IN  DTMIN  : INTERVALLE DE TEMPS MINIMAL SUR LA LISTE CREEE
! OUT RETDEC : CODE RETOUR DECOUPE
!               0 ECHEC DE LA DECOUPE
!               1 ON A DECOUPE
!               2 PAS DE DECOUPE
!
! ----------------------------------------------------------------------
!
    integer :: nbnivo, lenivo
    real(kind=8) :: pasmin
!
! ----------------------------------------------------------------------
!
!
! --- NIVEAU DE REDECOUPAGE ACTUEL
!
    lenivo = dinins(sddisc,nume_inst)
!
! --- NIVEAU MAXI DE SUBDIVISION
!
    call utdidt('L', sddisc, 'ECHE', 'SUBD_NIVEAU', index_ = i_event_acti, &
                vali_ = nbnivo)
!
! --- PAS MINIMUM
!
    call utdidt('L', sddisc, 'ECHE', 'SUBD_PAS_MINI', index_ = i_event_acti, &
                valr_ = pasmin)
!
! --- TAILLE DE PAS MINIMALE ATTEINTE PENDANT LA SUBDIVISION
!
    if ((dtmin .lt. pasmin) .or. (dtmin.le.r8prem())) then
        retdec = 0
        call utmess('I', 'SUBDIVISE_16', sr=pasmin)
        goto 999
    else
        retdec = 1
    endif
!
! --- NIVEAU MAXIMUM DE REDECOUPAGE ATTEINT
!
    if (( nbnivo .gt. 1 ) .and. (lenivo.eq.nbnivo)) then
        call utmess('I', 'SUBDIVISE_17', si=lenivo)
        retdec = 0
    else
        retdec = 1
    endif
!
999 continue

end subroutine
