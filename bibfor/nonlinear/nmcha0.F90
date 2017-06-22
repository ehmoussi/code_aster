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

subroutine nmcha0(tychap, tyvarz, novarz, vachap)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/assert.h"
#include "asterfort/nmchai.h"
    character(len=19) :: vachap(*)
    character(len=6) :: tychap
    character(len=*) :: tyvarz, novarz
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! CREATION D'UNE VARIABLE CHAPEAU
!
! ----------------------------------------------------------------------
!
!
! OUT VACHAP : VARIABLE CHAPEAU
! IN  TYCHAP : TYPE DE VARIABLE CHAPEAU
!                MEELEM - NOMS DES MATR_ELEM
!                MEASSE - NOMS DES MATR_ASSE
!                VEELEM - NOMS DES VECT_ELEM
!                VEASSE - NOMS DES VECT_ASSE
!                SOLALG - NOMS DES CHAM_NO SOLUTIONS
!                VALINC - VALEURS SOLUTION INCREMENTALE
! IN  TYVARI : TYPE DE LA VARIABLE
!               SI 'ALLINI' ALORS INITIALISE A BLANC
! IN  NOVARI : NOM DE LA VARIABLE
!
! ----------------------------------------------------------------------
!
    character(len=19) :: k19bla
    integer :: i, nbvar
    integer :: index
    character(len=6) :: tyvari
    character(len=19) :: novari
!
! ----------------------------------------------------------------------
!
    k19bla = ' '
    tyvari = tyvarz
    novari = novarz
!
    call nmchai(tychap, 'LONMAX', nbvar)
!
    if (tyvari .eq. 'ALLINI') then
        do 12 i = 1, nbvar
            vachap(i) = k19bla
12      continue
    else
        call nmchai(tychap, tyvari, index)
        if ((index.le.0) .or. (index.gt.nbvar)) then
            ASSERT(.false.)
        else
            vachap(index) = novari
        endif
!
    endif
!
end subroutine
