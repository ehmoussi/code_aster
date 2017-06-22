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

subroutine diaexp(nno, nddl, ldim, masco, masdi)
    implicit none
#include "asterfort/r8inir.h"
    real(kind=8) :: masco(*), masdi(*)
    integer :: nno, nddl, ldim
!     ------------------------------------------------------------------
!     PASSAGE D'UNE MATRICE MASSE CONSISTANTE A UNE MATRICE MASSE
!     DIAGONALE SUIVANT LA TECHNIQUE DE SOMMATION PAR COLONNE
!     ------------------------------------------------------------------
!     IN  NNO   : NOMBRE DE NOEUDS
!     IN  NDDL  : NOMBRE DE DDL PAR NOEUD
!     IN  LDIM  : NOMBRE TOTAL DE DDL DE L ELEMENT
!     IN  MASCO : MATRICE DE MASSE CONSISTANTE
!     OUT MASDI : MATRICE DE MASSE DIAGONALE
!     ------------------------------------------------------------------
!
    integer :: idiag, i, k, i0, k0
!
    call r8inir(ldim*(ldim+1)/2, 0.d0, masdi, 1)
    do 10 i = 1, ldim
        i0 = i*(i-1)/2
        idiag = i*(i+1)/2
        masdi(idiag) = masco(idiag)
        do 20 k = (i0+1), idiag-1
            masdi(idiag) = masdi(idiag) + masco(k)
            k0 = k - i0
            k0 = k0*(k0+1)/2
            masdi(k0) = masdi(k0) + masco(k)
20      continue
10  end do
end subroutine
