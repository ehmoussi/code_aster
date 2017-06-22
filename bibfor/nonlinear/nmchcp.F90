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

subroutine nmchcp(tychap, vachin, vachou)
!
! person_in_charge: sylvie.granet at edf.fr
!
    implicit none
#include "asterfort/nmchai.h"
    character(len=19) :: vachin(*), vachou(*)
    character(len=6) :: tychap
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! RECOPIE D'UNE VARIABLE CHAPEAU
!
! ----------------------------------------------------------------------
!
!
! IN  VACHIN : VARIABLE CHAPEAU EN ENTREE
! IN  TYCHAP : TYPE DE VARIABLE CHAPEAU
!                MEELEM - NOMS DES MATR_ELEM
!                MEASSE - NOMS DES MATR_ASSE
!                VEELEM - NOMS DES VECT_ELEM
!                VEASSE - NOMS DES VECT_ASSE
!                SOLALG - NOMS DES CHAM_NO SOLUTIONS
!                VALINC - VALEURS SOLUTION INCREMENTALE
! OUT VACHOU : VARIABLE CHAPEAU EN SORTIE
!
! ----------------------------------------------------------------------
!
    integer :: i, nbvar
!
! ----------------------------------------------------------------------
!
    call nmchai(tychap, 'LONMAX', nbvar)
!
    do 12 i = 1, nbvar
        vachou(i) = vachin(i)
12  end do
!
end subroutine
