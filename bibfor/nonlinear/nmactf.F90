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

subroutine nmactf(ds_print, sddisc, sderro, ds_contact,&
                  ds_conv , iterat, numins)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nmacto.h"
#include "asterfort/nmeceb.h"
#include "asterfort/nmevac.h"
#include "asterfort/nmleeb.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Print), intent(in) :: ds_print
    character(len=24), intent(in) :: sderro
    type(NL_DS_Contact), intent(in) :: ds_contact
    character(len=19), intent(in) :: sddisc
    type(NL_DS_Conv), intent(in) :: ds_conv
    integer, intent(in) :: iterat
    integer, intent(in) :: numins
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! GESTION DES ACTIONS A LA FIN D'UNE BOUCLE DE POINT FIXE
!
! BOUCLE POINT FIXE -> BOUCLE TEMPS
!
! ----------------------------------------------------------------------
!
! In  ds_print         : datastructure for printing parameters
! In  sddisc           : datastructure for time discretization
! IN  SDERRO : SD GESTION DES ERREURS
! In  ds_contact       : datastructure for contact management
! In  ds_conv          : datastructure for convergence management
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! IN  NUMINS : NUMERO D'INSTANT
!
! ----------------------------------------------------------------------
!
    integer :: retact, i_event_acti
    character(len=4) :: etfixe
    integer :: actfix
!
! ----------------------------------------------------------------------
!
    retact = 4
    actfix = 3
!
! --- ETAT DU POINT FIXE ?
!
    call nmleeb(sderro, 'FIXE', etfixe)
!
! --- ACTIONS SUITE A UN EVENEMENT
!
    if (etfixe .eq. 'CONV') then
        retact = 0
    else if (etfixe.eq.'EVEN') then
        call nmacto(sddisc, i_event_acti)
        call nmevac(sddisc, sderro  , i_event_acti, numins, iterat,&
                    retact, ds_print, ds_contact)
! ----- ON NE PEUT PAS CONTINUER LES ITERATIONS DE NEWTON ICI
        ASSERT(retact.ne.2)
    else if (etfixe.eq.'CONT') then
        retact = 2
    else if (etfixe.eq.'ERRE') then
        retact = 1
    else if (etfixe.eq.'STOP') then
        retact = 4
    else
        ASSERT(.false.)
    endif
!
! --- TRAITEMENT DE L'ACTION
!
    if (retact .eq. 0) then
!
! ----- TOUT EST OK -> ON PASSE A LA SUITE
!
        actfix = 0
    else if (retact.eq.1) then
!
! ----- ON REFAIT LE PAS DE TEMPS
!
        actfix = 1
    else if (retact.eq.2) then
!
! ----- ON CONTINUE LES ITERATIONS DE POINT FIXE
!
        actfix = 2
    else if (retact.eq.3) then
!
! ----- ECHEC DE L'ACTION
!
        if (.not.ds_conv%l_stop) then
!
! ------- CONVERGENCE FORCEE -> ON PASSE A LA SUITE
!
            call utmess('A', 'MECANONLINE2_37')
            actfix = 0
        else
!
! ------- ARRET DU CALCUL
!
            actfix = 3
        endif
    else if (retact.eq.4) then
!
! ----- ARRET DU CALCUL
!
        actfix = 3
    else
        ASSERT(.false.)
    endif
!
! --- CHANGEMENT DE STATUT DE LA BOUCLE
!
    if (actfix .eq. 0) then
        call nmeceb(sderro, 'FIXE', 'CONV')
    else if (actfix.eq.1) then
        call nmeceb(sderro, 'FIXE', 'ERRE')
    else if (actfix.eq.2) then
        call nmeceb(sderro, 'FIXE', 'CONT')
    else if (actfix.eq.3) then
        call nmeceb(sderro, 'FIXE', 'STOP')
    else
        ASSERT(.false.)
    endif
!
end subroutine
