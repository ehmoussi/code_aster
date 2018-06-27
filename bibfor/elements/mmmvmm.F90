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

subroutine mmmvmm(phasez, ndim, nnm, norm, tau1,&
                  tau2, mprojt, wpg, ffm, jacobi,&
                  jeu, coefac, coefaf, lambda, coefff,&
                  dlagrc, dlagrf, dvite, rese, nrese,&
                  vectmm,mprt11,mprt21,mprt22,mprt1n,mprt2n,kappa)
!
! person_in_charge: mickael.abbas at edf.fr
!
! aslint: disable=W1504
    implicit none
#include "asterfort/assert.h"
    character(len=*) :: phasez
    integer :: ndim, nnm
    real(kind=8) :: wpg, ffm(9), jacobi
    real(kind=8) :: dlagrc, dlagrf(2), dvite(3)
    real(kind=8) :: rese(3), nrese
    real(kind=8) :: norm(3),kappa(2,2)
    real(kind=8) :: tau1(3), tau2(3), mprojt(3, 3)
    real(kind=8) :: coefac, coefaf, jeu
    real(kind=8) :: lambda, coefff,dffm(2, 9)
    real(kind=8) :: vectmm(27),matr(27)
    real(kind=8) :: mprt1n(3,3),mprt2n(3,3)  
    real(kind=8) :: mprt11(3, 3), mprt21(3, 3), mprt22(3, 3) 
    
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DU VECTEUR DEPL_MAIT
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
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNM    : NOMBRE DE NOEUDS MAITRES
! IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFM    : FONCTIONS DE FORMES DEPL_MAIT
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! IN  JEU    : VALEUR DU JEU
! IN  NORM   : NORMALE
! IN  COEFAC : COEF_AUGM_CONT
! IN  COEFAF : COEF_AUGM_FROT
! IN  LAMBDA : VALEUR DU MULT. DE CONTACT (SEUIL DE TRESCA)
! IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
! IN  DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
! IN  DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
! IN  DVITE  : SAUT DE "VITESSE" [[DELTA X]]
! IN  RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
!               GTK = LAMBDAF + COEFAF*VITESSE
! IN  NRESE  : NORME DU SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
! IN  TAU1   : PREMIER VECTEUR TANGENT
! IN  TAU2   : SECOND VECTEUR TANGENT
! IN  MPROJT : MATRICE DE PROJECTION TANGENTE
! OUT VECTMM : VECTEUR ELEMENTAIRE DEPL_MAIT
!
! ----------------------------------------------------------------------
!
    integer :: inom, idim, ii, i, j, k,granglis
    real(kind=8) :: dlagft(3), plagft(3), prese(3), prese1(3), prese2(3)
    real(kind=8) :: dvitet(3), pdvitt(3), g(3, 3), g1(3, 3), g2(3, 3)
    character(len=9) :: phasep
    real(kind=8) :: mprt12(3, 3)
!
! ----------------------------------------------------------------------
!
    phasep = phasez
    do  i = 1, 3
        plagft(i) = 0.d0
        dlagft(i) = 0.d0
        prese (i) = 0.d0
        dvitet(i) = 0.d0
        pdvitt(i) = 0.d0
  end do

  mprt12(1,1) = mprt21(1,1)
  mprt12(2,2) = mprt21(2,2)  
  mprt12(3,3) = mprt21(3,3)
  mprt12(1,2) = mprt21(2,1)
  mprt12(1,3) = mprt21(3,1)  
  mprt12(2,1) = mprt21(1,2)
  mprt12(2,3) = mprt21(3,2)  
  mprt12(3,1) = mprt21(1,3)
  mprt12(3,2) = mprt21(2,3)  
  matr = 0.
  granglis = 1
! --- PROJECTION DU LAGRANGE DE FROTTEMENT SUR LE PLAN TANGENT
!
    do  i = 1, ndim
        dlagft(i) = dlagrf(1)*tau1(i)+dlagrf(2)*tau2(i)
  end do
!
! --- PRODUIT LAGR. FROTTEMENT. PAR MATRICE P
!
    do  i = 1, ndim
        do  j = 1, ndim
            plagft(i) = mprojt(i,j)*dlagft(j)+plagft(i)
      enddo
  end do
