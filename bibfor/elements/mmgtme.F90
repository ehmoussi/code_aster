! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine mmgtme(ndim  ,nnm   ,nne,mprt1n,mprt2n, &
                  wpg   , &
          ffe,ddffm,jacobi,coefac,jeu   , &
          dlagrc,kappa ,vech1 ,vech2 ,h     , &
          mprt11,mprt21,mprt22,matrme)
!
! person_in_charge: mickael.abbas at edf.fr
!

    implicit     none
#include "asterfort/matini.h"

    
    integer :: ndim,  nnm, nne
    
    real(kind=8) :: mprt1n(3,3),mprt2n(3,3)
    real(kind=8) :: mprnt2(3,3)
    real(kind=8) :: mprt11(3,3),mprt22(3,3),mprt21(3,3),mprt12(3,3)
    
    real(kind=8) :: ffe(9),ddffm(3,9)
    real(kind=8) :: wpg, jacobi
    real(kind=8) :: coefac, jeu, dlagrc
    
    real(kind=8) :: kappa(2,2),h(2,2)
    real(kind=8) :: vech1(3),vech2(3)
    
    real(kind=8) :: matrme(27, 27)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DE LA MATRICE DEPL/DEPL ----- CONTRIBUTIONS STANDARDS 
! SANS NON LINEARITES GEOMETRIQUES LIEES A LA DEUXIEME VARIATION DU GAP NORMAL
!
! ----------------------------------------------------------------------
!
!
! IN  PHASEP : PHASE DE CALCUL
!              'CONT'      - CONTACT
!              'CONT_PENA' - CONTACT PENALISE
!              'ADHE'      - ADHERENCE
!              'ADHE_PENA' - ADHERENCE PENALISE
!              'GLIS'      - GLISSEMENT
!              'GLIS_PENA' - GLISSEMENT PENALISE
! IN  LNEWTG : .TRUE. SI CALCUL CONTRIBUTION GEOMETRIQUE EN NEWTON GENE.
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  MPROJN : MATRICE DE PROJECTION NORMALE [Pn]
! IN  MPROJT : MATRICE DE PROJECTION TANGENTE [Pt]
! IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFE    : FONCTIONS DE FORMES DEPL. ESCL.
! IN  FFM    : FONCTIONS DE FORMES DEPL. MAIT.
! IN  DFFM   : DERIVEES PREMIERES DES FONCTIONS DE FORME MAITRES
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! IN  COEFAC : COEF_AUGM_CONT
! IN  COEFAF : COEF_AUGM_FROT
! IN  LAMBDA : LAGRANGIEN DE CONTACT
! IN  DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
! IN  DJEU   : INCREMENT DEPDEL DU JEU
! IN  RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
!               GTK = LAMBDAF + COEFAF*VITESSE
! IN  NRESE  : NORME DU SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
! IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
! IN  H11T1N : MATRICE
! IN  H21T1N : MATRICE
! IN  H12T2N : MATRICE
! IN  H22T2N : MATRICE
! OUT MATREE : MATRICE ELEMENTAIRE DEPL_E/DEPL_E
! OUT MATRMM : MATRICE ELEMENTAIRE DEPL_M/DEPL_M
! OUT MATRME : MATRICE ELEMENTAIRE DEPL_M/DEPL_E
! OUT MATREM : MATRICE ELEMENTAIRE DEPL_E/DEPL_M
!
! ----------------------------------------------------------------------
!
!
!

    integer :: i, j, k,l, ii, jj
    real(kind=8) :: g(3, 3), e(3, 3), d(3, 3), f(3, 3)
    real(kind=8) :: mprnt1(3,3)
    
    call matini(3, 3, 0.d0, e)
    call matini(3, 3, 0.d0, d)
    call matini(3, 3, 0.d0, g)
    call matini(3, 3, 0.d0, f)
    call matini(3, 3, 0.d0, mprt12)
    call matini(3, 3, 0.d0, mprnt1)
    call matini(3, 3, 0.d0, mprnt2)

!-------e =vech1/vech1  
   e(1,1) = h(1,1)*vech1(1)*vech1(1)
   e(1,2) = h(1,1)*vech1(1)*vech1(2) 
   e(1,3) = h(1,1)*vech1(1)*vech1(3) 
   e(2,1) = h(1,1)*vech1(2)*vech1(1)
   e(2,2) = h(1,1)*vech1(2)*vech1(2)
   e(2,3) = h(1,1)*vech1(2)*vech1(3)
   e(3,1) = h(1,1)*vech1(3)*vech1(1)
   e(3,2) = h(1,1)*vech1(3)*vech1(2)
   e(3,3) = h(1,1)*vech1(3)*vech1(3)
   
!-------d =vech1/vech2  
   d(1,1) = h(1,2)*vech1(1)*vech2(1)
   d(1,2) = h(1,2)*vech1(1)*vech2(2) 
   d(1,3) = h(1,2)*vech1(1)*vech2(3) 
   d(2,1) = h(1,2)*vech1(2)*vech2(1)
   d(2,2) = h(1,2)*vech1(2)*vech2(2)
   d(2,3) = h(1,2)*vech1(2)*vech2(3)
   d(3,1) = h(1,2)*vech1(3)*vech2(1)
   d(3,2) = h(1,2)*vech1(3)*vech2(2)
   d(3,3) = h(1,2)*vech1(3)*vech2(3)
   
