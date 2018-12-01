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
subroutine mmmtfu(phase ,&
                  ndim  , nnl   , nne   , nnm   , nbcps,&
                  wpg   , jacobi, ffl   , ffe   , ffm  ,&
                  tau1  , tau2  , mprojt,&
                  rese  , nrese , lambda, coefff,&
                  matrfe, matrfm)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/mmmtfe.h"
#include "asterfort/mmmtfm.h"
!
character(len=4), intent(in) :: phase
integer, intent(in) :: ndim, nne, nnm, nnl, nbcps
real(kind=8), intent(in) :: tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: wpg, ffl(9), ffe(9), ffm(9), jacobi
real(kind=8), intent(in) :: rese(3), nrese, lambda, coefff
real(kind=8), intent(out) :: matrfe(18, 27), matrfm(18, 27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF [friction x disp]
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  nbcps            : number of components by node for Lagrange multiplicators
! In  wpg              : weight for current Gauss point
! In  jacobi           : jacobian at integration point
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! In  ffl              : shape function for Lagrange dof
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojt           : matrix of tangent projection
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! In  lambda           : contact pressure
! In  coefff           : friction coefficient (Coulomb)
! Out matrfe           : matrix for DOF [friction x slave]
! Out matrfm           : matrix for DOF [friction x master]
!
! --------------------------------------------------------------------------------------------------
!
    call mmmtfe(phase,&
                ndim  , nne   , nnl   , nbcps ,&
                wpg   , jacobi, ffe   , ffl   ,&
                tau1  , tau2  , mprojt,&
                rese  , nrese , lambda, coefff,&
                matrfe)
!
    call mmmtfm(phase,&
                ndim  , nnm   , nnl   , nbcps ,&
                wpg   , jacobi, ffm   , ffl   ,&
                tau1  , tau2  , mprojt,&
                rese  , nrese , lambda, coefff,&
                matrfm)
!
end subroutine
