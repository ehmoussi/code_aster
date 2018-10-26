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
subroutine mmmtuc(phase , l_pena_cont, l_pena_fric,&
                  ndim  , nnl        , nne        , nnm,&
                  norm  , tau1       , tau2       , mprojt,&
                  wpg   , ffl        , ffe        , ffm   , jacobi,&
                  coefff, coefaf,&
                  dlagrf, djeut ,&
                  rese  , nrese ,&
                  matrec, matrmc)
!
implicit none
!
#include "asterfort/mmmtec.h"
#include "asterfort/mmmtmc.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_cont, l_pena_fric
integer, intent(in) :: ndim, nne, nnl, nnm
real(kind=8), intent(in) :: norm(3), tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: wpg, ffl(9), ffe(9), ffm(9), jacobi
real(kind=8), intent(in) :: coefff, coefaf
real(kind=8), intent(in) :: dlagrf(2), djeut(3)
real(kind=8), intent(in) :: rese(3), nrese
real(kind=8), intent(out) :: matrec(27, 9), matrmc(27, 9)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF [disp x contact]
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  l_pena_cont      : flag for penalized contact
! In  l_pena_fric      : flag for penalized friction
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  norm             : normal at current contact point
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojt           : matrix of tangent projection
! In  wpg              : weight for current Gauss point
! In  ffl              : shape function for Lagrange dof
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! In  jacobi           : jacobian at integration point
! In  coefff           : friction coefficient (Coulomb)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  djeut            : increment of tangent gaps
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! Out matrec           : matrix for DOF [slave x contact]
! Out matrmc           : matrix for DOF [master x contact]
!
! --------------------------------------------------------------------------------------------------
!
    call mmmtec(phase , l_pena_cont, l_pena_fric,&
                ndim  , nnl        , nne        ,&
                norm  , tau1       , tau2       , mprojt,&
                wpg   , ffl        , ffe        , jacobi,&
                coefff, coefaf     ,&
                dlagrf, djeut      ,&
                rese  , nrese      , matrec)
!
    call mmmtmc(phase , l_pena_cont, l_pena_fric,&
                ndim  , nnl        , nnm        ,&
                norm  , tau1       , tau2       , mprojt,&
                wpg   , ffl        , ffm        , jacobi,&
                coefff, coefaf     ,&
                dlagrf, djeut      ,&
                rese  , nrese      , matrmc)
!
end subroutine
