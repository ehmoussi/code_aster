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

subroutine xmvef4(ndim, nnol, pla, ffc, reac12,&
                  jac, tau1, tau2, lact, vtmp)
!
    implicit none
#include "jeveux.h"
#include "asterfort/vecini.h"
#include "blas/ddot.h"
    integer :: ndim, nnol
    integer ::  pla(27), lact(8)
    real(kind=8) :: vtmp(400), tau1(3), tau2(3)
    real(kind=8) :: ffc(8), jac, reac12(3)
!
!
!
! ROUTINE CONTACT (METHODE XFEM HPP - CALCUL ELEM.)
!
! --- CALCUL DU VECTEUR LN3
!
! ----------------------------------------------------------------------
!
! IN  NDIM   : DIMENSION DE L'ESPACE
! IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT DE REF PARENT
! IN  NNOS   : NOMBRE DE NOEUDS SOMMET DE L'ELEMENT DE REF PARENT
! IN  NNOL   : NOMBRE DE NOEUDS PORTEURS DE DDLC
! IN  NNOF   : NOMBRE DE NOEUDS DE LA FACETTE DE CONTACT
! IN  PLA    : PLACE DES LAMBDAS DANS LA MATRICE
! IN  IPGF   : NUMÉRO DU POINTS DE GAUSS
! IN  IVFF   : ADRESSE DANS ZR DU TABLEAU FF(INO,IPG)
! IN  FFC    : FONCTIONS DE FORME DE L'ELEMENT DE CONTACT
! IN  FFP    : FONCTIONS DE FORME DE L'ELEMENT PARENT
! IN  IDEPD  :
! IN  IDEPM  :
! IN  NFH    : NOMBRE DE FONCTIONS HEAVYSIDE
! IN  NOEUD  : INDICATEUR FORMULATION (T=NOEUDS , F=ARETE)
! IN  TAU1   : TANGENTE A LA FACETTE AU POINT DE GAUSS
! IN  TAU2   : TANGENTE A LA FACETTE AU POINT DE GAUSS
! IN  SINGU  : 1 SI ELEMENT SINGULIER, 0 SINON
! IN  RR     : DISTANCE AU FOND DE FISSURE
! IN  IFA    : INDICE DE LA FACETTE COURANTE
! IN  CFACE  : CONNECTIVITÉ DES NOEUDS DES FACETTES
! IN  LACT   : LISTE DES LAGRANGES ACTIFS
! IN  DDLS   : NOMBRE DE DDL (DEPL+CONTACT) À CHAQUE NOEUD SOMMET
! IN  DDLM   : NOMBRE DE DDL A CHAQUE NOEUD MILIEU
! IN  RHOTK  :
! IN  CSTAFR : COEFFICIENTS DE STABILISATION DU FROTTEMENT
! IN  CPENFR : COEFFICIENTS DE PENALISATION DU FROTTEMENT
! IN  LPENAF : INDICATEUR DE PENALISATION DU FROTTEMENT
! IN  P      :
! OUT ADHER  :
! OUT KNP    : PRODUIT KN.P
! OUT PTKNP  : MATRICE PT.KN.P
! OUT IK     :
!
!
!
!
!
    integer :: i, k, pli, nli
    real(kind=8) :: ffi, tt(3)
!
! ----------------------------------------------------------------------
!
    call vecini(3, 0.d0, tt)
    do 165 i = 1, nnol
        pli=pla(i)
        ffi=ffc(i)
        nli=lact(i)
        if (nli .eq. 0) goto 165
!
        tt(1)=ddot(ndim,tau1(1),1,reac12,1)
        if (ndim .eq. 3) tt(2)=ddot(ndim,tau2(1),1,reac12,1)
        do 167 k = 1, ndim-1
            vtmp(pli+k) = vtmp(pli+k) + tt(k)*ffi*jac
167      continue
165  continue
!
end subroutine
