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

subroutine nmacfi(fonact, veasse, cnffdo, cndfdo)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
    character(len=19) :: cnffdo, cndfdo
    character(len=19) :: veasse(*)
    integer :: fonact(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! CALCUL DU VECTEUR DES CHARGEMENTS CONSTANTS POUR L'ACCELERATION
! INITIALE
!
! ----------------------------------------------------------------------
!
!
! IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! OUT CNFFDO : VECT_ASSE DE TOUTES LES FORCES FIXES DONNES
! OUT CNDFDO : VECT_ASSE DE TOUS LES DEPLACEMENTS FIXES DONNES
!
!
!
!
!
    integer :: ifm, niv
    integer :: ifdo
    integer :: n
    character(len=19) :: cnfixe(20)
    real(kind=8) :: cofixe(20)
    character(len=19) :: cnfedo, cndido
    character(len=19) :: cncine, cndidi, cnsstr, cnsstf
    aster_logical :: ldidi
    aster_logical :: lmacr, lsstf
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ...... CALCUL CHARGEMENT FIXE'
    endif
!
! --- FONCTIONNALITES ACTIVEES
!
    ldidi = isfonc(fonact,'DIDI')
    lmacr = isfonc(fonact,'MACR_ELEM_STAT')
    lsstf = isfonc(fonact,'SOUS_STRUC')
!
! --- INITIALISATIONS
!
    ifdo = 0
    call vtzero(cnffdo)
    call vtzero(cndfdo)
!
! --- DEPLACEMENTS DONNES (Y COMPRIS DIDI SI NECESSAIRE)
!
    call nmchex(veasse, 'VEASSE', 'CNDIDO', cndido)
    ifdo = ifdo+1
    cnfixe(ifdo) = cndido
    cofixe(ifdo) = 1.d0
!
    if (ldidi) then
        call nmchex(veasse, 'VEASSE', 'CNDIDI', cndidi)
        ifdo = ifdo+1
        cnfixe(ifdo) = cndidi
        cofixe(ifdo) = 1.d0
    endif
!
! --- CONDITIONS CINEMATIQUES IMPOSEES
!
    call nmchex(veasse, 'VEASSE', 'CNCINE', cncine)
    ifdo = ifdo+1
    cnfixe(ifdo) = cncine
    cofixe(ifdo) = 1.d0
!
! --- VECTEUR RESULTANT DEPLACEMENT FIXE
!
    do 17 n = 1, ifdo
        call vtaxpy(cofixe(n), cnfixe(n), cndfdo)
        if (niv .ge. 2) then
            write (ifm,*) '<MECANONLINE> ......... DEPL. FIXE'
            write (ifm,*) '<MECANONLINE> .........  ',n,' - COEF: ',&
     &                   cofixe(n)
            call nmdebg('VECT', cnfixe(n), ifm)
        endif
 17 end do
!
    ifdo = 0
!
! --- FORCES DONNEES
!
    call nmchex(veasse, 'VEASSE', 'CNFEDO', cnfedo)
    ifdo = ifdo+1
    cnfixe(ifdo) = cnfedo
    cofixe(ifdo) = 1.d0
!
! --- FORCES ISSUES DES MACRO-ELEMENTS STATIQUES
!
    if (lmacr) then
        call nmchex(veasse, 'VEASSE', 'CNSSTR', cnsstr)
        ifdo = ifdo+1
        cnfixe(ifdo) = cnsstr
        cofixe(ifdo) = -1.d0
    endif
!
! --- FORCES ISSUES DU CALCUL PAR SOUS-STRUCTURATION
!
    if (lsstf) then
        call nmchex(veasse, 'VEASSE', 'CNSSTF', cnsstf)
        ifdo = ifdo+1
        cnfixe(ifdo) = cnsstf
        cofixe(ifdo) = 1.d0
    endif
!
! --- VECTEUR RESULTANT FORCE FIXE
!
    do 10 n = 1, ifdo
        call vtaxpy(cofixe(n), cnfixe(n), cnffdo)
        if (niv .ge. 2) then
            write (ifm,*) '<MECANONLINE> ......... FORC. FIXE'
            write (ifm,*) '<MECANONLINE> .........  ',n,' - COEF: ',&
     &                 cofixe(n)
            call nmdebg('VECT', cnfixe(n), ifm)
        endif
 10 end do
!
    call jedema()
end subroutine
