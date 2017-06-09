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

subroutine cfmata(resoco, neq, nbliai, nmult, numedz,&
                  matelz, numecz, matriz)
!
!
    implicit      none
#include "jeveux.h"
#include "asterfort/atasmo.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: resoco
    character(len=*) :: numedz, numecz, matriz, matelz
    integer :: neq, nbliai, nmult
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (RESOLUTION - UTILITAIRE)
!
! CALCUL DE LA MATRICE AT*A
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  NBLIAI : NOMBRE DE LIAISONS DE CONTACT
! IN  NEQ    : NOMBRE D'EQUATIONS
! IN  NUMEDD : NOM DU NUME_DDL GLOBAL
! IN  NUMECF : NOM DU NUME_DDL A CREER POUR LA MATRICE
! IN  MATELE : NOM DE LA COLLECTION DES VECTEURS
!              LIGNES (I.E. MATRICE RECTANGULAIRE POUR LAQUELLE ON VA
!                      CALCULER LE PRODUIT).
! OUT MATRIX : MATRICE RESULTANTE
!
!
!
!
    character(len=24) :: appoin, apddl
    integer :: japptr, japddl
    character(len=14) :: numedd, numecf
    character(len=19) :: matrix
    character(len=24) :: matele
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    numedd = numedz
    numecf = numecz
    matrix = matriz
    matele = matelz
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    appoin = resoco(1:14)//'.APPOIN'
    apddl = resoco(1:14)//'.APDDL'
    call jeveuo(appoin, 'L', japptr)
    call jeveuo(apddl, 'L', japddl)
!
! --- CONSTRUCTION NOUVELLE MATRICE
!
    call atasmo(neq, matele, zi(japddl), zi(japptr), numedd,&
                matrix, 'V', nbliai, nmult, numecf)
!
    call jedema()
!
end subroutine
