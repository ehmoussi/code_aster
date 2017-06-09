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

subroutine nmassd(modele, numedd, lischa, fonact, depest,&
                  veasse, matass, cnpilo, cndonn)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmbudi.h"
#include "asterfort/nmchex.h"
#include "asterfort/vtaxpy.h"
    integer :: fonact(*)
    character(len=19) :: lischa
    character(len=24) :: modele, numedd
    character(len=19) :: depest
    character(len=19) :: veasse(*)
    character(len=19) :: cnpilo, cndonn, matass
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! CALCUL DU SECOND MEMBRE POUR LA PREDICTION - DEPLACEMENT DONNE OU
! EXTRAPOLE
!
! ----------------------------------------------------------------------
!
!
! IN  MODELE : NOM DU MODELE
! IN  NUMEDD : NOM DE LA NUMEROTATION
! IN  LISCHA : SD L_CHARGES
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  DEPEST : DEPLACEMENT ESTIME (PAR DEPL_CALC OU EXTROPLATION)
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  MATASS : SD MATRICE ASSEMBLEE
! OUT CNPILO : VECTEUR ASSEMBLE DES FORCES PILOTEES
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
!
!
!
!
    integer :: ifm, niv
    integer :: nbcoef, i, nbvec
    parameter   (nbcoef=3)
    real(kind=8) :: coef(nbcoef)
    character(len=19) :: vect(nbcoef)
    character(len=19) :: vebest
    character(len=19) :: cnbest, cndido, cndidi, cndipi
    aster_logical :: ldidi
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ...... CALCUL SECOND MEMBRE'
    endif
!
! --- INITIALISATIONS
!
    vebest = '&&NMASSD.VEBEST'
    cnbest = '&&NMASSD.CNBEST'
!
! --- FONCTIONNALITES ACTIVEES
!
    ldidi = isfonc(fonact,'DIDI')
!
! --- DEPLACEMENT IMPOSES
!
    call nmchex(veasse, 'VEASSE', 'CNDIDO', cndido)
    call nmchex(veasse, 'VEASSE', 'CNDIDI', cndidi)
!
! --- DEPLACEMENT PILOTES
!
    call nmchex(veasse, 'VEASSE', 'CNDIPI', cndipi)
!
! --- CONDITIONS DE DIRICHLET B.U
!
    call nmbudi(modele, numedd, lischa, depest, vebest,&
                cnbest, matass)
!
! --- VALEURS POUR SOMME DES FORCES
!
    nbvec = 2
    coef(1) = 1.d0
    coef(2) = -1.d0
    vect(1) = cndido
    vect(2) = cnbest
    if (ldidi) then
        nbvec = nbvec+1
        vect(nbvec) = cndidi
        coef(nbvec) = 1.d0
    endif
!
! --- CHARGEMENT FIXE
!
    if (nbvec .gt. nbcoef) then
        ASSERT(.false.)
    endif
    do 10 i = 1, nbvec
        call vtaxpy(coef(i), vect(i), cndonn)
 10 end do
!
! --- CHARGEMENT PILOTE
!
    cnpilo = cndipi
!
! --- NETTOYAGE
!
    call detrsd('VECT_ELEM', vebest)
    call detrsd('CHAMP', cnbest)
!
    call jedema()
!
end subroutine
