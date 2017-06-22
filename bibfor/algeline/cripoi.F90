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

subroutine cripoi(nbm, b, crit)
    implicit none
! COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
! CALCUL DU POIDS RELATIF DES TERMES EXTRADIAGONAUX DE LA MATRICE B(S)
! PAR RAPPORT AUX TERMES DIAGONAUX
! APPELANT : POIBIJ
!-----------------------------------------------------------------------
!  IN : NBM  : NOMBRE DE MODES RETENUS POUR LE COUPLAGE FLUIDELASTIQUE
!              => ORDRE DE LA MATRICE B(S)  (NB: NBM > 1)
!  IN : B    : MATRICE B(S)
! OUT : CRIT : CRITERE DE POIDS RELATIF DES TERMES EXTRADIAGONAUX
!-----------------------------------------------------------------------
#include "asterc/r8miem.h"
#include "asterc/r8nnem.h"
#include "asterc/r8prem.h"
#include "asterfort/dcabs2.h"
#include "asterfort/utmess.h"
    integer :: nbm
    complex(kind=8) :: b(nbm, nbm)
    real(kind=8) :: crit
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, j
    real(kind=8) :: bii, bij, sommii, sommij, tole, tolr, x
    real(kind=8) :: y
!-----------------------------------------------------------------------
    tole = 100.d0*r8miem()
    tolr = r8prem()
!
!-----1.CALCUL DE LA SOMME DES CARRES DES TERMES DIAGONAUX
!
    sommii = 0.d0
!
    do 10 i = 1, nbm
        bii = dcabs2(b(i,i))
        sommii = sommii + bii*bii
10  end do
!
    if (sommii .lt. tole) then
!
        call utmess('A', 'ALGELINE_30')
        crit = r8nnem()
!
    else
!
!-------2.CALCUL DE LA SOMME DES CARRES DES TERMES EXTRADIAGONAUX
!
        sommij = 0.d0
!
        do 20 i = 2, nbm
            bij = dcabs2(b(i,1))
            sommij = sommij + bij*bij
20      continue
!
        do 30 j = 2, nbm
            do 31 i = 1, j-1
                bij = dcabs2(b(i,j))
                sommij = sommij + bij*bij
31          continue
            if (j .lt. nbm) then
                do 32 i = j+1, nbm
                    bij = dcabs2(b(i,j))
                    sommij = sommij + bij*bij
32              continue
            endif
30      continue
!
!-------3.CALCUL DU CRITERE
!
        x = sommij/dble(nbm-1)
!
        if (sommii .lt. x*tolr) then
!
            call utmess('A', 'ALGELINE_31')
            crit = r8nnem()
!
        else
!
            y = x/sommii
            crit = dble(sqrt(y))*100.d0
!
        endif
!
    endif
!
end subroutine
