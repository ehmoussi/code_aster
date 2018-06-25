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

subroutine mmgtuu(ndim  ,nne   ,norm, nnm   ,mprt1n, &
              mprt2n,mprojn,mprt11,mprt21,mprt22, &
          wpg   ,ffe   ,ffm   ,dffm  ,ddffm,jacobi, &
          coefac,jeu   ,dlagrc,kappa ,vech1 , &
          vech2 ,h     ,ha ,hah   , &
          matree,matrmm,matrem, matrme)
!
! person_in_charge: mickael.abbas at edf.fr
!
! aslint: disable=W1504
    implicit     none
#include "asterfort/mmgtem.h"
#include "asterfort/mmgtme.h"
#include "asterfort/mmgtmm.h"
    
    integer :: ndim, nne, nnm
    
    real(kind=8) :: mprojn(3, 3)
    real(kind=8) :: mprt1n(3, 3), mprt2n(3, 3)
    real(kind=8) :: mprt11(3, 3), mprt21(3, 3), mprt22(3, 3)
    
    real(kind=8) :: ffe(9), ffm(9), dffm(2, 9),ddffm(3,9)
    real(kind=8) :: wpg, jacobi
    real(kind=8) :: coefac, jeu, dlagrc
    
    real(kind=8) :: kappa(2,2),h(2,2),hah(2,2),ha(2,2),a(2,2)
    real(kind=8) :: vech1(3),vech2(3),norm(3)
    
    real(kind=8) :: matrem(27, 27), matrme(27, 27)
    real(kind=8) :: matree(27, 27), matrmm(27, 27)
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
! OUT MATREE : MATRICE ELEMENTAIRE DEPL_E/DEPL_E
! OUT MATRMM : MATRICE ELEMENTAIRE DEPL_M/DEPL_M
! OUT MATRME : MATRICE ELEMENTAIRE DEPL_M/DEPL_E
! OUT MATREM : MATRICE ELEMENTAIRE DEPL_E/DEPL_M
!
! ----------------------------------------------------------
!  IL Y A 3 CONTRIBUTIONS VENANT DE LA SECONDE VARIATION DE LA NORMALE
!  ETUDE DE REFERENCE : V. YASTREBOV THESIS
!
!  CONTRIBUTION 1 : -NORM{[d(delta YPR)/delta XI)*DELTA XI]+&
![(D(DELTA YPR)/DELTA XI)*delta XI]}
!  CONTRIBUTION 2 :  DELTA XI*H*delta XI
!  CONTRIBUTION 3 : JEU*{[(delta XI*H)+&
!(NORM.d(delta YPR)/delta XI)]A[(delta XI*H)+(NORM.d(delta YPR)/delta XI)] 
!-------------------------------------------------
!
!

  

! --- DEPL_ESCL/DEPL_ESCL

 !  MATREE = Linearisation du 2eme terme du Dd xi glissement de Coulomb sur matree nul. On ne le cree pas


! --- DEPL_MAIT/DEPL_MAIT
!
!
    call mmgtmm(ndim  ,nnm ,norm, mprt1n,mprt2n, &
                 mprojn,wpg   , &
         ffm    ,dffm  ,ddffm,jacobi,coefac,jeu   , &
         dlagrc,kappa ,vech1 ,vech2 ,h   , &
         mprt11,mprt21,mprt22,matrmm)

! --- DEPL_ESCL/DEPL_MAIT
!
       call mmgtem(ndim  ,nnm   ,nne,mprt1n,mprt2n, &
                  wpg   , &
          ffe,dffm  ,ddffm,jacobi,coefac,jeu   , &
          dlagrc,kappa ,vech1 ,vech2 ,h     , &
          mprt11,mprt21,mprt22,matrem)
!
! --- DEPL_MAIT/DEPL_ESCL
!
       call mmgtme(ndim  ,nnm   ,nne,mprt1n,mprt2n, &
                  wpg   , &
          ffe,dffm  ,ddffm,jacobi,coefac,jeu   , &
          dlagrc,kappa ,vech1 ,vech2 ,h     , &
          mprt11,mprt21,mprt22,matrme)
!
end subroutine
