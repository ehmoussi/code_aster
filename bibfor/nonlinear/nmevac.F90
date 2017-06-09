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

subroutine nmevac(sddisc, sderro   , i_echec_acti, nume_inst   , iterat,&
                  retact, ds_print_, ds_contact_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nmadcp.h"
#include "asterfort/nmdeco.h"
#include "asterfort/nmecev.h"
#include "asterfort/nmeraz.h"
#include "asterfort/nmerge.h"
#include "asterfort/nmevdp.h"
#include "asterfort/nmitsp.h"
#include "asterfort/utdidt.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sddisc
    character(len=24), intent(in) :: sderro
    integer, intent(in) :: i_echec_acti
    integer, intent(in) :: nume_inst
    integer, intent(in) :: iterat
    integer, intent(out) :: retact
    type(NL_DS_Print), optional, intent(in) :: ds_print_
    type(NL_DS_Contact), optional, intent(in) :: ds_contact_
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! ACTIONS SUITE A UN EVENEMENT
!
! ----------------------------------------------------------------------
!
! In  ds_print         : datastructure for printing parameters
! In  sddisc           : datastructure for time discretization
! IN  SDERRO : SD ERREUR
! In  ds_contact       : datastructure for contact management
! IN  IEVDAC : INDICE DE L'EVENEMENT ACTIF
! IN  NUMINS : NUMERO D'INSTANT
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! OUT RETACT : CODE RETOUR
!     0 - ON NE FAIT RIEN
!     1 - ON REFAIT LE PAS DE TEMPS
!     2 - ON CONTINUE LA BOUCLE DE NEWTON (ITERATIONS EN PLUS)
!     3 - L'ACTION A ECHOUE
!
! ----------------------------------------------------------------------
!
    character(len=16) :: action, event_name
    integer :: retsup, retswa, retpen, retdec
    aster_logical :: trydec, litmax
!
! ----------------------------------------------------------------------
!
    retact = 3
    action = 'ARRET'
    trydec = .false.
    ASSERT(i_echec_acti.ne.0)
!
! --- RECUPERATION ERREURS PARTICULIERES
!
    litmax = .false.
    if (sderro .ne. ' ') then
        call nmerge(sderro, 'ITER_MAXI', litmax)
    endif
!
! - Event and action
!
    call utdidt('L', sddisc, 'ECHE', 'NOM_EVEN', index_ = i_echec_acti,&
                valk_ = event_name)
    call utdidt('L', sddisc, 'ECHE', 'ACTION'  , index_ = i_echec_acti,&
                valk_ = action)
!
! --- REALISATION DE L'ACTION
!
    if (action .eq. 'ARRET') then
        call utmess('I', 'MECANONLINE10_30')
        retact = 3
        trydec = .false.
    else if (action.eq.'ITER_SUPPL') then
        ASSERT(iterat.ge.0)
        if (litmax) then
            call utmess('I', 'MECANONLINE10_32')
            call nmitsp(ds_print_, sddisc, iterat, retsup)
        else
            retsup = 0
        endif
        if (retsup .eq. 0) then
            trydec = .true.
        else if (retsup.eq.1) then
            retact = 2
        else
            ASSERT(.false.)
        endif
    else if (action.eq.'DECOUPE') then
        trydec = .true.
    else if (action.eq.'AUTRE_PILOTAGE') then
        if (litmax) then
            call utmess('I', 'MECANONLINE10_34')
            call nmevdp(sddisc, retswa)
        else
            retswa = 0
        endif
        if (retswa .eq. 0) then
            trydec = .true.
        else if (retswa.eq.1) then
            retact = 1
        else
            ASSERT(.false.)
        endif
    else if (action.eq.'ADAPT_COEF_PENA') then
        call utmess('I', 'MECANONLINE10_35')
        call nmadcp(sddisc, ds_contact_, i_echec_acti, retpen)
        trydec = .false.
        if (retpen .eq. 0) then
            retact = 3
        else if (retpen.eq.1) then
            retact = 1
        else
            ASSERT(.false.)
        endif
    else if (action.eq.'CONTINUE') then
        retact = 0
    else
        ASSERT(.false.)
    endif
!
! --- CAS DE LA DECOUPE
!
    if (trydec) then
        call utmess('I', 'MECANONLINE10_33')
        call nmdeco(sddisc, nume_inst, iterat, i_echec_acti, retdec)
        if (retdec .eq. 0) then
            retact = 3
        else if (retdec.eq.1) then
            retact = 1
        else if (retdec.eq.2) then
            retact = 0
        else
            ASSERT(.false.)
        endif
    endif
!
! --- ECHEC DE L'ACTION -> EVENEMENT ERREUR FATALE
!
    if (retact .eq. 3) then
        call nmecev(sderro, 'E', event_name, action)
    endif
!
! --- ON DESACTIVE LES EVENEMENTS
!
    call nmeraz(sderro, 'EVEN')
!
end subroutine
