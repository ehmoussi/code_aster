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

subroutine newvit(neq, c1, c2, v0, a0,&
                  v1, a1)
    implicit none
!
!
!     INPUT:
!        NEQ   : NOMBRE D'EQUATIONS (D.D.L. ACTIFS)
!        C1,C2 : CONSTANTES DE CALCUL
!        V0    : VECTEUR VITESSE      INITIALE (NEQ)
!        A0    : VECTEUR ACCELERATION INITIALE (NEQ)
!        A1    : VECTEUR ACCELERATION SOLUTION (NEQ)
!
!     OUTPUT:
!        V1    : VECTEUR VITESSE      SOLUTION (NEQ)
!
!  CALCUL DE LA VITESSE     : VITSOL = V0 + C1*A0 + C2*ACCSOL
!
!
!----------------------------------------------------------------------
!   E.D.F DER   JACQUART G. 47-65-49-41      LE 19 JUILLET 1990
!**********************************************************************
!
#include "blas/daxpy.h"
#include "blas/dcopy.h"
    real(kind=8) :: v0(*), a0(*), v1(*), a1(*)
    real(kind=8) :: c1, c2
!-----------------------------------------------------------------------
    integer :: neq
!-----------------------------------------------------------------------
    call dcopy(neq, v0, 1, v1, 1)
    call daxpy(neq, c1, a0, 1, v1,&
               1)
    call daxpy(neq, c2, a1, 1, v1,&
               1)
end subroutine
