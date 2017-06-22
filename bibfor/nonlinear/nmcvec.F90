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

subroutine nmcvec(oper, typvez, optioz, lcalc, lasse,&
                  nbvect, ltypve, loptve, lcalve, lassve)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    character(len=4) :: oper
    character(len=*) :: typvez, optioz
    aster_logical :: lasse, lcalc
    integer :: nbvect
    character(len=6) :: ltypve(20)
    character(len=16) :: loptve(20)
    aster_logical :: lassve(20), lcalve(20)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! GESTION DE LA LISTE DES VECT_ELEM A CALCULER ET ASSEMBLER
!
! ----------------------------------------------------------------------
!
!
! IN  OPER   : OPERATION SUR LA LISTE
!                'INIT'
!                'AJOU'
! IN  TYPVEC : TYPE DU VECT_ELEM
! IN  OPTION : OPTION DE CALCUL DU VECT_ELEM
! IN  LCALC  : LE VECT_ELEM SERA A CALCULER
! IN  LASSE  : LE VECT_ELEM SERA A ASSEMBLER
! I/O NBVECT : NOMBRE DE VECT_ELEM DANS LA LISTE
! I/O LTYPVE : LISTE DES TYPES DES VECT_ELEM
! I/O LOPTVE : LISTE DES OPTIONS DES VECT_ELEM
! I/O LCALVE : SI VECT_ELEM A CALCULER
! I/O LASSVE : SI VECT_ELEM A ASSEMBLER
!
! ----------------------------------------------------------------------
!
    character(len=16) :: option
    character(len=6) :: k6bla, typvec
    integer :: i
!
! ----------------------------------------------------------------------
!
!
!
! --- INITIALISATIONS
!
    typvec = typvez
    option = optioz
    k6bla = ' '
!
! --- OPERATIONS
!
    if (oper .eq. 'INIT') then
        do 10 i = 1, 20
            ltypve(i) = k6bla
 10     continue
        nbvect = 0
    else if (oper.eq.'AJOU') then
        nbvect = nbvect + 1
        if (nbvect .eq. 21) then
            ASSERT(.false.)
        endif
!
! --- UTILISER NMFINT !
!
        if (typvec .eq. 'CNFINT') then
            ASSERT(.false.)
        endif
        ltypve(nbvect) = typvec
        loptve(nbvect) = option
        lassve(nbvect) = lasse
        lcalve(nbvect) = lcalc
    else
        ASSERT(.false.)
    endif
!
end subroutine