!-------g =vech2/vech1  
   g(1,1) = h(2,1)*vech2(1)*vech2(1)
   g(1,2) = h(2,1)*vech2(1)*vech2(2) 
   g(1,3) = h(2,1)*vech2(1)*vech2(3) 
   g(2,1) = h(2,1)*vech2(2)*vech2(1)
   g(2,2) = h(2,1)*vech2(2)*vech2(2)
   g(2,3) = h(2,1)*vech2(2)*vech2(3)
   g(3,1) = h(2,1)*vech2(3)*vech2(1)
   g(3,2) = h(2,1)*vech2(3)*vech2(2)
   g(3,3) = h(2,1)*vech2(3)*vech2(3)      

!-------f =vech2/vech2  
   f(1,1) = h(2,2)*vech2(1)*vech2(1)
   f(1,2) = h(2,2)*vech2(1)*vech2(2) 
   f(1,3) = h(2,2)*vech2(1)*vech2(3) 
   f(2,1) = h(2,2)*vech2(2)*vech2(1)
   f(2,2) = h(2,2)*vech2(2)*vech2(2)
   f(2,3) = h(2,2)*vech2(2)*vech2(3)
   f(3,1) = h(2,2)*vech2(3)*vech2(1)
   f(3,2) = h(2,2)*vech2(3)*vech2(2)
   f(3,3) = h(2,2)*vech2(3)*vech2(3) 

 

!-----------mprnt1
  mprnt1(1,1) = mprt1n(1,1)
  mprnt1(2,2) = mprt1n(2,2)  
  mprnt1(3,3) = mprt1n(3,3)
  mprnt1(1,2) = mprt1n(2,1)
  mprnt1(1,3) = mprt1n(3,1)  
  mprnt1(2,1) = mprt1n(1,2)
  mprnt1(2,3) = mprt1n(3,2)  
  mprnt1(3,1) = mprt1n(1,3)
  mprnt1(3,2) = mprt1n(2,3)      

!-----------mprnt2
  mprnt2(1,1) = mprt2n(1,1)
  mprnt2(2,2) = mprt2n(2,2)  
  mprnt2(3,3) = mprt2n(3,3)
  mprnt2(1,2) = mprt2n(2,1)
  mprnt2(1,3) = mprt2n(3,1)  
  mprnt2(2,1) = mprt2n(1,2)
  mprnt2(2,3) = mprt2n(3,2)  
  mprnt2(3,1) = mprt2n(1,3)
  mprnt2(3,2) = mprt2n(2,3) 
  
  
!
  mprt12      = mprt21

! LES MATRICES KAPPA INFLUENCENT LA CONVERGENCE DE LA METHODE :
! OUT KAPPA  : MATRICE DE SCALAIRES LIEES A LA CINEMATIQUE DU GLISSEMENT
! OUT KAPPA(i,j) = INVERSE[TAU_i.TAU_j-JEU*(ddFFM*geomm)](matrice 2*2) 
! ON LE DEBRANCHE AUTOMATIQUEMENT SI SA VALEUR EST TROP GRANDE COMPARATIVEMENT A MATRME

!
!
! CONTRIBUTION 2 : 
!
do 260 i = 1, nne
    do 250 j = 1, nnm
        do 240 k = 1, ndim
        do 230 l = 1, ndim
            ii = ndim*(i-1)+l
            jj = ndim*(j-1)+k
 matrme(ii,jj) = matrme(ii,jj)         -&
(dlagrc-coefac*jeu)*wpg*jacobi * (&
 mprt11(l,k)*ffe(i)*(kappa(1,1)*kappa(1,1)+kappa(1,2)*kappa(2,1))*(ddffm(1,j)+ddffm(3,j))  + &
 mprt12(l,k)*ffe(i)*(kappa(1,1)*kappa(1,1)+kappa(1,2)*kappa(2,1))*(ddffm(2,j)+ddffm(3,j))   + &
 mprt21(l,k)*ffe(i)*(kappa(1,2)*kappa(1,1)+kappa(2,2)*kappa(1,2))*(ddffm(1,j)+ddffm(3,j))   + &
 mprt22(l,k)*ffe(i)*(kappa(1,2)*kappa(1,1)+kappa(2,2)*kappa(1,2))*(ddffm(3,j)+ddffm(2,j)) )
  
  
 matrme(ii,jj) = matrme(ii,jj)          - &
(dlagrc-coefac*jeu)*wpg*jacobi* (&
 mprt11(l,k)*ffe(i)*(kappa(2,1)*kappa(1,1)+kappa(2,2)*kappa(2,1))*(ddffm(1,j)+ddffm(3,j))  + &
 mprt12(l,k)*ffe(i)*(kappa(2,1)*kappa(1,1)+kappa(2,2)*kappa(2,1))*(ddffm(2,j)+ddffm(3,j))   + &
 mprt21(l,k)*ffe(i)*(kappa(1,2)*kappa(2,1)+kappa(2,2)*kappa(2,2))*(ddffm(1,j)+ddffm(3,j))   + &
 mprt22(l,k)*ffe(i)*(kappa(1,2)*kappa(2,1)+kappa(2,2)*kappa(2,2))*(ddffm(3,j)+ddffm(2,j)) )
  
  
  
230         continue
240         continue
250     continue
260  continue


!
!CONTRIBUTION 3 :
! JEU*{[(delta XI*H)+(NORM.d(delta YPR)/delta XI)]A[(delta XI*H)+&
!(NORM.d(delta YPR)/delta XI)] 
!




end subroutine
