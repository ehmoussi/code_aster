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

subroutine vefcur(vec1, nbn, knom, vec2, nbvale,&
                  nomnoe)
    implicit none
!   VERIFICATION DE LA DEFINITION DE LA FONCTION : EXISTENCE DES NOEUDS
!    ET ORDRE D'APPARITION DANS LA LISTE. LECTURE DU NOMBRE DE VALEURS
!                POUR LE DIMENSIONNEMENT DU .VALE
! ----------------------------------------------------------------------
!  IN : VEC1    : I  LISTE DES NUMEROS DE NOEUDS (ABSC_CURV)
!  IN : NBN     :    DIMENSION DE VEC1
!  IN : KNOM    : K8 NOM DES NOEUDS
!  OUT: VEC2    : I  POINTEURS D INDICE DE NOEUDS
!  IN : NBVALE  :    DIMENSION DES VECTEURS KNOM ET VEC2
! ----------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
!
    integer :: nbn, vec1(nbn), nbvale, vec2(nbvale)
    character(len=8) :: knom(nbvale), nomnd
    character(len=24) :: nomnoe
    integer :: i, it, ji, jj, jp, numn
!     ------------------------------------------------------------------
!
!
    do 10 i = 1, nbvale
        nomnd = knom(i)
        call jenonu(jexnom(nomnoe, nomnd), numn)
!
        do 20 jj = 1, nbn
            if (vec1(jj) .eq. numn) then
                vec2(i) = jj
                it = 1
            endif
20      continue
        if (it .ne. 1) then
            call utmess('F', 'UTILITAI5_59')
        endif
        it = 0
10  end do
    do 30 i = 1, nbvale
        jp = vec2(i)
        ji = i
        do 40 jj = i, nbvale
            if (vec2(jj) .lt. jp) then
                ji = jj
                jp = vec2(jj)
            endif
40      continue
        vec2(ji) = vec2(i)
        vec2(i) = jp
30  end do
end subroutine
