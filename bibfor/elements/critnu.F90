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

function critnu(zimat, nmnbn, deps, dtg, normm)
    implicit none
!
!     DEFINIT LE NOMBRE DE CRITERE DE PLASTICITE ACTIVE
!
! IN  ZIMAT : ADRESSE DE LA LISTE DE MATERIAU CODE
! IN  NMNBN : FORCE - BACKFORCE
! IN  DEPS : INCREMENT DE DEFORMATION DANS LE REPERE ORTHO
! IN  DTG : MATRICE ELASTIQUE
! IN  NORMM : NORME SUR LA FONCTION MP = F(N)
!
! OUT CRITNU : NOMBRE DE CRITERE DE PLASTICITE ACTIVE
!
#include "asterfort/fplass.h"
#include "asterfort/gplass.h"
#include "asterfort/matmul.h"
#include "asterfort/mppffn.h"
#include "asterfort/utmess.h"
    integer :: critnu, zimat, nmprif, j
!
    real(kind=8) :: nmnbn(6), nprnbn(6), nmprpl(2, 3), nmprzf, nmprzg
    real(kind=8) :: deps(6), dtg(6, 6), f1elas, f2elas, g1elas, g2elas, normm
    real(kind=8) :: cp(6)
!
!     PREDICTION ELASTIQUE
    call matmul(dtg, deps, 6, 6, 1,&
                cp)
!
!     TENSEUR DES CONTRAINTES TESTS
    do 10, j = 1,6
    nprnbn(j) = nmnbn(j) + cp(j)
    10 end do
!
!     CALCUL DES MOMENTS LIMITES DE PLASTICITE
    call mppffn(zimat, nprnbn, nmprpl, nmprzf, nmprzg,&
                nmprif, normm)
!
    if (nmprif .gt. 0) then
        critnu=-1
        call utmess('A', 'ELEMENTS_21')
        goto 20
    endif
!
!     CALCUL DES CRITERES DE PLASTICITE F
    f1elas = fplass(nprnbn,nmprpl,1)
    f2elas = fplass(nprnbn,nmprpl,2)
!
!     CALCUL DES CONDITIONS DE PLASTICITE G
    g1elas = gplass(nprnbn,nmprpl,1)
    g2elas = gplass(nprnbn,nmprpl,2)
!
    if ((f1elas .gt. 0) .or. (g1elas .gt. 0)) then
        if ((f2elas .gt. 0) .or. (g2elas .gt. 0)) then
            critnu = 12
        else
            critnu = 1
        endif
    else if ((f2elas .gt. 0).or.(g2elas .gt. 0)) then
        critnu = 2
    else
        critnu = 0
    endif
!
20  continue
end function
