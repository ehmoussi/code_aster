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

subroutine cginit(nomte, iu, iuc, im)
!
!
    implicit none
#include "asterfort/assert.h"

    character(len=16) :: nomte
    integer :: iu(3, 3), iuc(3), im(3)
! ----------------------------------------------------------------------
!            DECALAGE D'INDICE POUR LES ELEMENTS GAINE/CABLE
! ----------------------------------------------------------------------
! IN  NOMTE  NOM DE L'ELEMENT FINI
! OUT IU     DECALAGE D'INDICE POUR ACCEDER AUX DDL DE DEPLACEMENT GAINE
! OUT IUC    DECALAGE D'INDICE POUR ACCEDER AUX DDL DE DEPL RELA CABLE
! OUT IM     DECALAGE D'INDICE POUR ACCEDER AUX DDL DE LAGRANGE
! ----------------------------------------------------------------------
    integer :: n
    integer :: use3(3), ucse3(3), umse3(2)
! ----------------------------------------------------------------------
    data use3   /1,2,3/
    data ucse3  /1,2,3/
    data umse3  /1,2/
! ----------------------------------------------------------------------
!
    if ((nomte.eq.'MECGSEG3')) then
        do 10 n = 1, 3
            iu(1,n) = 1 + (use3(n)-1)*5
            iu(2,n) = 2 + (use3(n)-1)*5
            iu(3,n) = 3 + (use3(n)-1)*5
10      continue
!
        do 20 n = 1, 3
            iuc(n) = 4 + (ucse3(n)-1)*5
20      continue
!
        do 30 n = 1, 2
            im(n) = umse3(n)*5
30      continue
!
    else
        ASSERT(.false.)
    endif
!
end subroutine
