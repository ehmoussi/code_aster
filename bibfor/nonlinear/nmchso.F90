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

subroutine nmchso(chapin, tychaz, typsoz, nomvaz, chapou)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/nmchai.h"
    character(len=19) :: chapin(*), chapou(*)
    character(len=*) :: tychaz, typsoz
    character(len=*) :: nomvaz
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! RECOPIE UN VECTEUR CHAPEAU EN CHANGEANT EVENTUELLEMENT UN NOM DE
! VARIABLE
!
! ----------------------------------------------------------------------
!
!
! IN  CHAPIN : VARIABLE CHAPEAU ENTRANTE
! IN  TYCHAP : TYPE DE VARIABLE CHAPEAU
!                MEELEM - NOMS DES MATR_ELEM
!                MEASSE - NOMS DES MATR_ASSE
!                VEELEM - NOMS DES VECT_ELEM
!                VEASSE - NOMS DES VECT_ASSE
!                SOLALG - NOMS DES CHAM_NO SOLUTION
!                VALINC - VALEURS SOLUTION INCREMENTALE
! IN  TYPSOL : TYPE DE VARIABLE A REMPLACER
!              ' ' SI PAS DE CHANGEMENT
! IN  NOMVAR : NOM DE LA VARIABLE
! OUT CHAPOU : VARIABLE CHAPEAU SORTANTE
!
! ----------------------------------------------------------------------
!
    integer :: index, i, nmax
    character(len=19) :: chtemp, nomvar
    character(len=6) :: tychap, typsol
!
! ----------------------------------------------------------------------
!
    nomvar = nomvaz
    tychap = tychaz
    typsol = typsoz
    call nmchai(tychap, 'LONMAX', nmax)
    if (typsol .ne. ' ') then
        call nmchai(tychap, typsol, index)
    endif
!
! --- INITIALISATION DES NOMS
!
!     -- PARFOIS CHAPOU ET CHAPIN SONT IDENTIQUES (MEMES TABLEAUX)
!        CELA PROVOQUE UN MESSAGE DE VALGRIND.
!        POUR EVITER CE PROBLEME, ON RECOPIE EN 2 TEMPS
!
    do 11 i = 1, nmax
        chtemp = chapin(i)
        chapou(i) = chtemp
11  end do
!
! --- REMPLACEMENT
!
    if (typsol .ne. ' ') then
        chapou(index) = nomvar
    endif
!
end subroutine
