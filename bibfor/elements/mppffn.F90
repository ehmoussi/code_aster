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

subroutine mppffn(zimat, nmnbn, nmplas, nmzef, nmzeg,&
                  nmief, normm)
    implicit none
!
!     CALCUL LES VALEURS DES MOMENTS LIMITES DE PLASTICITE
!     ET CALCUL LES ZEROS ADIMENSIONNELS POUR LES CRITERES
!
! IN  ZIMAT : ADRESSE DE LA LISTE DE MATERIAU CODE
! IN  NMNBN : EFFORT - EFFORT DE RAPPEL
! IN  NORMM : NORME SUR LA FONCTION MP = F(N)
!
! OUT NMZEF : ZERO ADIMENSIONNEL POUR LE CRITERE F
! OUT NMZEG : ZERO ADIMENSIONNEL POUR LE CRITERE G
! OUT NMIEF : NMIEF > 0 : NBN HORS DE LA ZONE DE DEFINITION DE MP
! OUT NMPLAS : MOMENTS LIMITES DE PLASTICITE
!
#include "asterfort/cdnfon.h"
#include "asterfort/rcvalb.h"
    integer :: i, ier, nmief, zimat, icodre(4)
!
    real(kind=8) :: nmnbn(6), nmplas(2, 3)
    real(kind=8) :: nmzef, nmzeg, zero, normm
    real(kind=8) :: valres(4)
!
    character(len=16) :: nomres(4)
!
    zero = 1.0d-6
    nmief = 0
!
    nomres(1)='MPCST'
!
    call rcvalb('FPG1', 1, 1, '+', zimat,&
                ' ', 'GLRC_DAMAGE', 0, ' ', [0.d0],&
                1, nomres, valres, icodre, 1)
!
    if (valres(1) .eq. 0.d0) then
        nomres(1)='MAXMP1'
        nomres(2)='MAXMP2'
        nomres(3)='MINMP1'
        nomres(4)='MINMP2'
!
        call rcvalb('FPG1', 1, 1, '+', zimat,&
                    ' ', 'GLRC_DAMAGE', 0, ' ', [0.d0],&
                    4, nomres, valres, icodre, 1)
!
        nmplas(1,1)=valres(1)
        nmplas(1,2)=valres(2)
        nmplas(1,3)=0.d0
        nmplas(2,1)=valres(3)
        nmplas(2,2)=valres(4)
        nmplas(2,3)=0.d0
    else
        nomres(1) = 'FMEX1'
        nomres(2) = 'FMEX2'
        nomres(3) = 'FMEY1'
        nomres(4) = 'FMEY2'
        do 20, i = 1,2
        call cdnfon(zimat, nomres(2*(i-1)+1), nmnbn(i), 0, nmplas(1, i),&
                    ier)
        nmief = nmief + ier
!
        call cdnfon(zimat, nomres(2*i), nmnbn(i), 0, nmplas(2, i),&
                    ier)
        nmief = nmief + ier
20      continue
    endif
!
    nmzef = zero * (normm**2)
    nmzeg = zero * normm
!
end subroutine
