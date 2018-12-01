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
subroutine mmtape(phase , leltf , l_pena_cont, l_pena_fric,&
                  ndim  , nnl   , nne        , nnm        , nbcps, &
                  wpg   , jacobi,&
                  ffl   , ffe   , ffm        ,&
                  norm  , tau1  , tau2       , mprojt,&
                  rese  , nrese , lambda     ,&
                  coefff, coefaf, coefac     ,&
                  matrcc, matrff,&
                  matrce, matrcm, matrfe     , matrfm)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/mmmtcc.h"
#include "asterfort/mmmtcu.h"
#include "asterfort/mmmtff.h"
#include "asterfort/mmmtfu.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: leltf , l_pena_cont, l_pena_fric
integer, intent(in) :: ndim, nnl, nne, nnm, nbcps
real(kind=8), intent(in) :: wpg, jacobi
real(kind=8), intent(in) :: ffe(9), ffl(9), ffm(9)
real(kind=8), intent(in) :: norm(3), tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: rese(3), nrese, lambda
real(kind=8), intent(in) :: coefff, coefaf, coefac
real(kind=8), intent(out) :: matrcc(9, 9), matrff(18, 18)
real(kind=8), intent(out) :: matrce(9, 27), matrcm(9, 27)
real(kind=8), intent(out) :: matrfe(18, 27), matrfm(18, 27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF (contact/friction laws in weak form)
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
!                        'NCON' - Friction but not contact (!)
! In  leltf            : flag for friction
! In  l_pena_cont      : flag for penalized contact
! In  l_pena_fric      : flag for penalized friction
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  nbcps            : number of components by node for Lagrange multiplicators
! In  wpg              : weight for current Gauss point
! In  jacobi           : jacobian at integration point
! In  ffe              : shape function for slave nodes
! In  ffl              : shape function for Lagrange dof
! In  ffm              : shape function for master nodes
! In  norm             : normal at current contact point
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojt           : matrix of tangent projection
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! In  lambda           : contact pressure
! In  coefff           : friction coefficient (Coulomb)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  coefac           : coefficient for updated Lagrangian method (contact)
! Out matrcc           : matrix for DOF [contact x contact]
! Out matrff           : matrix for DOF [friction x friction]
! Out matrce           : matrix for DOF [contact x slave]
! Out matrcm           : matrix for DOF [contact x master]
! Out matrfe           : matrix for DOF [friction x slave]
! Out matrfm           : matrix for DOF [friction x master]
!
! --------------------------------------------------------------------------------------------------
!
    if (phase .eq. 'SANS') then
        call mmmtcc(nnl, wpg, ffl, jacobi, coefac, matrcc)
        if (leltf) then
            call mmmtff(phase , l_pena_fric,&
                        ndim  , nbcps      , nnl   ,&
                        wpg   , ffl        , jacobi,&
                        tau1  , tau2       ,&
                        rese  , nrese      , lambda,&
                        coefaf, coefff,&
                        matrff)
        endif
    else if (phase .eq. 'NCON') then
        call mmmtff(phase , l_pena_fric,&
                    ndim  , nbcps      , nnl   ,&
                    wpg   , ffl        , jacobi,&
                    tau1  , tau2       ,&
                    rese  , nrese      , lambda,&
                    coefaf, coefff,&
                    matrff)
        call mmmtcu(ndim  , nnl   , nne   , nnm,&
                    ffl   , ffe   , ffm   ,&
                    norm  , wpg   , jacobi,&
                    matrce, matrcm)
        if (l_pena_cont) then
            call mmmtcc(nnl, wpg, ffl, jacobi, coefac, matrcc)
        endif
    else if (phase .eq. 'ADHE') then
! ----- For contact
        if (l_pena_cont) then
            call mmmtcc(nnl, wpg, ffl, jacobi, coefac, matrcc)
        endif
        call mmmtcu(ndim  , nnl   , nne   , nnm,&
                    ffl   , ffe   , ffm   ,&
                    norm  , wpg   , jacobi,&
                    matrce, matrcm)
        call mmmtfu(phase ,&
                    ndim  , nnl   , nne   , nnm   , nbcps,&
                    wpg   , jacobi, ffl   , ffe   , ffm  ,&
                    tau1  , tau2  , mprojt,&
                    rese  , nrese , lambda, coefff,&
                    matrfe, matrfm)
        if (l_pena_fric) then
            call mmmtff(phase , l_pena_fric,&
                        ndim  , nbcps      , nnl   ,&
                        wpg   , ffl        , jacobi,&
                        tau1  , tau2       ,&
                        rese  , nrese      , lambda,&
                        coefaf, coefff,&
                        matrff)
        endif
    else if (phase .eq. 'GLIS') then
! ----- For contact
        if (l_pena_cont) then
            call mmmtcc(nnl, wpg, ffl, jacobi, coefac, matrcc)
        endif
        call mmmtcu(ndim  , nnl   , nne   , nnm,&
                    ffl   , ffe   , ffm   ,&
                    norm  , wpg   , jacobi,&
                    matrce, matrcm)
        call mmmtff(phase , l_pena_fric,&
                    ndim  , nbcps      , nnl   ,&
                    wpg   , ffl        , jacobi,&
                    tau1  , tau2       ,&
                    rese  , nrese      , lambda,&
                    coefaf, coefff,&
                    matrff)
        call mmmtfu(phase ,&
                    ndim  , nnl   , nne   , nnm   , nbcps,&
                    wpg   , jacobi, ffl   , ffe   , ffm  ,&
                    tau1  , tau2  , mprojt,&
                    rese  , nrese , lambda, coefff,&
                    matrfe, matrfm)
    elseif (phase .eq. 'CONT') then
! ----- For contact ONLY
        if (l_pena_cont) then
            call mmmtcc(nnl, wpg, ffl, jacobi, coefac, matrcc)
        endif
        call mmmtcu(ndim  , nnl   , nne   , nnm,&
                    ffl   , ffe   , ffm   ,&
                    norm  , wpg   , jacobi,&
                    matrce, matrcm)
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
