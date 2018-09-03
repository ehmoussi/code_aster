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

subroutine mmmtuu(phasep,ndim  ,nne   ,nnm   ,mprojn, &
              mprojt,wpg   ,ffe   ,ffm, &
          jacobi,coefac,coefaf,coefff,rese  , &
          nrese ,lambda,matree, &
          matrmm, matrem, matrme)
!
! person_in_charge: mickael.abbas at edf.fr
!

    implicit     none
#include "asterfort/mmmtee.h"
#include "asterfort/mmmtem.h"
#include "asterfort/mmmtme.h"
#include "asterfort/mmmtmm.h"
    character(len=9) :: phasep
    integer :: ndim, nne, nnm
    real(kind=8) :: mprojn(3, 3), mprojt(3, 3)
    real(kind=8) :: ffe(9), ffm(9)
    real(kind=8) :: wpg, jacobi
    real(kind=8) :: rese(3), nrese
    real(kind=8) :: coefac, coefaf
    real(kind=8) :: lambda, coefff
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
!
! --- DEPL_ESCL/DEPL_ESCL
!
    call mmmtee(phasep,ndim  ,nne   ,mprojn,mprojt, &
                wpg   ,ffe   ,jacobi,coefac,coefaf, &
                coefff,rese  ,nrese ,lambda,matree)
!
! --- DEPL_MAIT/DEPL_MAIT
!
    call mmmtmm(phasep,ndim  ,nnm   ,mprojn,mprojt, &
                  wpg   ,ffm    ,jacobi,coefac, &
          coefaf,coefff,rese  ,nrese ,lambda, &
          matrmm)
!
! --- DEPL_ESCL/DEPL_MAIT
!
    call mmmtem(phasep,ndim  ,nne   ,nnm   ,mprojn, &
                  mprojt,wpg   ,ffe   ,ffm   , &
          jacobi,coefac,coefaf,coefff,rese  , &
          nrese, lambda, matrem)
!
! --- DEPL_MAIT/DEPL_ESCL
!
    call mmmtme(phasep,ndim  ,nne   ,nnm   ,mprojn, &
                  mprojt,wpg   ,ffe   ,ffm   , &
          jacobi,coefac,coefaf,coefff,rese  , &
          nrese, lambda,  matrme)
!
end subroutine
