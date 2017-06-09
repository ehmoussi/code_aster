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

subroutine mmmtfu(phasep, ndim, nnl, nne, nnm,&
                  nbcps, wpg, jacobi, ffl, ffe,&
                  ffm, tau1, tau2, mprojt, rese,&
                  nrese, lambda, coefff, matrfe, matrfm)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/mmmtfe.h"
#include "asterfort/mmmtfm.h"
    character(len=9) :: phasep
    integer :: ndim, nne, nnl, nnm, nbcps
    real(kind=8) :: ffe(9), ffl(9), ffm(9)
    real(kind=8) :: wpg, jacobi
    real(kind=8) :: tau1(3), tau2(3)
    real(kind=8) :: rese(3), nrese
    real(kind=8) :: mprojt(3, 3)
    real(kind=8) :: lambda
    real(kind=8) :: coefff
    real(kind=8) :: matrfe(18, 27), matrfm(18, 27)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DES MATRICES LAGR_F/DEPL
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
! IN  NBCPS  : NB DE DDL DE LAGRANGE
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  NNL    : NOMBRE DE NOEUDS DE LAGRANGE
! IN  TAU1   : PREMIER VECTEUR TANGENT
! IN  TAU2   : SECOND VECTEUR TANGENT
! IN  MPROJT : MATRICE DE PROJECTION TANGENTE
! IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFM    : FONCTIONS DE FORMES DEPL. MAIT.
! IN  FFE    : FONCTIONS DE FORMES DEPL. ESCL.
! IN  FFL    : FONCTIONS DE FORMES LAGR.
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! IN  RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
!               GTK = LAMBDAF + COEFAF*VITESSE
! IN  NRESE  : RACINE DE LA NORME DE RESE
! IN  LAMBDA : VALEUR DU MULT. DE CONTACT (SEUIL DE TRESCA)
! IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
! OUT MATRFE : MATRICE ELEMENTAIRE LAGR_F/DEPL_E
! OUT MATRFM : MATRICE ELEMENTAIRE LAGR_F/DEPL_M
!
! ----------------------------------------------------------------------
!
!
! --- LAGR_F/DEPL_E
!
    call mmmtfe(phasep, ndim, nne, nnl, nbcps,&
                wpg, jacobi, ffe, ffl, tau1,&
                tau2, mprojt, rese, nrese, lambda,&
                coefff, matrfe)
!
! --- LAGR_F/DEPL_M
!
    call mmmtfm(phasep, ndim, nnm, nnl, nbcps,&
                wpg, jacobi, ffm, ffl, tau1,&
                tau2, mprojt, rese, nrese, lambda,&
                coefff, matrfm)
!
end subroutine
