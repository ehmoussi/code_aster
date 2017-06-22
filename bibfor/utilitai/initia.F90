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

subroutine initia(neq, lgrot, indro, chamro, chamin)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    aster_logical :: lgrot
    integer :: neq, indro(*)
    real(kind=8) :: chamro(*), chamin(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - UTILITAIRE)
!
! INITIALISE UN CHAM_NO EN TENANT COMPTE DES GRANDES ROTATIONS
!
! ----------------------------------------------------------------------
!
!
! IN  NEQ    : LONGUEUR DES CHAM_NO
! IN  LGROT  : TRUE  S'IL Y A DES DDL DE GRDE ROTATION
!                       FALSE SINON
! IN  INDRO  : VECTEUR DONNANT LE TYPE DES DDL:
!                 0: TRANSLATION OU PETITE ROTATION
!                 1: GRANDE ROTATION
! IN  CHAMRO  : CHAM_NO DONNE
! OUT CHAMIN  : CHAM_NO INITIALISE
!
!    SI LGROT=FALSE:  ZERO
!    SI LGROT=TRUE :  ZERO POUR LES DDL DE TRANSLATION OU DE
!                      PETITE ROTATION
!                      LA VALEUR DE MME RANG EXTRAITE DE CHAMRO
!                      POUR LES DDL DE GRANDE ROTATION
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: zero
    integer :: i
!
! ----------------------------------------------------------------------
!
    zero = 0.d0
    if (.not.lgrot) then
        do 10 i = 1, neq
            chamin(i) = zero
 10     continue
    else
        do 20 i = 1, neq
            if (indro(i) .eq. 0) then
                chamin(i) = zero
            else if (indro(i).eq.1) then
                chamin(i) = chamro(i)
            else
                ASSERT(.false.)
            endif
 20     continue
    endif
end subroutine
