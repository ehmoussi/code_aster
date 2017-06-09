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

subroutine cntdif(ivect, dimen, diff, valdif, maxdim)
!
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/ordis.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
    integer,intent(in) :: maxdim
    integer,intent(in) :: dimen
    integer,intent(in) :: ivect
    integer,intent(out) :: diff
    integer,intent(out) :: valdif(maxdim)
    integer :: ii
    integer, pointer :: vaux(:) => null()

! ----------------------------------------------------------------------
!
!  ROUTINE LIEE A L'OPERATEUR CALC_ERC_DYN
!
!  COMPTE LE NOMBRE D'ELEMENTS DIFFERENTS D'UN ARRAY D'ENTIERS
! ----------------------------------------------------------------------
! IN : IVECT  : POINTEUR DU PREMIER ELEMENT DE L'ARRAY D'ENTIERS
! IN : DIMEN  : DIMENSION DE L'ARRAY SUR LEQUEL ON EFFECTUE LE COMPTAGE
! OUT: DIFF   : NOMBRE D'ELEMENTS DIFFERENTS DANS L'ARRAY
! OUT: VALDIF : ARRAY CONTENANT LES VALEURS DIFFERENTES DANS L'ARRAY 
! IN : MAXDIM : DIMENSION MAXI DE L'ARRAY DE SORTIE VALDIF
! ----------------------------------------------------------------------
    AS_ALLOCATE(vi=vaux, size=dimen)
!
!     ON COPIE DANS UN CONCEPT DE TRAVAIL
    do   ii = 1, dimen
        vaux(ii)=zi(ivect+ii-1)
    end do
!     ON TRIE LE VECTEUR PAR ORDRE CROISSANT
    call ordis(vaux, dimen)
    diff=1
!     ON COMPTE LES ELEMENTS DIFFERENTS
    do   ii = 1, dimen-1
        if (vaux(ii+1) .gt. vaux(ii)) then
            valdif(diff)=vaux(ii)
            diff=diff+1
        endif
    end do
    valdif(diff)=vaux(dimen)
    AS_DEALLOCATE(vi=vaux)
end subroutine
