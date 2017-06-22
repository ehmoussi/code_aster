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

subroutine nmdiri(modele, mate, carele, lischa, sddyna,&
                  depl, vite, acce, vediri)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynlo.h"
#include "asterfort/vebtla.h"
    character(len=19) :: lischa
    character(len=24) :: modele, mate, carele
    character(len=19) :: vediri, sddyna
    character(len=19) :: depl, vite, acce
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! CALCUL DES VECT_ELEM POUR LES REACTIONS D'APPUI BT.LAMBDA
!
! ----------------------------------------------------------------------
!
!
! IN  MODELE : NOM DU MODELE
! IN  MATE   : NOM DU CHAMP DE MATERIAU
! IN  LISCHA : LISTE DES CHARGES
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! IN  SDDYNA : SD DYNAMIQUE
! OUT VEDIRI : VECT_ELEM DES REACTIONS D'APPUI BT.LAMBDA
!
!
!
!
    aster_logical :: lstat, ldepl, lvite, lacce
    character(len=19) :: veclag
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- FONCTIONNALITES ACTIVEES
!
    lstat = ndynlo(sddyna,'STATIQUE')
    if (lstat) then
        ldepl = .true.
        lvite = .false.
        lacce = .false.
    else
        ldepl = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.1
        lvite = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.2
        lacce = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.3
    endif
!
! --- QUEL VECTEUR D'INCONNUES PORTE LES LAGRANGES ?
!
    if (ldepl) then
        veclag = depl
    else if (lvite) then
        veclag = vite
!       VILAINE GLUTE POUR L'INSTANT
        veclag = depl
    else if (lacce) then
        veclag = acce
    else
        ASSERT(.false.)
    endif
!
! --- CALCUL DES VECT_ELEM POUR LES REACTIONS D'APPUI BT.LAMBDA
!
    call vebtla('V', modele, mate, carele, veclag,&
                lischa, vediri)
!
    call jedema()
end subroutine
