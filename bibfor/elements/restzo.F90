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

function restzo(zimat, nmnbn, bend, normm, normn)
    implicit none
!
!     CALCUL LA FONCTION INDIQUANT SI ON EST PROCHE DU SOMMET DU CONE
!
! IN  ZIMAT : ADRESSE DE LA LISTE DE MATERIAU CODE
! IN  NMNBN : FORCE - BACKFORCE
! IN  BEND : FLEXION POSITIVE (1) OU NEGATIVE (-1)
! IN  NORMM : NORME SUR LA FONCTION MP = F(N)
! IN  NORMN : NORME SUR LA FONCTION MP = F(N)
!
! OUT RESTZO : FONCTION INDIQUANT SI ON EST PROCHE DU SOMMET DU CONE
!
#include "asterfort/distfo.h"
#include "asterfort/rcvalb.h"
    integer :: i, zimat, restzo, bend, icodre(4)
!
    real(kind=8) :: nmnbn(6), dx, dy, normn, normm, mpcste(2)
    real(kind=8) :: valres(4)
!
    character(len=8) :: kpfonc(2)
    character(len=16) :: nomres(4)
!
    restzo = 0
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
        if (bend .eq. 1) then
            mpcste(1)=valres(1)
            mpcste(2)=valres(2)
        else
            mpcste(1)=valres(3)
            mpcste(2)=valres(4)
        endif
!
        dx = abs(nmnbn(4)-mpcste(1))/normm
        dy = abs(nmnbn(5)-mpcste(2))/normm
    else
        nomres(1) = 'FMEX1'
        nomres(2) = 'FMEX2'
        nomres(3) = 'FMEY1'
        nomres(4) = 'FMEY2'
!
        if (bend .eq. 1) then
            do 10, i = 1,2
            kpfonc(i) = nomres(2*(i-1)+1)
10          continue
        else
            do 30, i = 1,2
            kpfonc(i) = nomres(2*i)
30          continue
        endif
!
        dx = distfo(zimat,kpfonc(1),nmnbn(1),nmnbn(4),normn,normm)
        dy = distfo(zimat,kpfonc(2),nmnbn(2),nmnbn(5),normn,normm)
    endif
!
    if (sqrt(dx**2+dy**2) .lt. 5.0d-2) then
        restzo = 1
    endif
!
end function
