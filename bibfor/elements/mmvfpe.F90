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

subroutine mmvfpe(phasep, ndim, nne, nnm, norm,&
                  tau1, tau2, mprojt, wpg, ffe,&
                  ffm, jacobi, jeu, coefac, coefaf,&
                  lambda, coefff, dlagrc, dlagrf, dvite,&
                  rese, nrese,&
                    vectee, vectmm,mprt11,mprt21,mprt22,mprt1n,mprt2n,kappa,granglis)
!
! person_in_charge: mickael.abbas at edf.fr
!
! aslint: disable=W1504
    implicit none
#include "asterfort/mmmvuu.h"
    character(len=9) :: phasep
    integer :: ndim, nne, nnm,granglis
    real(kind=8) :: wpg, ffe(9), ffm(9), jacobi
    real(kind=8) :: dlagrc, dlagrf(2), dvite(3),kappa(2,2)
    real(kind=8) :: rese(3), nrese
    real(kind=8) :: norm(3)
    real(kind=8) :: tau1(3), tau2(3), mprojt(3, 3)
    real(kind=8) :: coefac, coefaf, jeu
    real(kind=8) :: lambda, coefff
    real(kind=8) :: vectee(27), vectmm(27)
        real(kind=8) :: mprt11(3, 3), mprt21(3, 3), mprt22(3, 3)
    real(kind=8) :: mprt1n(3,3),mprt2n(3,3)  

!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
!
! CALCUL DES VECTEURS - EQUATION EQUILIBRE - CAS POIN_ELEM
!
! ----------------------------------------------------------------------
!
!
! IN  PHASEP : 'SANS' - PAS DE CONTACT
!              'CONT' - CONTACT
!              'ADHE' - CONTACT ADHERENT
!              'GLIS' - CONTACT GLISSANT
!              'SANS_PENA' - PENALISATION - PAS DE CONTACT
!              'CONT_PENA' - PENALISATION - CONTACT
!              'ADHE_PENA' - PENALISATION - CONTACT ADHERENT
!              'GLIS_PENA' - PENALISATION - CONTACT GLISSANT
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNE    : NOMBRE DE NOEUDS ESCLAVE
! IN  NNM    : NOMBRE DE NOEUDS MAITRES
! IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFE    : FONCTIONS DE FORMES DEPL_ESCL
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
! OUT VECTEE : VECTEUR ELEMENTAIRE DEPL_ESCL
! OUT VECTMM : VECTEUR ELEMENTAIRE DEPL_MAIT
!
! ----------------------------------------------------------------------
!
    call mmmvuu(phasep, ndim, nne, nnm, norm,&
                tau1, tau2, mprojt, wpg, ffe,&
                ffm, jacobi, jeu, coefac, coefaf,&
                lambda, coefff, dlagrc, dlagrf, dvite,&
                rese, nrese, vectee, vectmm,mprt11,mprt21,mprt22,mprt1n,mprt2n,kappa,granglis)
!
end subroutine
