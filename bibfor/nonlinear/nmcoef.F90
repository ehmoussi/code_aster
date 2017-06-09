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

subroutine nmcoef(noeu1, noeu2, typpil, nbno, cnsln,&
                  compo, vect, i, n, coef1,&
                  coef2, coefi)
!
!
    implicit none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/jeveuo.h"
    integer :: noeu1, noeu2, nbno, i, n
    real(kind=8) :: coef1, coef2, coefi
    character(len=8) :: compo
    character(len=19) :: cnsln
!
! ----------------------------------------------------------------------
! CALCUL COEFFICIENT PILOTAGE DU VECTEUR INITIALISATION <S>
! FORMULATION XFEM
! ----------------------------------------------------------------------
!
!
! IN  NOEU1  : EXTREMITE 1 ARETE PILOTEE
! IN  NOEU1  : EXTREMITE 2 ARETE PILOTEE
! IN  TYPPIL : TYPE PILOTAGE
! IN  NBNO   : NOMBRE ARETES EFFECTIVEMENT PILOTEES
! IN  CNSLSN : NOM CHAM_NO_S LEVEL SET NORMALE
! IN  COMPO  : DIRECTION A PILOTER
! IN  VECT   : VECTEUR NORME DE CETTE DIRECTION DANS LA BASE FIXE
! IN  I      : NUMERO COMPOSANTE
! IN  N      : NUMERO ARETE
! OUT  COEF1 : COEF NOEUD 1
! OUT  COEF2 : COEF NOEUD 2
! OUT  COEFI : COEF REPERAGE
!
!
!
!
    integer ::  coefii
    real(kind=8) :: lsn1, lsn2, vect(3), nbnor, deno, eps
    character(len=24) :: typpil
    real(kind=8), pointer :: cnsv(:) => null()
!
    call jeveuo(cnsln//'.CNSV', 'E', vr=cnsv)
    lsn1 = cnsv(noeu1)
    lsn2 = cnsv(noeu2)
    eps = r8prem()
    nbnor=1.d0*nbno
    if ((abs(lsn1).le.eps) .and. (abs(lsn2).le.eps)) then
        coef1=1.d0
        coef2=1.d0
        coefi=0.d0
    else
        deno = abs(lsn1) + abs(lsn2)
        coef1= abs(lsn2)/deno
        coef2= abs(lsn1)/deno
        coefii=nbno*(i-1)+n
        coefi=coefii*1.d0
    endif
!
    if (typpil .eq. 'SAUT_IMPO') then
        if (compo .eq. 'DNOR' .or. compo(1:4) .eq. 'DTAN') then
            coef2=2*coef2*vect(i)/nbnor
            coef1=2*coef1*vect(i)/nbnor
        else
            coef2=2*coef2/nbnor
            coef1=2*coef1/nbnor
        endif
    else if (typpil.eq.'SAUT_LONG_ARC') then
        if (compo .eq. 'DNOR' .or. compo(1:4) .eq. 'DTAN') then
            coef2=2*coef2*vect(i)/sqrt(nbnor)
            coef1=2*coef1*vect(i)/sqrt(nbnor)
        else
            coef2=2*coef2/sqrt(nbnor)
            coef1=2*coef1/sqrt(nbnor)
        endif
    endif
end subroutine
