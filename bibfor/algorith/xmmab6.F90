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

subroutine xmmab6(ndim, nnol, pla, ffc, jac,&
                  tau1, tau2, lact, mmat)
!
    implicit none
#include "blas/ddot.h"
    integer :: ndim, nnol
    integer :: pla(27), lact(8)
    real(kind=8) :: mmat(216, 216)
    real(kind=8) :: ffc(8), jac, tau1(3), tau2(3)
!
!
!
! ROUTINE CONTACT (METHODE XFEM HPP - CALCUL ELEM.)
!
! --- CALCUL DE LA MATRICE F - CAS SANS CONTACT
!
! ----------------------------------------------------------------------
!
! IN  NDIM   : DIMENSION DE L'ESPACE
! IN  NNOL   : NOMBRE DE NOEUDS PORTEURS DE DDLC
! IN  NNOF   : NOMBRE DE NOEUDS DE LA FACETTE DE CONTACT
! IN  PLA    : PLACE DES LAMBDAS DANS LA MATRICE
! IN  IPGF   : NUMÉRO DU POINTS DE GAUSS
! IN  IVFF   : ADRESSE DANS ZR DU TABLEAU FF(INO,IPG)
! IN  FFC    : FONCTIONS DE FORME DE L'ELEMENT DE CONTACT
! IN  JAC    : PRODUIT DU JACOBIEN ET DU POIDS
! IN  NOEUD  : INDICATEUR FORMULATION (T=NOEUDS , F=ARETE)
! IN  TAU1   : TANGENTE A LA FACETTE AU POINT DE GAUSS
! IN  TAU2   : TANGENTE A LA FACETTE AU POINT DE GAUSS
! IN  IFA    : INDICE DE LA FACETTE COURANTE
! IN  CFACE  : CONNECTIVITÉ DES NOEUDS DES FACETTES
! IN  LACT   : LISTE DES LAGRANGES ACTIFS
! I/O MMAT   : MATRICE ELEMENTAITRE DE CONTACT/FROTTEMENT
!
!
!
!
    integer :: i, j, k, l, nli, nlj
    integer :: pli, plj
    real(kind=8) :: ffi, ffj, metr(2, 2)
!
! ----------------------------------------------------------------------
!
    do i = 1, nnol
        pli=pla(i)
        ffi=ffc(i)
        nli=lact(i)
        if (nli .eq. 0) cycle
!
        do j = 1, nnol
            plj=pla(j)
            ffj=ffc(j)
            nlj=lact(j)
            if (nlj .eq. 0) cycle
!
! --- MÉTRIQUE DE LA BASE COVARIANTE AUX PTS D'INTERSECT
!
            metr(1,1)=ddot(ndim,tau1(1),1,tau1(1),1)
            if (ndim .eq. 3) then
                metr(1,2)=ddot(ndim,tau1(1),1,tau2(1),1)
                metr(2,1)=ddot(ndim,tau2(1),1,tau1(1),1)
                metr(2,2)=ddot(ndim,tau2(1),1,tau2(1),1)
            endif
!
            do k = 1, ndim-1
                do l = 1, ndim-1
                    mmat(pli+k,plj+l) = mmat(pli+k,plj+l)+ffi*ffj*metr(k,l)*jac
                end do
            end do
        end do
    end do
!
end subroutine
