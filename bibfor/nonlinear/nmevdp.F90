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

subroutine nmevdp(sddisc, retswa)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utdidt.h"
#include "asterfort/utmess.h"
    integer :: retswa
    character(len=19) :: sddisc
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - EVENEMENTS)
!
! GESTION DE L'EVENEMENT DIVE_ITER_PILO
!
! ----------------------------------------------------------------------
!
!
! In  sddisc           : datastructure for time discretization TEMPORELLE
! OUT RETSWA : CODE RETOUR CHANGE PILOTAGE
!               0 ECHEC DU SWAP
!               1 SWAP OK - ON REFAIT LE PAS DE TEMPS
!
!
!
!
    integer :: piless
    character(len=8) :: pilcho
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    retswa = 0
!
! --- PARAMETRES
!
    call utdidt('L', sddisc, 'ECHE', 'ESSAI_ITER_PILO',&
                vali_ = piless)
!
! --- L'UTILISATEUR UTILISE LE PILOTAGE
! --- ET SOUHAITE BASCULER SI NON-CONVERGENCE
!
    if (piless .eq. 2) then
!
! ----- ON A DEJA CHOISI UNE SOLUTION: ON DECOUPE
!
        piless = 1
        pilcho = 'NATUREL'
        retswa = 0
        call utmess('I', 'MECANONLINE10_42')
    else if (piless.eq.1) then
!
! ----- ON RETENTE EN CHOISISSANT L'AUTRE SOLUTION
!
        piless = 2
        pilcho = 'AUTRE'
        call utmess('I', 'MECANONLINE10_43')
        retswa = 1
    else
        ASSERT(.false.)
    endif
!
! --- SAUVEGARDE INFO
!
    call utdidt('E', sddisc, 'ECHE', 'ESSAI_ITER_PILO',&
                vali_ = piless)
    call utdidt('E', sddisc, 'ECHE', 'CHOIX_SOLU_PILO',&
                valk_ = pilcho)
!
    call jedema()
end subroutine
