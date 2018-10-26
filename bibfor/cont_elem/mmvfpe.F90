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
subroutine mmvfpe(phase , l_pena_cont, l_pena_fric, l_large_slip,&
                  ndim  , nne   , nnm   ,&
                  norm  , tau1  , tau2  , mprojt,&
                  wpg   , ffe   , ffm   , dffm  , jacobi, jeu   ,&
                  coefac, coefaf, lambda, coefff,&
                  dlagrc, dlagrf, djeu  ,&
                  rese  , nrese ,&
                  mprt1n, mprt2n,&
                  mprt11, mprt12, mprt21, mprt22, kappa,&
                  vectee, vectmm)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/mmmvuu.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_cont, l_pena_fric, l_large_slip
integer, intent(in) :: ndim, nne, nnm
real(kind=8), intent(in) :: norm(3), tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: wpg, ffe(9), ffm(9), dffm(2,9), jacobi, jeu
real(kind=8), intent(in) :: coefac, coefaf, lambda, coefff
real(kind=8), intent(in) :: dlagrc, dlagrf(2), djeu(3)
real(kind=8), intent(in) :: rese(3), nrese
real(kind=8), intent(in) :: mprt1n(3, 3), mprt2n(3, 3)
real(kind=8), intent(in) :: mprt11(3, 3), mprt12(3, 3), mprt21(3, 3), mprt22(3, 3)
real(kind=8), intent(in) :: kappa(2,2)
real(kind=8), intent(out) :: vectee(27), vectmm(27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Weak form of contact/friction force (displacements)
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
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  norm             : normal at current contact point
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojt           : matrix of tangent projection
! In  wpg              : weight for current Gauss point
! In  ffe              : shape function for slave nodes
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
! Out vectee           : vector for DOF [slave]
! Out vectmm           : vector for DOF [master]
!
! --------------------------------------------------------------------------------------------------
!
    call mmmvuu(phase , l_pena_cont, l_pena_fric, l_large_slip,&
                ndim  , nne   , nnm   ,&
                norm  , tau1  , tau2  , mprojt,&
                wpg   , ffe   , ffm   , dffm  , jacobi, jeu   ,&
                coefac, coefaf, lambda, coefff,&
                dlagrc, dlagrf, djeu  ,&
                rese  , nrese ,&
                mprt1n, mprt2n,&
                mprt11, mprt12, mprt21, mprt22, kappa,&
                vectee, vectmm)
!
end subroutine
