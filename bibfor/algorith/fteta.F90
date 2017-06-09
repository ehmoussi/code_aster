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

subroutine fteta(theta, neq, f0, f1)
    implicit none
#include "blas/daxpy.h"
#include "blas/dscal.h"
    real(kind=8) :: theta, f0(*), f1(*)
!**********************************************************************
!
!      BUT :   POUR LA METHODE DE WILSON  , CALCUL DU SECOND MEMBRE
!      ====    DANS VEC(NEQ+1:2*NEQ)
!
!     INPUT:
!           THETA  : PARAMETRE THETA
!           NEQ    : DIMENSION DES VECTEURS FA ET VEC
!           F0     : VECTEUR CHARGEMENT AU TEMPS T
!           F1     : VECTEUR CHARGEMENT AU TEMPS T+DT
!     OUTPUT:
!           F1     : VECTEUR CHARGEMENT THETA METHODE
!
!
!----------------------------------------------------------------------
!   E.D.F DER   JACQUART G. 47-65-49-41      LE 19 JUILLET 1990
!**********************************************************************
!
    real(kind=8) :: coef
!-----------------------------------------------------------------------
    integer :: neq
!-----------------------------------------------------------------------
    coef = 1.0d0 - theta
    call dscal(neq, theta, f1, 1)
    call daxpy(neq, coef, f0, 1, f1,&
               1)
end subroutine
