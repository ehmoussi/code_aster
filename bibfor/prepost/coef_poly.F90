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

subroutine coef_poly(lrev, lmdb, abscr,sigma)
    implicit none
    real(kind=8) :: lrev, lmdb
    real(kind=8) :: abscr(5)
    real(kind=8) :: sigma(5)
! ======================================================================
!
!
!
!-----------------------------------------------------------------------
!     operateur POST_K_BETA (METHODE DES COEFFICIENTS D'INFLUENCE)
!
!              RSE-M - Edition 2010
!                  ANNEXE 5.4
!      METHODES ANALYTIQUES DE CALCUL DES FACTEURS
!      D'INTENSITE DE CONTRAINTE ET DE L'INTEGRALE J
!-----------------------------------------------------------------------
! ======================================================================
! --- BUT : CALCUL DES COEFFICIENTS DU POLYNOME DE DEGRE 5
! ======================================================================
! IN  : lrev   : EPAISSEUR DE REVETEMENT -------------------------------
! --- : lmdb   : EPAISSEUR DU METAL DE BASE ----------------------------
! --- : abscr  : ABSCISSES CURVILIGNES ---------------------------------
! --- : sigma  : CONTRAINTES NORMALES ----------------------------------
! OUT : sigma  : COEFFICIENTS DU POLYNOME ------------------------------
! ======================================================================
#include "asterfort/mgauss.h"

    real(kind=8) :: matr(5,5)
    real(kind=8) :: det, coef, xl
    real(kind=8) :: s1,s2,s3,s4,s5

    integer :: iret
!
! --- initialisation
!
   s1 = sigma(1)
   s2 = sigma(2)
   s3 = sigma(3)
   s4 = sigma(4)
   s5 = sigma(5)

    xl = lrev+lmdb
    coef = (lrev+abscr(1))/xl

    matr(1,1) = 1.d0
    matr(1,2) = coef
    matr(1,3) = coef**2.d0
    matr(1,4) = coef**3.d0
    matr(1,5) = coef**4.d0
!
    coef = (lrev+abscr(2))/xl
    matr(2,1) = 1.d0
    matr(2,2) = coef
    matr(2,3) = coef**2.d0
    matr(2,4) = coef**3.d0
    matr(2,5) = coef**4.d0
!
    coef = (lrev+abscr(3))/xl
    matr(3,1) = 1.d0
    matr(3,2) = coef
    matr(3,3) = coef**2.d0
    matr(3,4) = coef**3.d0
    matr(3,5) = coef**4.d0
!
    coef = (lrev+abscr(4))/xl
    matr(4,1) = 1.d0
    matr(4,2) = coef
    matr(4,3) = coef**2.d0
    matr(4,4) = coef**3.d0
    matr(4,5) = coef**4.d0
!
    coef = (lrev+abscr(5))/xl
    matr(5,1) = 1.d0
    matr(5,2) = coef
    matr(5,3) = coef**2.d0
    matr(5,4) = coef**3.d0
    matr(5,5) = coef**4.d0
!
! resolution du systeme d'equations
!
   call mgauss('NFSP', matr, sigma, 5, 5,&
                  1, det, iret)
end subroutine
