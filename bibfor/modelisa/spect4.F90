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

function spect4(xx, y, xlc, vitn, rhoe,&
                defm, nbp, im, jm)
    implicit none
!  CALCUL DE
!   F(X,Y) = RHOE(X)*RHOE(Y)*DEFM(X,I)*DEFM(Y,J)*U(X)*U(X)*
!            U(Y)*U(Y)*EXP(-ABS(Y-X)/XLC)
!  (APPEL: ROUTINE PRINCIPALE OP0146)
!-----------------------------------------------------------------------
! IN  : XX,Y  : VARIABLES DE LA FONCTION F(XX,Y)
! IN  : XLC   : LONGUEUR DE CORRELATION
! IN  : VITN  : VITESSE NORMALISEE,(VECTEUR DE DIM=2*NBP)
! IN  : RHOE  : MASSE VOL. DU FLUIDE EXTERIEUR, (VECTEUR DE DIM=2*NBP)
! IN  : DEFM  : DEFORMEES MODALES (CONCEPT MELASFLU)
! IN  : NBP   : NOMBRE DE POINTS DE LA DISCR. SPATIALE
! IN  : IM,IM : NUMEROS D ORDRE DES MODES DU CONCEPT MELASFLU
!-----------------------------------------------------------------------
!
#include "jeveux.h"
    real(kind=8) :: defm(nbp, *), vitn(nbp, *), rhoe(nbp, *), xlc, xx, y
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, im, jm, nbp
    real(kind=8) :: delta, phix, phiy, rox, roy, spect4, ux
    real(kind=8) :: uy
!-----------------------------------------------------------------------
    if (xx .le. rhoe(2,1)) then
        i = 2
    else if (xx .gt. rhoe(nbp-1,1)) then
        i = nbp
    else
        i =3
10      continue
        if (xx .gt. rhoe(i,1)) then
            i = i+1
            goto 10
        endif
    endif
!
    delta = (xx-rhoe(i-1,1)) / (rhoe(i,1)-rhoe(i-1,1))
!
    phix = defm(i-1,im) + delta*(defm(i,im)-defm(i-1,im))
    ux = vitn(i-1,2) + delta*(vitn(i,2)-vitn(i-1,2))
    rox = rhoe(i-1,2) + delta*(rhoe(i,2)-rhoe(i-1,2))
!
    if (y .le. rhoe(2,1)) then
        i = 2
    else if (y .gt. rhoe(nbp-1,1)) then
        i = nbp
    else
        i =3
20      continue
        if (y .gt. rhoe(i,1)) then
            i = i+1
            goto 20
        endif
    endif
!
    delta = (y-rhoe(i-1,1)) / (rhoe(i,1)-rhoe(i-1,1))
!
    phiy = defm(i-1,jm) + delta*(defm(i,jm)-defm(i-1,jm))
    uy = vitn(i-1,2) + delta*(vitn(i,2)-vitn(i-1,2))
    roy = rhoe(i-1,2) + delta*(rhoe(i,2)-rhoe(i-1,2))
!
    spect4 = exp(-abs(xx-y)/xlc) * phix * phiy* rox * roy * ux*ux * uy*uy
!
end function
