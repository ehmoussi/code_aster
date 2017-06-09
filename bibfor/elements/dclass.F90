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

subroutine dclass(n, tab, iran)
!
    implicit none
!
!     EVALUE L ORDRE DES RACINES DANS IRAN
!     TRI PAR UNE METHODE SOMMAIRE
!     A NE PAS UTILISER AVEC DE GROS TABLEAUX
!
! IN  N : NOMBRE DE RACINE DU POLYNOME
! IN  TAB : TABLEAU DES RACINES DU POLYNOME
!
! OUT IRAN : RANG DE LA RACINE
!
#include "asterfort/dclsma.h"
    integer :: n, iran(*)
!
    real(kind=8) :: tab(*)
!
    if (n .le. 1) then
        iran(1) = 1
    else
        call dclsma(n, tab, iran)
    endif
!
end subroutine
