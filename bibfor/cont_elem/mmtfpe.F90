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
subroutine mmtfpe(phase , iresof, l_pena_cont, l_pena_fric,&
                  ndim  , nne   , nnm        ,  nnl       , nbcps ,&
                  wpg   , jacobi,&
                  ffl   , ffe   , ffm        ,&
                  norm  , tau1  , tau2       , mprojn     , mprojt,&
                  rese  , nrese , &
                  lambda, coefff, coefaf     , coefac, &
                  dlagrf, djeut ,&
                  matree, matrmm,&
                  matrem, matrme,&
                  matrec, matrmc,&
                  matref, matrmf)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/mmmtuc.h"
#include "asterfort/mmmtuf.h"
#include "asterfort/mmmtuu.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_cont, l_pena_fric
integer, intent(in) :: iresof, ndim, nne, nnm, nnl, nbcps
real(kind=8), intent(in) :: norm(3), tau1(3), tau2(3), mprojn(3, 3), mprojt(3, 3)
real(kind=8), intent(in) :: ffe(9), ffm(9), ffl(9)
real(kind=8), intent(in) :: wpg, jacobi
real(kind=8), intent(in) :: rese(3), nrese
real(kind=8), intent(in) :: coefac, coefaf, lambda, coefff
real(kind=8), intent(in) :: dlagrf(2), djeut(3)
real(kind=8), intent(out) :: matrem(27, 27), matrme(27, 27)
real(kind=8), intent(out) :: matree(27, 27), matrmm(27, 27)
real(kind=8), intent(out) :: matrec(27, 9), matrmc(27, 9)
real(kind=8), intent(out) :: matrmf(27, 18), matref(27, 18)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF (equilibrium laws in weak form)
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  l_pena_cont      : flag for penalized contact
! In  l_pena_fric      : flag for penalized friction
! In  iresof           : algorithm for friction
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  nbcps            : number of components by node for Lagrange multiplicators
! In  wpg              : weight for current Gauss point
! In  jacobi           : jacobian at integration point
! In  ffl              : shape function for Lagrange dof
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! In  norm             : normal at current contact point
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojn           : matrix of normal projection
! In  mprojt           : matrix of tangent projection
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! In  lambda           : contact pressure
! In  coefff           : friction coefficient (Coulomb)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  djeut            : increment of tangent gaps
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! Out matree           : matrix for DOF [slave x slave]
! Out matrmm           : matrix for DOF [master x master]
! Out matrem           : matrix for DOF [slave x master]
! Out matrme           : matrix for DOF [master x slave]
! Out matrec           : matrix for DOF [slave x contact]
! Out matrmc           : matrix for DOF [master x contact]
! Out matref           : matrix for DOF [slave x friction]
! Out matrmf           : matrix for DOF [master x friction]
!
! --------------------------------------------------------------------------------------------------
!
    if (phase .eq. 'CONT') then
! ----- For contact
        call mmmtuc(phase , l_pena_cont, l_pena_fric,&
                    ndim  , nnl        , nne        , nnm,&
                    norm  , tau1       , tau2       , mprojt,&
                    wpg   , ffl        , ffe        , ffm   , jacobi,&
                    coefff, coefaf,&
                    dlagrf, djeut ,&
                    rese  , nrese ,&
                    matrec, matrmc)
        call mmmtuu(phase , l_pena_cont, l_pena_fric,&
                    ndim  , nne        , nnm        ,&
                    mprojn, mprojt     ,&
                    wpg   , ffe        , ffm        , jacobi,&
                    coefac, coefaf     , coefff     , lambda,&
                    rese  , nrese      ,&
                    matree, matrmm     ,&
                    matrem, matrme)
    elseif (phase .eq. 'ADHE') then
        call mmmtuf(phase , l_pena_fric,&
                    ndim  , nne        , nnm   , nnl   , nbcps ,&
                    wpg   , jacobi     , ffe   , ffm   , ffl   ,&
                    tau1  , tau2       , mprojt,&
                    rese  , nrese      , lambda, coefff,&
                    matref, matrmf)
        call mmmtuu(phase , l_pena_cont, l_pena_fric,&
                    ndim  , nne        , nnm   ,&
                    mprojn, mprojt     ,&
                    wpg   , ffe        , ffm   , jacobi,&
                    coefac, coefaf     , coefff, lambda,&
                    rese  , nrese      ,&
                    matree, matrmm     ,&
                    matrem, matrme)
        if (iresof .ge. 1) then
            call mmmtuc(phase , l_pena_cont, l_pena_fric,&
                        ndim  , nnl        , nne        , nnm,&
                        norm  , tau1       , tau2       , mprojt,&
                        wpg   , ffl        , ffe        , ffm   , jacobi,&
                        coefff, coefaf,&
                        dlagrf, djeut ,&
                        rese  , nrese ,&
                        matrec, matrmc)
        endif
    else if (phase .eq. 'GLIS') then
        call mmmtuu(phase , l_pena_cont, l_pena_fric,&
                    ndim  , nne        , nnm   ,&
                    mprojn, mprojt     ,&
                    wpg   , ffe        , ffm   , jacobi,&
                    coefac, coefaf     , coefff, lambda,&
                    rese  , nrese      ,&
                    matree, matrmm     ,&
                    matrem, matrme)
        call mmmtuf(phase , l_pena_fric,&
                    ndim  , nne        , nnm   , nnl   , nbcps ,&
                    wpg   , jacobi     , ffe   , ffm   , ffl   ,&
                    tau1  , tau2       , mprojt,&
                    rese  , nrese      , lambda, coefff,&
                    matref, matrmf)
        if (iresof .ge. 1) then
            call mmmtuc(phase , l_pena_cont, l_pena_fric,&
                        ndim  , nnl        , nne        , nnm,&
                        norm  , tau1       , tau2       , mprojt,&
                        wpg   , ffl        , ffe        , ffm   , jacobi,&
                        coefff, coefaf,&
                        dlagrf, djeut ,&
                        rese  , nrese ,&
                        matrec, matrmc)
        endif
    endif
!
end subroutine
