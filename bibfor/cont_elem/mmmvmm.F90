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
subroutine mmmvmm(phase , l_pena_cont, l_pena_fric, l_large_slip,&
                  ndim  , nnm   ,&
                  norm  , tau1  , tau2  , mprojt,&
                  wpg   , ffm   , dffm  , jacobi, jeu   ,&
                  coefac, coefaf, lambda, coefff,&
                  dlagrc, dlagrf, djeu  ,&
                  rese  , nrese ,&
                  mprt1n, mprt2n,&
                  mprt11, mprt12, mprt21, mprt22, kappa,&
                  vectmm)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_cont, l_pena_fric, l_large_slip
integer, intent(in) :: ndim, nnm
real(kind=8), intent(in) :: norm(3), tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: wpg, ffm(9), dffm(2,9), jacobi, jeu
real(kind=8), intent(in) :: coefac, coefaf, lambda, coefff
real(kind=8), intent(in) :: dlagrc, dlagrf(2), djeu(3)
real(kind=8), intent(in) :: rese(3), nrese
real(kind=8), intent(in) :: mprt1n(3, 3), mprt2n(3, 3)
real(kind=8), intent(in) :: mprt11(3, 3), mprt12(3, 3), mprt21(3, 3), mprt22(3, 3)
real(kind=8), intent(in) :: kappa(2,2)
real(kind=8), intent(out) :: vectmm(27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute vector for DOF [master]
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  l_pena_cont      : flag for penalized contact
! In  l_pena_fric      : flag for penalized friction
! In  l_large_slip     : flag for GRAND_GLISSEMENT
! In  ndim             : dimension of problem (2 or 3)
! In  nnm              : number of master nodes
! In  norm             : normal at current contact point
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojt           : matrix of tangent projection
! In  wpg              : weight for current Gauss point
! In  ffm              : shape function for master nodes
! In  dffm             : first derivative of shape function for master nodes
! In  jacobi           : jacobian at integration point
! In  jeu              : normal gap
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  lambda           : contact pressure
! In  coefff           : friction coefficient (Coulomb)
! In  dlagrc           : increment of contact Lagrange from beginning of time step
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! In  djeu             : increment of gap
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! In  mprt1n           : projection matrix first tangent/normal
! In  mprt2n           : projection matrix second tangent/normal
! In  mprt11           : projection matrix first tangent/first tangent
!                        tau1*TRANSPOSE(tau1)(matrice 3*3)
! In  mprt12           : projection matrix first tangent/second tangent
!                        tau1*TRANSPOSE(tau2)(matrice 3*3)
! In  mprt21           : Projection matrix second tangent/first tangent
!                        tau2*TRANSPOSE(tau1)(matrice 3*3)
! In  mprt22           : Projection matrix second tangent/second tangent
!                        tau2*TRANSPOSE(tau2)(matrice 3*3)
! In  kappa            : scalar matrix for sliding kinematic
! Out vectmm           : vector for DOF [master]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: inom, idim, ii, i, j, k
    real(kind=8) :: dlagft(3), plagft(3), prese(3), prese1(3), prese2(3), matr(27)
    real(kind=8) :: dvitet(3), pdvitt(3), g(3, 3), g1(3, 3), g2(3, 3)
!
! --------------------------------------------------------------------------------------------------
!
    plagft(:) = 0.d0
    dlagft(:) = 0.d0
    prese (:) = 0.d0
    dvitet(:) = 0.d0
    pdvitt(:) = 0.d0
    matr(:)   = 0.d0
!
! - PROJECTION DU LAGRANGE DE FROTTEMENT SUR LE PLAN TANGENT
!
    do i = 1, ndim
        dlagft(i) = dlagrf(1)*tau1(i)+dlagrf(2)*tau2(i)
    end do
!
! - PRODUIT LAGR. FROTTEMENT. PAR MATRICE P
!
    do i = 1, ndim
        do j = 1, ndim
            plagft(i) = mprojt(i,j)*dlagft(j)+plagft(i)
        end do
    end do
!
! - PRODUIT SEMI MULT. LAGR. FROTTEMENT. PAR MATRICE P
!
    if (phase .eq. 'GLIS') then
        do i = 1, ndim
            do j = 1, ndim
                if (l_large_slip) then
                    g(i,j) =kappa(1,1)*mprt11(i,j)+kappa(1,2)*mprt12(i,j)&
                           +kappa(2,1)*mprt21(i,j)+kappa(2,2)*mprt22(i,j)
                    g1(i,j)=kappa(1,1)*mprt1n(i,j)*jeu+kappa(2,1)*mprt2n(i,j)*jeu
                    g2(i,j)=kappa(2,2)*mprt2n(i,j)*jeu+kappa(1,2)*mprt1n(i,j)*jeu
                    prese(i)  = g(i,j)*rese(j)/nrese+prese(i)
                    prese1(i) = g1(i,j)*rese(j)/nrese+prese1(i)
                    prese2(i) = g2(i,j)*rese(j)/nrese+prese2(i)
                else
                    prese(i) = mprojt(i,j)*rese(j)/nrese+prese(i)
                endif
            end do
        end do
    endif
!
! - PROJECTION DU SAUT SUR LE PLAN TANGENT
!
    do i = 1, ndim
        do k = 1, ndim
            dvitet(i) = mprojt(i,k)*djeu(k)+dvitet(i)
        end do
    end do
!
! - PRODUIT SAUT PAR MATRICE P
!
    do i = 1, ndim
        do j = 1, ndim
            pdvitt(i) = mprojt(i,j)*dvitet(j)+pdvitt(i)
        end do
    end do
!
! - Compute terms
!
    if (phase .ne. 'SANS') then
        if (l_pena_cont) then
            do inom = 1, nnm
                do idim = 1, ndim
                    ii = ndim*(inom-1)+idim
                    vectmm(ii) = vectmm(ii)-&
                                 wpg*ffm(inom)*jacobi*norm(idim)*jeu*coefac
                end do
            end do
        else
            do inom = 1, nnm
                do idim = 1, ndim
                    ii = ndim*(inom-1)+idim
                    vectmm(ii) = vectmm(ii)+&
                                 wpg*ffm(inom)*jacobi*norm(idim)*(dlagrc-jeu*coefac)
                end do
            end do
        endif
    endif
    
    if (phase .eq. 'GLIS') then
        do inom = 1, nnm
            do idim = 1, ndim
                ii = ndim*(inom-1)+idim
                if (l_large_slip) then 
                    matr(ii)   = ffm(inom)*prese(idim)+1.* dffm(1,inom)*&
                        prese1(idim)+1.*dffm(2,inom)*prese2(idim)
                    vectmm(ii) = vectmm(ii)+ wpg*matr(ii)*jacobi*(lambda-0.*jeu)*coefff
                else
                    vectmm(ii) = vectmm(ii)+ wpg*ffm(inom)*jacobi*prese(idim)*lambda*coefff
                endif
            end do
        end do
    endif

    if (phase .eq. 'ADHE') then
        if (l_pena_fric) then
            do inom = 1, nnm
                do idim = 1, ndim
                    ii = ndim*(inom-1)+idim
                    vectmm(ii) = vectmm(ii)+&
                                 wpg*ffm(inom)*jacobi*pdvitt(idim)*lambda*coefff*coefaf
                end do
            end do
        else
            do inom = 1, nnm
                do idim = 1, ndim
                    ii = ndim*(inom-1)+idim
                    vectmm(ii) = vectmm(ii)+&
                                 wpg*ffm(inom)*jacobi*(lambda-0.*jeu)*coefff*(&
                                   plagft(idim)+pdvitt(idim)*coefaf)
                end do
            end do
        endif
    endif
!
end subroutine
