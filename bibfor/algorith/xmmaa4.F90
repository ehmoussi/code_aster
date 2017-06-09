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

subroutine xmmaa4(nnol, pla, ffc, jac, cstaco,&
                  mmat)
!
    implicit none
#include "jeveux.h"
    integer :: nnol, pla(27)
    real(kind=8) :: mmat(216, 216)
    real(kind=8) :: ffc(8), jac, cstaco
!
!
!
! ROUTINE CONTACT (METHODE XFEM HPP - CALCUL ELEM.)
!
! --- CALCUL DE LA MATRICE C - CAS SANS CONTACT
!
! ----------------------------------------------------------------------
!
! IN  NNOL   : NOMBRE DE NOEUDS PORTEURS DE DDLC
! IN  NNOF   : NOMBRE DE NOEUDS DE LA FACETTE DE CONTACT
! IN  PLA    : PLACE DES LAMBDAS DANS LA MATRICE
! IN  IPGF   : NUMÉRO DU POINTS DE GAUSS
! IN  IVFF   : ADRESSE DANS ZR DU TABLEAU FF(INO,IPG)
! IN  FFC    : FONCTIONS DE FORME DE L'ELEMENT DE CONTACT
! IN  JAC    : PRODUIT DU JACOBIEN ET DU POIDS
! IN  NOEUD  : INDICATEUR FORMULATION (T=NOEUDS , F=ARETE)
! IN  CSTACO : COEFFICIENTS DE STABILISATION OU PENALISATION DU CONTACT
! I/O  MMAT  : MATRICE ELEMENTAITRE DE CONTACT/FROTTEMENT
!
!
    integer :: i, j, pli, plj
    real(kind=8) :: ffi, ffj
!
! ----------------------------------------------------------------------
!
    do 120 i = 1, nnol
        pli=pla(i)
        ffi=ffc(i)
!
        do 121 j = 1, nnol
            plj=pla(j)
            ffj=ffc(j)
!
            mmat(pli,plj) = mmat(pli,plj) - ffj * ffi * jac / cstaco
121      continue
120  end do
!
end subroutine
