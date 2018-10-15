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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmgnme(ndim  , nnm   , nne   ,&
                  wpg   , ffe   , dffm  ,&
                  jacobi, coefac, jeu   , dlagrc,&
                  mprnt1, mprnt2,&
                  kappa , vech1 , vech2 , h     ,&
                  matrme)
!
implicit none
!
#include "asterf_types.h"
!
integer, intent(in) :: ndim, nnm, nne
real(kind=8), intent(in) :: wpg, ffe(9),dffm(2,9)
real(kind=8), intent(in) :: jacobi, coefac, jeu, dlagrc
real(kind=8), intent(in) :: mprnt1(3,3), mprnt2(3,3)
real(kind=8), intent(in) :: kappa(2,2), vech1(3), vech2(3), h(2,2)
real(kind=8), intent(inout) :: matrme(27, 27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for first variation of gap [master x slave]
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  nnm              : number of master nodes
! In  nne              : number of slave nodes
! In  wpg              : weight for current Gauss point
! In  dffm             : first derivative of shape function for master nodes
! In  jacobi           : jacobian at integration point
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  jeu              : normal gap
! In  dlagrc           : increment of contact Lagrange from beginning of time step
! In  ffe              : shape function for slave nodes
! In  mprnt1           : projection matrix normal/first tangent
! In  mprnt2           : projection matrix normal/second tangent
! In  kappa            : MATRICE DE SCALAIRES LIEES A LA CINEMATIQUE DU GLISSEMENT
!                        KAPPA(i,j) = INVERSE[tau_i.tau_j-JEU*(ddFFM*geomm)](matrice 2*2)
! In  vech1            : KAPPA(1,m)*tau_m
! In  vech2            : KAPPA(2,m)*tau_m
! In  h                : MATRICE DE SCALAIRES EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
!                        H(i,j) = JEU*{[DDGEOMM(i,j)].n} (matrice 2*2)
! IO  matrme           : matrix for DOF [master x slave]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, k,l, ii, jj
    real(kind=8) :: g(3, 3), e(3, 3), d(3, 3), f(3, 3)
    real(kind=8) :: supkap, supmat, alpha
!
! --------------------------------------------------------------------------------------------------
!
    alpha  = 1.d-5
    e(:,:) = 0.d0
    d(:,:) = 0.d0
    g(:,:) = 0.d0
    f(:,:) = 0.d0
!
    e(1,1) = h(1,1)*vech1(1)*vech1(1)
    e(1,2) = h(1,1)*vech1(1)*vech1(2)
    e(1,3) = h(1,1)*vech1(1)*vech1(3)
    e(2,1) = h(1,1)*vech1(2)*vech1(1)
    e(2,2) = h(1,1)*vech1(2)*vech1(2)
    e(2,3) = h(1,1)*vech1(2)*vech1(3)
    e(3,1) = h(1,1)*vech1(3)*vech1(1)
    e(3,2) = h(1,1)*vech1(3)*vech1(2)
    e(3,3) = h(1,1)*vech1(3)*vech1(3)
!
    d(1,1) = h(1,2)*vech1(1)*vech2(1)
    d(1,2) = h(1,2)*vech1(1)*vech2(2)
    d(1,3) = h(1,2)*vech1(1)*vech2(3)
    d(2,1) = h(1,2)*vech1(2)*vech2(1)
    d(2,2) = h(1,2)*vech1(2)*vech2(2)
    d(2,3) = h(1,2)*vech1(2)*vech2(3)
    d(3,1) = h(1,2)*vech1(3)*vech2(1)
    d(3,2) = h(1,2)*vech1(3)*vech2(2)
    d(3,3) = h(1,2)*vech1(3)*vech2(3)
!
    g(1,1) = h(2,1)*vech2(1)*vech2(1)
    g(1,2) = h(2,1)*vech2(1)*vech2(2)
    g(1,3) = h(2,1)*vech2(1)*vech2(3)
    g(2,1) = h(2,1)*vech2(2)*vech2(1)
    g(2,2) = h(2,1)*vech2(2)*vech2(2)
    g(2,3) = h(2,1)*vech2(2)*vech2(3)
    g(3,1) = h(2,1)*vech2(3)*vech2(1)
    g(3,2) = h(2,1)*vech2(3)*vech2(2)
    g(3,3) = h(2,1)*vech2(3)*vech2(3)
!
    f(1,1) = h(2,2)*vech2(1)*vech2(1)
    f(1,2) = h(2,2)*vech2(1)*vech2(2) 
    f(1,3) = h(2,2)*vech2(1)*vech2(3) 
    f(2,1) = h(2,2)*vech2(2)*vech2(1)
    f(2,2) = h(2,2)*vech2(2)*vech2(2)
    f(2,3) = h(2,2)*vech2(2)*vech2(3)
    f(3,1) = h(2,2)*vech2(3)*vech2(1)
    f(3,2) = h(2,2)*vech2(3)*vech2(2)
    f(3,3) = h(2,2)*vech2(3)*vech2(3)
!
! LES MATRICES KAPPA INFLUENCENT LA CONVERGENCE DE LA METHODE :
! ON LE DEBRANCHE AUTOMATIQUEMENT SI SA VALEUR EST TROP GRANDE COMPARATIVEMENT A MATREE
!
    supkap = kappa(1,1)
    do i = 1, 2
        do j = 1, 2
            if (kappa(i,j) .ge. supkap) supkap = kappa(i,j)
        end do
    end do
    supmat = matrme(1,1)
    do i = 1, 27
        do j= 1, 27
            if (matrme(i,j) .ge. supmat) supmat = matrme(i,j)
        end do
    end do
!
    if (supkap .le. (alpha*supmat)) then 
! ----- CONTRIBUTION 1 :
! ----- -NORM{[d(delta YPR)/delta XI)*DELTA XI]+[(D(DELTA YPR)/DELTA XI)*delta XI]}
        do i = 1, nnm
            do j = 1, nne
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matrme(ii,jj) = matrme(ii,jj)    + &
                        (dlagrc-coefac*jeu)*wpg*jacobi*ffe(i)*(dffm(1,j)*&
                         (mprnt1(l,k)*kappa(1,1)+mprnt2(l,k)*kappa(2,1))+&
                         dffm(2,j)*&
                         (mprnt2(l,k)*kappa(1,2)+mprnt2(l,k)*kappa(2,2))  )
                    end do
                end do
            end do
        end do
! ----- CONTRIBUTION 2 :
! ----- DELTA XI*H*delta XI MATREM = 0
! ----- CONTRIBUTION 3 :
! ----- JEU*{[(delta XI*H)+(NORM.d(delta YPR)/delta XI)]A[(delta XI*H)+(NORM.d(delta YPR)/delta XI)]
    endif
!
end subroutine
