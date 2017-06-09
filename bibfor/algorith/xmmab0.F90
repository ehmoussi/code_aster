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

subroutine xmmab0(ndim, nnc, jnne,&
                  hpg, ffc, jacobi, lpenac,&
                  tau1, tau2, jddle,&
                  nfhe, lmulti, heavno, mmat)
!
!
    implicit none
#include "asterf_types.h"
#include "asterfort/xplma2.h"
    integer :: ndim, nnc, jnne(3), jddle(2)
!
    real(kind=8) :: hpg, ffc(8), jacobi
    real(kind=8) :: tau1(3), tau2(3)
    real(kind=8) :: mmat(336, 336)
    integer :: nfhe, heavno(8)
    aster_logical :: lpenac, lmulti
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
!
! CALCUL DE F POUR LE CONTACT METHODE CONTINUE
! CAS SANS CONTACT (XFEM)
!
! ----------------------------------------------------------------------
! ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
! TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
! ----------------------------------------------------------------------
!
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFC    : FONCTIONS DE FORME DU POINT DE CONTACT
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! IN  TAU1   : PREMIER VECTEUR TANGENT
! IN  TAU2   : DEUXIEME VECTEUR TANGENT
! IN  NDDLSE : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
! I/O MMAT   : MATRICE ELEMENTAIRE DE CONTACT/FROTTEMENT
!
! ----------------------------------------------------------------------
!
    integer :: i, j, k, l, ii, jj, pli, plj
    integer :: nne, nnes, ddles
    real(kind=8) :: tt(2, 2)
!
! ----------------------------------------------------------------------
!
! --- INITIALISATIONS
    nne=jnne(1)
    nnes=jnne(2)
    ddles=jddle(1)
!
    do 300 i = 1, 2
        do 290 j = 1, 2
            tt(i,j) = 0.d0
290     continue
300 continue
!
! --- MATRICE
!
    do 301 i = 1, ndim
        tt(1,1) = tau1(i)*tau1(i) + tt(1,1)
        tt(1,2) = tau1(i)*tau2(i) + tt(1,2)
        tt(2,1) = tau2(i)*tau1(i) + tt(2,1)
        tt(2,2) = tau2(i)*tau2(i) + tt(2,2)
301 continue
!
    do 284 i = 1, nnc
        do 283 j = 1, nnc
            call xplma2(ndim, nne, nnes, ddles, i,&
                        nfhe, pli)
            if (lmulti) pli = pli + (heavno(i)-1)*ndim
            call xplma2(ndim, nne, nnes, ddles, j,&
                        nfhe, plj)
            if (lmulti) plj = plj + (heavno(j)-1)*ndim
            do 282 l = 1, ndim-1
                do 281 k = 1, ndim-1
                    ii = pli+l
                    jj = plj+k
                    if (lpenac) then
                        mmat(ii,jj) = hpg*ffc(i)*ffc(j)* jacobi*tt(l, k)
                    else
                        mmat(ii,jj) = hpg*ffc(i)*ffc(j)* jacobi*tt(l, k)
                    endif
281             continue
282         continue
283     continue
284 continue
!
end subroutine
