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
subroutine mmvape(phase , leltf , l_pena_cont, l_pena_fric,&
                  ndim  , nnl   , nbcps      ,&
                  ffl   ,&
                  wpg   , jacobi, jeu   , djeu, lambda,&
                  coefac, coefaf, coefff, &
                  tau1  , tau2  , mprojt, &
                  dlagrc, dlagrf, rese,&
                  vectcc, vectff)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/mmmvcc.h"
#include "asterfort/mmmvff.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: leltf, l_pena_cont, l_pena_fric
integer, intent(in) :: ndim, nnl, nbcps
real(kind=8), intent(in) :: ffl(9)
real(kind=8), intent(in) :: coefac, coefaf, coefff
real(kind=8), intent(in) :: wpg, jacobi, jeu, lambda
real(kind=8), intent(in) :: tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: dlagrc, dlagrf(2), djeu(3), rese(3)
real(kind=8), intent(out) :: vectcc(9), vectff(18)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute vector for DOF (contact/friction laws in weak form)
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  leltf            : flag for friction
! In  l_pena_cont      : flag for penalized contact
! In  l_pena_fric      : flag for penalized friction
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nbcps            : number of components by node for Lagrange multiplicators
! In  ffl              : shape function for Lagrange dof
! In  wpg              : weight for current Gauss point
! In  jacobi           : jacobian at integration point
! In  jeu              : normal gap
! In  djeu             : increment of gap
! In  lambda           : contact pressure
! In  coefff           : friction coefficient (Coulomb)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojt           : matrix of tangent projection
! In  dlagrc           : increment of contact Lagrange from beginning of time step
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! In  rese             : Lagrange (semi) multiplier for friction
! Out vectcc           : vector for DOF [contact]
! Out vectff           : vector for DOF [friction]
!
! --------------------------------------------------------------------------------------------------
!
    if (phase .eq. 'SANS') then
        call mmmvcc(phase , l_pena_cont, &
                    nnl   , wpg        , ffl   , jacobi,&
                    jeu   , coefac     , dlagrc,&
                    vectcc)
        if (leltf) then
            call mmmvff(phase , l_pena_cont, l_pena_fric,&
                        ndim  , nnl        , nbcps      ,&
                        ffl   ,&
                        wpg   , jacobi     , djeu       , lambda,&
                        coefaf, coefff     , &
                        tau1  , tau2       , mprojt     , &
                        dlagrf, rese       , &
                        vectff)
        endif
    else
        if (phase .eq. 'CONT') then
            call mmmvcc(phase , l_pena_cont, &
                        nnl   , wpg        , ffl   , jacobi,&
                        jeu   , coefac     , dlagrc,&
                        vectcc)
        elseif (phase .eq. 'ADHE') then
            call mmmvcc(phase , l_pena_cont, &
                        nnl   , wpg        , ffl   , jacobi,&
                        jeu   , coefac     , dlagrc,&
                        vectcc)
            call mmmvff(phase , l_pena_cont, l_pena_fric,&
                        ndim  , nnl        , nbcps      ,&
                        ffl   ,&
                        wpg   , jacobi     , djeu       , lambda,&
                        coefaf, coefff     , &
                        tau1  , tau2       , mprojt     , &
                        dlagrf, rese       , &
                        vectff)
        elseif (phase .eq. 'GLIS') then
            call mmmvcc(phase , l_pena_cont, &
                        nnl   , wpg        , ffl   , jacobi,&
                        jeu   , coefac     , dlagrc,&
                        vectcc)
            call mmmvff(phase , l_pena_cont, l_pena_fric,&
                        ndim  , nnl        , nbcps      ,&
                        ffl   ,&
                        wpg   , jacobi     , djeu       , lambda,&
                        coefaf, coefff     , &
                        tau1  , tau2       , mprojt     , &
                        dlagrf, rese       , &
                        vectff)
        endif
    endif
!
end subroutine
