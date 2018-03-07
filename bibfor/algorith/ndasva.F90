! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine ndasva(phase, sddyna, veasse, cnvady)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
character(len=4) :: phase
character(len=19) :: cnvady
character(len=19) :: veasse(*)
character(len=19) :: sddyna
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! CALCUL DES COMPOSANTES DU VECTEUR SECOND MEMBRE DANS LE CAS DYNAMIQUE
!  - CHARGEMENT DE TYPE NEUMANN
!  - CHARGEMENT VARIABLE AU COURS DU PAS DE TEMPS
!  - CHARGEMENT DONNE
!
! ----------------------------------------------------------------------
!
!
! IN  PHASE  : 'PRED' OU 'CORR'
! IN  SDDYNA : SD DYNAMIQUE
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! OUT CNVADY : VECT_ASSE DE TOUS LES CHARGEMENTS VARIABLES DONNES
!
!
!
!
    integer :: ifm, niv
    integer :: ifdo, n
    character(len=19) :: cnvari(20)
    real(kind=8) :: covari(20)
    character(len=19) :: cndyna, cnmoda, cnimpe
    aster_logical :: limpe, lammo
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ...... CALCUL NEUMANN VARIABLE '//&
     &                ' EN DYNAMIQUE'
    endif
!
! --- FONCTIONNALITES ACTIVEES
!
    limpe = ndynlo(sddyna,'IMPE_ABSO')
    lammo = ndynlo(sddyna,'AMOR_MODAL')
!
! --- INITIALISATIONS
!
    ifdo = 0
    call vtzero(cnvady)
!
! --- CALCUL DES FORCES DYNAMIQUES VARIABLES
!
    call nmchex(veasse, 'VEASSE', 'CNDYNA', cndyna)
    ifdo = ifdo+1
    cnvari(ifdo) = cndyna
    covari(ifdo) = -1.d0
    if (lammo) then
        if (phase .eq. 'PRED') then
            call nmchex(veasse, 'VEASSE', 'CNMODP', cnmoda)
        else if (phase.eq.'CORR') then
            call nmchex(veasse, 'VEASSE', 'CNMODC', cnmoda)
        else
            ASSERT(.false.)
        endif
        ifdo = ifdo+1
        cnvari(ifdo) = cnmoda
        covari(ifdo) = -1.d0
    endif
    if (limpe) then
        if (phase .eq. 'PRED') then
            call nmchex(veasse, 'VEASSE', 'CNIMPE', cnimpe)
        else if (phase.eq.'CORR') then
            call nmchex(veasse, 'VEASSE', 'CNIMPE', cnimpe)
        else
            ASSERT(.false.)
        endif
        ifdo = ifdo+1
        cnvari(ifdo) = cnimpe
        covari(ifdo) = -1.d0
    endif
!
!
! --- VECTEUR RESULTANT CHARGEMENT DONNE
!
    do 10 n = 1, ifdo
        call vtaxpy(covari(n), cnvari(n), cnvady)
        if (niv .ge. 2) then
            write (ifm,*) '<MECANONLINE> ......... FORC. DYNA. DONNEES'
            write (ifm,*) '<MECANONLINE> .........  ',n,' - COEF: ',&
     &                   covari(n)
            call nmdebg('VECT', cnvari(n), ifm)
        endif
 10 end do
!
    call jedema()
end subroutine
