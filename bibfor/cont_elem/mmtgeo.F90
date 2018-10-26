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
subroutine mmtgeo(phase , l_large_slip,&
                  ndim  , nne   , nnm   ,&
                  wpg   , ffe   , ffm   , dffm  , ddffm ,&
                  jacobi, coefac, coefff, jeu   , dlagrc,&
                  mprojn,&
                  mprt1n, mprt2n, mprnt1, mprnt2,&
                  kappa , vech1 , vech2 , h     , hah   ,&
                  mprt11, mprt12, mprt21, mprt22,&
                  matree, matrmm, matrem, matrme)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/mmgnuu.h"
#include "asterfort/mmgtuu.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_large_slip
integer, intent(in) :: ndim, nne, nnm
real(kind=8), intent(in) :: wpg, ffe(9), ffm(9), dffm(2,9), ddffm(3,9)
real(kind=8), intent(in) :: jacobi, coefac, coefff, jeu, dlagrc
real(kind=8), intent(in) :: mprojn(3,3)
real(kind=8), intent(in) :: mprt1n(3,3), mprt2n(3,3), mprnt1(3,3), mprnt2(3,3)
real(kind=8), intent(in) :: kappa(2,2), vech1(3), vech2(3), h(2,2), hah(2,2)
real(kind=8), intent(in) :: mprt11(3,3), mprt12(3,3), mprt21(3,3), mprt22(3,3)
real(kind=8), intent(inout) :: matrem(27,27), matrme(27,27)
real(kind=8), intent(inout) :: matree(27,27), matrmm(27,27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for first variation of gap
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  l_large_slip     : flag for GRAND_GLISSEMENT
! In  ndim             : dimension of problem (2 or 3)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  wpg              : weight for current Gauss point
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! In  dffm             : first derivative of shape function for master nodes
! In  jacobi           : jacobian at integration point
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  jeu              : normal gap
! In  dlagrc           : increment of contact Lagrange from beginning of time step
! In  mprojn           : matrix of normal projection
! In  mprt1n           : projection matrix first tangent/normal
! In  mprt2n           : projection matrix second tangent/normal
! In  mprnt1           : projection matrix normal/first tangent
! In  mprnt2           : projection matrix normal/second tangent
! In  mprt11           : projection matrix first tangent/first tangent
!                        tau1*TRANSPOSE(tau1)(matrice 3*3)
! In  mprt12           : projection matrix first tangent/second tangent
!                        tau1*TRANSPOSE(tau2)(matrice 3*3)
! In  mprt21           : Projection matrix second tangent/first tangent
!                        tau2*TRANSPOSE(tau1)(matrice 3*3)
! In  mprt22           : Projection matrix second tangent/second tangent
!                        tau2*TRANSPOSE(tau2)(matrice 3*3)
! In  kappa            : MATRICE DE SCALAIRES LIEES A LA CINEMATIQUE DU GLISSEMENT
!                        KAPPA(i,j) = INVERSE[tau_i.tau_j-JEU*(ddFFM*geomm)](matrice 2*2)
! In  vech1            : KAPPA(1,m)*tau_m
! In  vech2            : KAPPA(2,m)*tau_m
! In  h                : MATRICE DE SCALAIRES EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
!                        H(i,j) = JEU*{[DDGEOMM(i,j)].n} (matrice 2*2)
! In  hah              : HA/H  (matrice 2*2)
! IO  matree           : matrix for DOF [slave x slave]
! IO  matrmm           : matrix for DOF [master x master]
! IO  matrem           : matrix for DOF [slave x master]
! IO  matrme           : matrix for DOF [master x slave]
!
! --------------------------------------------------------------------------------------------------
!
    if (phase .ne. 'SANS') then
        call mmgnuu(ndim  , nne   , nnm   ,&
                    wpg   , ffe   , ffm   , dffm  ,&
                    jacobi, coefac, jeu   , dlagrc,&
                    mprojn,&
                    mprt1n, mprt2n, mprnt1, mprnt2,&
                    mprt11, mprt12, mprt21, mprt22,&
                    kappa , vech1 , vech2 ,&
                    h     , hah   , &
                    matree, matrmm, matrem, matrme)
    endif
    if (phase .eq. 'GLIS' .and. l_large_slip) then
        call mmgtuu(ndim  , nne   , nnm   ,&
                    wpg   , ffe   , ffm   , dffm  , ddffm ,&
                    jacobi, coefac, coefff, jeu   , dlagrc,&
                    mprt1n, mprt2n, mprnt1, mprnt2,&
                    kappa , vech1 , vech2 , h     ,&
                    mprt11, mprt12, mprt21, mprt22,&
                    matrmm, matrem, matrme)
    endif
!
end subroutine
