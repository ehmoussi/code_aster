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
! aslint: disable=W1504
!
subroutine mmgtmm(ndim  , nnm   ,&
                  wpg   , ffm   , dffm  , ddffm ,&
                  jacobi, coefac, jeu   , dlagrc,&
                  mprt1n, mprt2n, mprnt1, mprnt2,&
                  kappa , vech1 , vech2 , h     ,&
                  mprt11, mprt12, mprt21, mprt22,&
                  matrmm)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/mmmmpb.h"
#include "asterfort/pmat.h"
#include "asterfort/pmavec.h"
!
integer, intent(in) :: ndim, nnm
real(kind=8), intent(in) :: wpg, ffm(9), dffm(2,9), ddffm(3,9)
real(kind=8), intent(in) :: jacobi, coefac, jeu, dlagrc
real(kind=8), intent(in) :: mprt1n(3,3), mprt2n(3,3), mprnt1(3,3), mprnt2(3,3)
real(kind=8), intent(in) :: kappa(2,2), vech1(3), vech2(3), h(2,2)
real(kind=8), intent(in) :: mprt11(3, 3), mprt12(3,3), mprt21(3, 3), mprt22(3, 3)
real(kind=8), intent(inout) :: matrmm(27, 27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for second variation of gap [master x master]
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  nnm              : number of master nodes
! In  wpg              : weight for current Gauss point
! In  ffm              : shape function for master nodes
! In  dffm             : first derivative of shape function for master nodes
! In  ddffm            : second derivative of shape function for master nodes
! In  jacobi           : jacobian at integration point
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  jeu              : normal gap
! In  dlagrc           : increment of contact Lagrange from beginning of time step
! In  mprt1n           : projection matrix first tangent/normal
! In  mprt2n           : projection matrix second tangent/normal
! In  mprnt1           : projection matrix normal/first tangent
! In  mprnt2           : projection matrix normal/second tangent
! In  kappa            : MATRICE DE SCALAIRES LIEES A LA CINEMATIQUE DU GLISSEMENT
!                        KAPPA(i,j) = INVERSE[tau_i.tau_j-JEU*(ddFFM*geomm)](matrice 2*2)
! In  vech1            : KAPPA(1,m)*tau_m
! In  vech2            : KAPPA(2,m)*tau_m
! In  h                : MATRICE DE SCALAIRES EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
!                        H(i,j) = JEU*{[DDGEOMM(i,j)].n} (matrice 2*2)
! In  mprt11           : projection matrix first tangent/first tangent
!                        tau1*TRANSPOSE(tau1)(matrice 3*3)
! In  mprt12           : projection matrix first tangent/second tangent
!                        tau1*TRANSPOSE(tau2)(matrice 3*3)
! In  mprt21           : Projection matrix second tangent/first tangent
!                        tau2*TRANSPOSE(tau1)(matrice 3*3)
! In  mprt22           : Projection matrix second tangent/second tangent
!                        tau2*TRANSPOSE(tau2)(matrice 3*3)
! IO  matrmm           : matrix for DOF [master x master]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, k,l, ii, jj
    real(kind=8) :: g(3, 3), e(3, 3), d(3, 3), f(3, 3)
!
! --------------------------------------------------------------------------------------------------
!
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
! - CONTRIBUTION 1 :
!
    do i = 1, nnm
        do j = 1, nnm
            do k = 1, ndim
                do l = 1, ndim
                    ii = ndim*(i-1)+l
                    jj = ndim*(j-1)+k
! ----------------- terme  pour xi1
                    matrmm(ii,jj) = matrmm(ii,jj) + &
                        (dlagrc-coefac*jeu)*wpg*jacobi *(-1.d0)*(&
                       -kappa(1,1)*(2.d0*mprt11(l,k)*ffm(i)*(&
                                        kappa(1,1)*dffm(1,j)+kappa(2,1)*dffm(2,j)) + &
                                    mprt12(l,k)*ffm(i)*(&
                                        kappa(1,1)*dffm(1,j)+kappa(2,1)*dffm(2,j)) + &
                                    mprt12(l,k)*ffm(i)*(&
                                        kappa(1,2)*dffm(1,j)+kappa(2,2)*dffm(2,j))) -&
                        kappa(1,2)*(mprt21(l,k)*ffm(i)*(&
                                        kappa(1,1)*dffm(1,j)+kappa(2,1)*dffm(2,j)) + &
                                    mprt21(l,k)*ffm(i)*(&
                                        kappa(1,2)*dffm(1,j)+kappa(2,2)*dffm(2,j)) + &
                                    2.d0*mprt22(l,k)*ffm(i)*(&
                                        kappa(1,2)*dffm(1,j)+kappa(2,2)*dffm(2,j))) + &
                        kappa(1,1)*(mprt1n(l,k)*jeu*(&
                                        dffm(1,i)*(kappa(1,1)*dffm(1,j)+kappa(1,2)*dffm(2,j))) + &
                                       (dffm(2,i)*(kappa(2,1)*dffm(1,j)+kappa(2,2)*dffm(2,j))) + &
                                    mprnt1(l,k)*jeu*(&
                                       (dffm(1,i)*(kappa(1,1)*dffm(1,j)+kappa(1,2)*dffm(2,j))) + &
                                       (dffm(2,i)*(kappa(2,1)*dffm(1,j)+kappa(2,2)*dffm(2,j))))) +&
                        kappa(1,2)*(mprt2n(l,k)*jeu*(&
                                        dffm(1,i)*((kappa(1,1)*dffm(1,j)+kappa(1,2)*dffm(2,j))) + & 
                                       (dffm(2,i)*(kappa(2,1)*dffm(1,j)+kappa(2,2)*dffm(2,j)))) + & 
                                    mprnt2(l,k)*jeu*(&
                                        dffm(1,i)*(kappa(1,1)*dffm(1,j)+kappa(1,2)*dffm(2,j)) + & 
                                        dffm(2,i)*(kappa(2,1)*dffm(1,j)+kappa(2,2)*dffm(2,j)))))
! ----------------- terme  pour xi2
                    matrmm(ii,jj) = matrmm(ii,jj) + &
                        (dlagrc-coefac*jeu)*wpg*jacobi*(&
                        -kappa(2,1)*(2.d0*mprt11(l,k)*ffm(i)*(&
                                         kappa(1,1)*dffm(1,j)+kappa(2,1)*dffm(2,j)) + &
                                     mprt12(l,k)*ffm(i)*(&
                                         kappa(1,1)*dffm(1,j)+kappa(2,1)*dffm(2,j)) + &
                                     mprt12(l,k)*ffm(i)*(&
                                         kappa(1,2)*dffm(1,j)+kappa(2,2)*dffm(2,j))) -&
                         kappa(2,2)*(mprt21(l,k)*ffm(i)*(&
                                         kappa(1,1)*dffm(1,j)+kappa(2,1)*dffm(2,j)) + &
                                     mprt21(l,k)*ffm(i)*(&
                                         kappa(1,2)*dffm(1,j)+kappa(2,2)*dffm(2,j)) + &
                                     2.d0*mprt22(l,k)*ffm(i)*(&
                                         kappa(1,2)*dffm(1,j)+kappa(2,2)*dffm(2,j))) +&
                         kappa(2,1)*(mprt1n(l,k)*jeu*(&
                                         dffm(1,i)*(kappa(1,1)*dffm(1,j)+kappa(1,2)*dffm(2,j))) + &
                                        (dffm(2,i)*(kappa(2,1)*dffm(1,j)+kappa(2,2)*dffm(2,j))) + &
                                     mprnt1(l,k)*jeu*(&
                                        (dffm(1,i)*(kappa(1,1)*dffm(1,j)+kappa(1,2)*dffm(2,j))) + &
                                        (dffm(2,i)*(kappa(2,1)*dffm(1,j)+kappa(2,2)*dffm(2,j)))))+&
                         kappa(2,2)*(mprt2n(l,k)*jeu*(&
                                         dffm(1,i)*((kappa(1,1)*dffm(1,j)+kappa(1,2)*dffm(2,j)))+ &
                                        (dffm(2,i)*(kappa(2,1)*dffm(1,j)+kappa(2,2)*dffm(2,j))))+ &
                                     mprnt2(l,k)*jeu*(&
                                         dffm(1,i)*(kappa(1,1)*dffm(1,j)+kappa(1,2)*dffm(2,j)) + &
                                         dffm(2,i)*(kappa(2,1)*dffm(1,j)+kappa(2,2)*dffm(2,j)))))
                end do
            end do
        end do
    end do
!
! - CONTRIBUTION 2 :
!
    do i = 1, nnm
        do j = 1, nnm
            do k = 1, ndim
                do l = 1, ndim
                    ii = ndim*(i-1)+l
                    jj = ndim*(j-1)+k
! ----------------- terme pour xi1
                    matrmm(ii,jj) = matrmm(ii,jj) - &
                        (dlagrc-coefac*jeu)*wpg*jacobi*(&
                          mprt11(l,k)*ffm(j)*(kappa(1,1)*kappa(1,1)+&
                          kappa(1,2)*kappa(2,1))*(ddffm(1,i)+ddffm(3,i)) + &
                          mprt12(l,k)*ffm(j)*(kappa(1,1)*kappa(1,1)+&
                          kappa(1,2)*kappa(2,1))*(ddffm(2,i)+ddffm(3,i)) + &
                          mprt21(l,k)*ffm(j)*(kappa(1,2)*kappa(1,1)+&
                          kappa(2,2)*kappa(1,2))*(ddffm(1,i)+ddffm(3,i)) + &
                          mprt22(l,k)*ffm(j)*(kappa(1,2)*kappa(1,1)+&
                          kappa(2,2)*kappa(1,2))*(ddffm(3,i)+ddffm(2,i)) - &
                          mprnt1(l,k)*jeu*(kappa(1,1)*kappa(1,1)+&
                          kappa(1,2)*kappa(2,1))*dffm(1,j)*(ddffm(1,i)+ddffm(3,i)) - &
                          mprnt1(l,k)*jeu*(kappa(1,2)*kappa(1,1)+&
                          kappa(2,2)*kappa(1,2))*dffm(2,j)*(ddffm(1,i)+ddffm(3,i)) - &
                          mprnt2(l,k)*jeu*(kappa(1,1)*kappa(1,1)+&
                          kappa(1,2)*kappa(2,1))*dffm(1,j)*(ddffm(2,i)+ddffm(3,i)) - &
                          mprnt2(l,k)*jeu*(kappa(1,2)*kappa(1,1)+&
                          kappa(2,2)*kappa(1,2))*dffm(2,j)*(ddffm(2,i)+ddffm(3,i)))
! ----------------- terme pour xi2 
                    matrmm(ii,jj) = matrmm(ii,jj) - &
                        (dlagrc-coefac*jeu)*wpg*jacobi*(&
                          mprt11(l,k)*ffm(j)*(kappa(2,1)*kappa(1,1)+&
                          kappa(2,2)*kappa(2,1))*(ddffm(1,i)+ddffm(3,i)) + &
                          mprt12(l,k)*ffm(j)*(kappa(2,1)*kappa(1,1)+&
                          kappa(2,2)*kappa(2,1))*(ddffm(2,i)+ddffm(3,i)) + &
                          mprt21(l,k)*ffm(j)*(kappa(1,2)*kappa(2,1)+&
                          kappa(2,2)*kappa(2,2))*(ddffm(1,i)+ddffm(3,i)) + &
                          mprt22(l,k)*ffm(j)*(kappa(1,2)*kappa(2,1)+&
                          kappa(2,2)*kappa(2,2))*(ddffm(3,i)+ddffm(2,i)) - &
                          mprnt1(l,k)*jeu*(kappa(2,1)*kappa(1,1)+&
                          kappa(2,2)*kappa(2,1))*dffm(1,j)*(ddffm(1,i)+ddffm(3,i)) - &
                          mprnt1(l,k)*jeu*(kappa(1,2)*kappa(2,1)+&
                          kappa(2,2)*kappa(2,2))*dffm(2,j)*(ddffm(1,i)+ddffm(3,i)) - &
                          mprnt2(l,k)*jeu*(kappa(1,1)*kappa(2,1)+&
                          kappa(2,2)*kappa(2,1))*dffm(1,j)*(ddffm(2,i)+ddffm(3,i)) - &
                          mprnt2(l,k)*jeu*(kappa(1,2)*kappa(2,1)+&
                          kappa(2,2)*kappa(2,2))*dffm(2,j)*(ddffm(2,i)+ddffm(3,i)))
                enddo 
            enddo
        enddo
    enddo
!
end subroutine
