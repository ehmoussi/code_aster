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

function xcalc_code(nfiss, he_inte, he_real)
!
!-----------------------------------------------------------------------
! BUT : CALCULER UN INDICE DE DOMAINE :
!       CONSTRUIRE UNE INJECTION P-UPLET <HE> => ENTIER <ID>
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!   - NFISS  : TAILLE DU P-UPLET
!   - HE     : P-UPLET DE SIGNE HEAVISIDE
!   - ID     : ENTIER A CALCULER
!
!-----------------------------------------------------------------------
    implicit none
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/assert.h"
!-----------------------------------------------------------------------
    integer :: nfiss, xcalc_code
    integer, optional :: he_inte(*)
    real(kind=8), optional :: he_real(*)
!-----------------------------------------------------------------------
    integer :: base_codage
    parameter (base_codage=4)
    integer :: ifiss
!-----------------------------------------------------------------------
!
    ASSERT(nfiss.le.4)
!
    ASSERT(.not.(present(he_inte).and.present(he_real)))
!
    xcalc_code=0
    if ( present(he_inte) ) then
      do ifiss=1, nfiss
        xcalc_code=xcalc_code + (he_inte(ifiss)+2)*base_codage**(nfiss-ifiss)
      enddo
    elseif (present(he_real) ) then
      do ifiss=1, nfiss
        xcalc_code=xcalc_code + (int(he_real(ifiss))+2)*base_codage**(nfiss-ifiss)
      enddo
    else
      ASSERT(.false.)
    endif
!
end function
