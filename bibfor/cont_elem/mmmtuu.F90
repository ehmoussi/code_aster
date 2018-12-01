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
#include "asterf_types.h"
!
subroutine mmmtuu(phase , l_pena_cont, l_pena_fric,&
                  ndim  , nne        , nnm   ,&
                  mprojn, mprojt     ,&
                  wpg   , ffe        , ffm   , jacobi,&
                  coefac, coefaf     , coefff, lambda,&
                  rese  , nrese      ,&
                  matree, matrmm     ,&
                  matrem, matrme)
!
implicit none
!
#include "asterfort/mmmtee.h"
#include "asterfort/mmmtem.h"
#include "asterfort/mmmtme.h"
#include "asterfort/mmmtmm.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_cont, l_pena_fric
integer, intent(in)  :: ndim, nne, nnm
real(kind=8), intent(in)  :: mprojn(3, 3), mprojt(3, 3)
real(kind=8), intent(in)  :: ffe(9), ffm(9)
real(kind=8), intent(in)  :: wpg, jacobi
real(kind=8), intent(in)  :: rese(3), nrese
real(kind=8), intent(in)  :: coefac, coefaf
real(kind=8), intent(in)  :: lambda, coefff
real(kind=8), intent(out)  :: matrem(27, 27), matrme(27, 27)
real(kind=8), intent(out)  :: matree(27, 27), matrmm(27, 27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF [disp x disp]
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
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  mprojn           : matrix of normal projection
! In  mprojt           : matrix of tangent projection
! In  wpg              : weight for current Gauss point
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! In  jacobi           : jacobian at integration point
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  coefff           : friction coefficient (Coulomb)
! In  lambda           : contact pressure
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! Out matree           : matrix for DOF [slave x slave]
! Out matrmm           : matrix for DOF [master x master]
! Out matrem           : matrix for DOF [slave x master]
! Out matrme           : matrix for DOF [master x slave]
!
! --------------------------------------------------------------------------------------------------
!
    call mmmtee(phase , l_pena_cont, l_pena_fric,&
                ndim  , nne        ,&
                mprojn, mprojt     ,&
                wpg   , ffe        , jacobi     ,&
                coefac, coefaf     , coefff     , lambda,&
                rese  , nrese      ,&
                matree)
!
    call mmmtmm(phase , l_pena_cont, l_pena_fric,&
                ndim  , nnm        ,&
                mprojn, mprojt     ,&
                wpg   , ffm        , jacobi     ,&
                coefac, coefaf     , coefff     , lambda,&
                rese  , nrese      ,&
                matrmm)
!
    call mmmtem(phase ,&
                ndim  , nne   , nnm   ,&
                mprojn, mprojt, wpg   , jacobi,&
                ffe   , ffm   , &
                coefac, coefaf, coefff, lambda,&
                rese  , nrese ,&
                matrem)
!
    call mmmtme(phase ,&
                ndim  , nne   , nnm   ,&
                mprojn, mprojt, wpg   , jacobi,&
                ffe   , ffm   , &
                coefac, coefaf, coefff, lambda,&
                rese  , nrese , &
                matrme)
!
end subroutine
