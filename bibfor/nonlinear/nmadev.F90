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
subroutine nmadev(sddisc, sderro, iterat)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmerge.h"
#include "asterfort/nmlecv.h"
#include "asterfort/nmltev.h"
#include "asterfort/utdidt.h"
#include "asterfort/getAdapEvent.h"
!
character(len=19) :: sddisc
character(len=24) :: sderro
integer :: iterat
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! MISE A JOUR DE L'INDICATEUR DE SUCCES DES ITERATIONS DE NEWTON
!
! ----------------------------------------------------------------------
!
! In  sddisc           : datastructure for time discretization
! IN  SDERRO : GESTION DES ERREURS
! IN  ITERAT : NUMERO DE L'ITERATION DE NEWTON
!
! ----------------------------------------------------------------------
!
    integer :: vali, nb_event_ok
    integer :: i_adap, nb_adap, event_type
    real(kind=8) :: vale
    character(len=8) :: cricom, metlis
    character(len=16) :: nopara
    aster_logical :: itemax, lerrit, divres, cvnewt
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LA MISE A JOUR DE L'INDICATEUR DE SUCCES DES ITERATIONS DE NEWTON
! --- N'EST FAITE QU'EN GESTION AUTO DU PAS DE TEMPS
!
    call utdidt('L', sddisc, 'LIST', 'METHODE', valk_ = metlis)
    if (metlis .ne. 'AUTO') goto 999
!
! --- EVENEMENTS
!
    call nmerge(sderro, 'ITER_MAXI', itemax)
    call nmltev(sderro, 'ERRI', 'NEWT', lerrit)
    call nmerge(sderro, 'DIVE_RESI', divres)
!
! --- NEWTON A CONVERGE ?
!
    call nmlecv(sderro, 'NEWT', cvnewt)
!
! --- BOUCLE SUR LES OCCURENCES D'ADAPTATION
!
    call utdidt('L', sddisc, 'LIST', 'NADAPT', vali_ = nb_adap)
!
    do i_adap = 1, nb_adap
! ----- Get event type
        call getAdapEvent(sddisc, i_adap, event_type)
!
        if (event_type .eq. ADAP_EVT_TRIGGER) then
!
! ------- PARAMETRES DU SEUIL
!
            call utdidt('L', sddisc, 'ADAP', 'NOM_PARA', index_ = i_adap, &
                        valk_ = nopara)
            call utdidt('L', sddisc, 'ADAP', 'CRIT_COMP', index_ = i_adap, &
                        valk_ = cricom)
            call utdidt('L', sddisc, 'ADAP', 'VALE', index_ = i_adap, &
                        valr_ = vale, vali_ = vali)
!
            ASSERT(nopara.eq.'NB_ITER_NEWT')
!
! ------- RECUP DU NB DE SUCCES CONSECUTIFS : NBOK
!
            call utdidt('L', sddisc, 'ADAP', 'NB_EVEN_OK', index_ = i_adap, &
                        vali_ = nb_event_ok)
!
! ------- EN CAS DE NOUVEAU SUCCES A CONVERGENCE
!
            if (cvnewt) then
                if (cricom .eq. 'LT' .and. iterat .lt. vali .or. cricom .eq. 'GT' .and.&
                    iterat .gt. vali .or. cricom .eq. 'LE' .and. iterat .le. vali .or.&
                    cricom .eq. 'GE' .and. iterat .ge. vali) then
                    nb_event_ok = nb_event_ok+1
                endif
            endif
!
! ------- EN CAS D'ECHEC: ON REMET A ZERO
!
            if (lerrit .or. itemax .or. divres) nb_event_ok=0
!
! ------- ENREGISTREMENT DU NB DE SUCCES CONSECUTIFS
!
            call utdidt('E', sddisc, 'ADAP', 'NB_EVEN_OK', index_ = i_adap, &
                        vali_ = nb_event_ok)
!
        endif
    end do
!
999 continue
!
    call jedema()
end subroutine
