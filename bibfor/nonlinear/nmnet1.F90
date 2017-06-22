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

subroutine nmnet1(zimat, nmnbn, cnbn, cplas, czef,&
                  czeg, cief, cdeps, cdtg, cier,&
                  cdepsp, dc, normm)
    implicit  none
!
!     CALCUL DE CNBN ET CDEPSP QUAND UN CRITERE PLASTIQUE EST ACTIVE
!
! IN  ZIMAT : ADRESSE DE LA LISTE DE MATERIAU CODE
! IN  NMNBN : FORCE - BACKFORCE
! IN  CDTG : MATRICE TANGENTE
! IN  DC : MATRICE ELASTIQUE + CONSTANTES DE PRAGER
!
! OUT CNBN : NOUVELLE FORCE - BACKFORCE
! OUT CPLAS : NOUVEAUX MOMENTS LIMITES DE PLASTICITE
! OUT CZEF : NOUVEAU ZERO ADIMENSIONNEL POUR LE CRITERE F
! OUT CZEG : NOUVEAU ZERO ADIMENSIONNEL POUR LE CRITERE G
! OUT CIEF : NOUVEAU CIEF > 0 : NBN HORS DE LA ZONE DE DEFINITION DE MP
! OUT CDEPS : NOUVEL INCREMENT DE DEFORMATION DANS LE REPERE ORTHO
! OUT CIER : NOUVEAU CODE ERREUR
! OUT CDEPSP : NOUVEL INCREMENT DE DEF PLASTIQUE DANS LE REPERE ORTHO
! OUT NORMM : NORME SUR LA FONCTION MP = F(N)
!
#include "asterfort/gplass.h"
#include "asterfort/matmul.h"
#include "asterfort/mppffn.h"
    integer :: j, cief, zimat, cier
!
    real(kind=8) :: nmnbn(6), cnbn(6), cplas(2, 3), czef, czeg, normm
    real(kind=8) :: cdeps(6), cdtg(6, 6), cdepsp(6), dc(6, 6), cp(6)
!
    call matmul(cdtg, cdeps, 6, 6, 1,&
                cnbn)
    call matmul(dc, cdepsp, 6, 6, 1,&
                cp)
!
    do 10, j = 1,6
    cnbn(j) = nmnbn(j) + cnbn(j) - cp(j)
    10 end do
!
!     CALCUL DES MOMENTS LIMITES DE PLASTICITE
!     ET DES ZEROS DES CRITERES
    call mppffn(zimat, cnbn, cplas, czef, czeg,&
                cief, normm)
!
    if (cief .gt. 0) then
        cier=2
        goto 20
    endif
!
    if ((gplass(cnbn,cplas,1) .gt. czeg) .or. (gplass(cnbn,cplas,2) .gt. czeg)) then
        cier=1
    else
        cier=0
    endif
!
20  continue
!
end subroutine
