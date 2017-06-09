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

subroutine nmequi(eta, fonact, sddyna, veasse,&
                  cnfext, cnfint)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmfext.h"
    real(kind=8) :: eta
    integer :: fonact(*)
    character(len=19) :: sddyna
    character(len=19) :: veasse(*)
    character(len=19) :: cnfext, cnfint
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! RESULTANTE DES EFFORTS POUR ESTIMATION DE L'EQUILIBRE
!
! ----------------------------------------------------------------------
!
!
! IN  SDDYNA : SD DYNAMIQUE
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  ETA    : COEFFICIENT DE PILOTAGE
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
!
!
!
!
    integer :: ifm, niv
    aster_logical :: ldyna, lstat
    aster_logical :: lnewma
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> CALCUL DES FORCES POUR '//&
        'ESTIMATION DE L''EQUILIBRE'
    endif
!
! --- FONCTIONNALITES ACTIVEES
!
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
!
! --- INITIALISATIONS
!
    lnewma = .false.
!
! --- FONCTIONNALITES ACTIVEES
!
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
    lstat = ndynlo(sddyna,'STATIQUE')
    if (ldyna) then
        lnewma = ndynlo(sddyna,'FAMILLE_NEWMARK')
    endif
!
! --- VECTEURS EN SORTIE
!
    if (lstat .or. lnewma) then
        call nmchex(veasse, 'VEASSE', 'CNFEXT', cnfext)
        call nmchex(veasse, 'VEASSE', 'CNFINT', cnfint)
    else
        ASSERT(.false.)
    endif
!
! --- CALCUL DES TERMES
!
    if (lstat .or. lnewma) then
        call nmfext(eta, fonact, sddyna, veasse, cnfext)
    else
        ASSERT(.false.)
    endif
!
!
    call jedema()
end subroutine
