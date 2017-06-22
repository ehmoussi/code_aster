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

subroutine xmafr2(tau1, tau2, b, abc)
!
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
    real(kind=8) :: tau1(3), tau2(3), b(3, 3), abc(2, 2)
!
! ----------------------------------------------------------------------
!
!                CALCUL DES MATRICES DE FROTTEMENT UTILES
!
! IN    NLI,NLJ     : NUMÉRO DES POINTS D'INTERSECTION OÙ ON VEUT TAU
! IN    TAU1,TAU2   : VECTEURS DU PLAN TANGENT DE LA BASE COVARIANTE
!                     AUX POINTS D'INTERSECTION
! IN    B           : MATRICE (Id-KN)
!
! OUT   ABC         : PRODUIT MATRICE TAU(NLI).(Id-KN).TAU(NLJ)
!
!
!
!
!
    integer :: ndim, i, j, k
    real(kind=8) :: a(2, 3), bc(3, 2), c(3, 2)
!
    call elrefe_info(fami='RIGI',ndim=ndim)
!
!
!  CALCUL DE A.B.C AVEC A=(TAU1) EN NLI ET C=(TAU1 TAU2) EN NLJ
!                         (TAU2)
!
!     MATRICES A ET C
    do 10 j = 1, ndim
        a(1,j)=tau1(j)
        if (ndim .eq. 3) a(2,j)=tau2(j)
        c(j,1)=tau1(j)
        if (ndim .eq. 3) c(j,2)=tau2(j)
10  end do
!
!     PRODUIT B.C
    do 20 i = 1, ndim
        do 21 j = 1, ndim-1
            bc(i,j)=0.d0
            do 22 k = 1, ndim
                bc(i,j)=bc(i,j)+b(i,k)*c(k,j)
22          continue
21      continue
20  end do
!
!     PRODUIT A.BC
    do 30 i = 1, ndim-1
        do 31 j = 1, ndim-1
            abc(i,j)=0.d0
            do 32 k = 1, ndim
                abc(i,j)=abc(i,j)+a(i,k)*bc(k,j)
32          continue
31      continue
30  end do
!
end subroutine
