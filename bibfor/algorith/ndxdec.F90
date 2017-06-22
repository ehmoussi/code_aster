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

subroutine ndxdec(ds_print, sddisc, sderro, numins)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/nmacto.h"
#include "asterfort/nmeceb.h"
#include "asterfort/nmevac.h"
#include "asterfort/nmleeb.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Print), intent(in) :: ds_print
    character(len=19), intent(in) :: sddisc
    character(len=24), intent(in) :: sderro
    integer, intent(in) :: numins
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! GESTION DE LA DECOUPE DU PAS DE TEMPS
!
! ----------------------------------------------------------------------
!
! In  ds_print         : datastructure for printing parameters
! IN  SDERRO : SD GESTION DES ERREURS
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  NUMINS : NUMERO D'INSTANT
!
! ----------------------------------------------------------------------
!
    integer :: iterat, retact, ievdac, actnew
    character(len=4) :: etnewt
!
! ----------------------------------------------------------------------
!
    retact = 4
    actnew = 3
    iterat = 0
!
! --- ETAT DE NEWTON ?
!
    call nmleeb(sderro, 'NEWT', etnewt)
!
! --- ACTIONS SUITE A UN EVENEMENT
!
    if (etnewt .eq. 'CONV') then
        retact = 0
    else if (etnewt.eq.'EVEN') then
        call nmacto(sddisc, ievdac)
        call nmevac(sddisc, sderro  , ievdac, numins, iterat,&
                    retact, ds_print)
    else if (etnewt.eq.'CONT') then
! ----- CONTINUER LA BOUCLE DE NEWTON EST IMPOSSIBLE EN EXPLICITE
        ASSERT(.false.)
    else if (etnewt.eq.'ERRE') then
! ----- ERRREUR NON TRAITEE DANS NDXCVG
        retact = 4
    else if (etnewt.eq.'STOP') then
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
        actnew = 0
    else if (retact.eq.1) then
!
! ----- ON REFAIT LE PAS DE TEMPS
!
        actnew = 1
    else if (retact.eq.2) then
!
        ASSERT(.false.)
    else if (retact.eq.3) then
!
! ----- ECHEC DE L'ACTION -> ARRET DU CALCUL
!
        actnew = 3
    else if (retact.eq.4) then
!
! ----- ARRET DU CALCUL
!
        actnew = 3
    else
        ASSERT(.false.)
    endif
!
! --- CHANGEMENT DE STATUT DE LA BOUCLE
!
    if (actnew .eq. 0) then
        call nmeceb(sderro, 'NEWT', 'CONV')
    else if (actnew.eq.1) then
        call nmeceb(sderro, 'NEWT', 'ERRE')
    else if (actnew.eq.2) then
        ASSERT(.false.)
    else if (actnew.eq.3) then
        call nmeceb(sderro, 'NEWT', 'STOP')
    else
        ASSERT(.false.)
    endif
!
! --- TRANSFERT ETAT DE LA BOUCLE
!
    call nmleeb(sderro, 'NEWT', etnewt)
    call nmeceb(sderro, 'FIXE', etnewt)
!
end subroutine