!
! --- PRODUIT SEMI MULT. LAGR. FROTTEMENT. PAR MATRICE P
!
    if (phasep(1:4) .eq. 'GLIS') then
        do  i = 1, ndim
            do  j = 1, ndim
                if (granglis .eq. 1) then
                   g(i,j) =kappa(1,1)*mprt11(i,j)+kappa(1,2)*mprt12(i,j)&
                          +kappa(2,1)*mprt21(i,j)+kappa(2,2)*mprt22(i,j)
                   g1(i,j)=kappa(1,1)*mprt1n(i,j)*jeu+kappa(2,1)*mprt2n(i,j)*jeu
                   g2(i,j)=kappa(2,2)*mprt2n(i,j)*jeu+kappa(1,2)*mprt1n(i,j)*jeu
                   prese(i)  = g(i,j)*rese(j)/nrese+prese(i)
                   prese1(i) = g1(i,j)*rese(j)/nrese+prese1(i)
                   prese2(i) = g2(i,j)*rese(j)/nrese+prese2(i)
                else
                    prese(i) = mprojt(i,j)*rese(j)/nrese+prese(i)
                endif
          enddo
      enddo
    endif
!
! --- PROJECTION DU SAUT SUR LE PLAN TANGENT
!
    do  i = 1, ndim
        do  k = 1, ndim
            dvitet(i) = mprojt(i,k)*dvite(k)+dvitet(i)
      enddo
  end do
!
! --- PRODUIT SAUT PAR MATRICE P
!
    do  i = 1, ndim
        do  j = 1, ndim
            pdvitt(i) = mprojt(i,j)*dvitet(j)+pdvitt(i)
      enddo
  end do
!
! --- CALCUL DES TERMES
!
    if (phasep(1:4) .eq. 'SANS') then
! --- PAS DE CONTRIBUTION
    else if (phasep(1:4).eq.'CONT') then
        if (phasep(6:9) .eq. 'PENA') then
            do  inom = 1, nnm
                do  idim = 1, ndim
                    ii = ndim*(inom-1)+idim
                    vectmm(ii) = vectmm(ii)- wpg*ffm(inom)*jacobi* norm(idim)* jeu*coefac
              enddo
          enddo
        else
            do  inom = 1, nnm
                do  idim = 1, ndim
                    ii = ndim*(inom-1)+idim
                    vectmm(ii) = vectmm(ii)+ wpg*ffm(inom)*jacobi* norm(idim)* (dlagrc-jeu*coefac&
                                 &)
              enddo
          enddo
        endif
!
    else if (phasep(1:4).eq.'GLIS') then
        do  inom = 1, nnm
            do  idim = 1, ndim
                ii = ndim*(inom-1)+idim
                if (granglis .eq. 1) then 
                     matr(ii)=ffm(inom)*prese( idim)+1.* dffm(1,inom)*&
                     prese1( idim)+1.*dffm(2,inom)*prese2( idim)  
                     vectmm(ii) = vectmm(ii)+ wpg*matr(ii)*jacobi* (lambda-0.*jeu)*coefff
                else
                    vectmm(ii) = vectmm(ii)+ wpg*ffm(inom)*jacobi*prese( idim)* lambda*coefff
                endif
          enddo
      enddo
!
    else if (phasep(1:4).eq.'ADHE') then
        if (phasep(6:9) .eq. 'PENA') then
            do  inom = 1, nnm
                do  idim = 1, ndim
                    ii = ndim*(inom-1)+idim
                    vectmm(ii) = vectmm(ii)+ wpg*ffm(inom)*jacobi* pdvitt(idim)* lambda*coefff*co&
                                 &efaf
              enddo
          enddo
        else
            do  inom = 1, nnm
                do  idim = 1, ndim
                    ii = ndim*(inom-1)+idim
                    vectmm(ii) = vectmm(ii)+ wpg*ffm(inom)*jacobi*&
                    (lambda-0.*jeu)*coefff* (plagft(idim)+p&
                                 &dvitt(idim)*coefaf)
              enddo
          enddo
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
