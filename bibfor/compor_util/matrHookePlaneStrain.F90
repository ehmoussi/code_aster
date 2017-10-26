! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine matrHookePlaneStrain(elas_type, repere,&
                                e , nu, g,&
                                e1, e2, e3, nu12, nu13, nu23, g1,&
                                matr_elas)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dpao2d.h"
#include "asterfort/utbtab.h"
!
!
    integer, intent(in) :: elas_type
    real(kind=8), intent(in) :: repere(7)
    real(kind=8), intent(in) :: e
    real(kind=8), intent(in) :: nu
    real(kind=8), intent(in) :: g
    real(kind=8), intent(in) :: e1, e2, e3
    real(kind=8), intent(in) :: nu12, nu13, nu23
    real(kind=8), intent(in) :: g1
    real(kind=8), intent(out) :: matr_elas(4, 4)
!
! --------------------------------------------------------------------------------------------------
!
! Hooke matrix for iso-parametric elements
!
! Plane strain and axisymmetric
!
! --------------------------------------------------------------------------------------------------
!
! In  elas_id          : Type of elasticity
!                          1 - Isotropic
!                          2 - Orthotropic
!                          3 - Transverse isotropic
! In  repere           : define reference frame (AFFE_CARA_ELEM/MASSIF)
!                        repere(1) =  1 => nautical angles (ANGL_REP)
!                           repere(2:4) : nautical angles
!                           repere(5:7) : 0.d0
!                        repere(1) =  2 => Euler angles (ANGL_EULER)
!                           repere(2:4) : nautical angles
!                           repere(5:7) : Euler angles
!                        repere(1) = -1 => axisymetric axis (ANGL_AXE)
!                           repere(2:4) : ANGL_AXE
!                           repere(5:7) : ORIG_AXE
! In  e                : Young modulus (isotropic)
! In  nu               : Poisson ratio (isotropic)
! In  g                : shear ratio (isotropic/Transverse isotropic)
! In  e1               : Young modulus - Direction 1 (Orthotropic/Transverse isotropic)
! In  e2               : Young modulus - Direction 2 (Orthotropic)
! In  e3               : Young modulus - Direction 3 (Orthotropic/Transverse isotropic)
! In  nu12             : Poisson ratio - Coupling 1/2 (Orthotropic/Transverse isotropic)
! In  nu13             : Poisson ratio - Coupling 1/3 (Orthotropic/Transverse isotropic)
! In  nu23             : Poisson ratio - Coupling 2/3 (Orthotropic)
! In  g1               : shear ratio (Orthotropic)
! Out matr_elas        : Hooke matrix
! In  xyzgau           : coordinates of Gauss point (for ANGL_AXE case)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: irep, i, j
    real(kind=8) :: matr_tran(4, 4), dorth(4, 4), work(4, 4)
    real(kind=8) :: nu21, nu31, nu32
    real(kind=8), parameter :: undemi = 0.5d0
    real(kind=8), parameter :: un = 1.d0
    real(kind=8), parameter :: deux = 2.d0
    real(kind=8) :: delta, c1
!
! --------------------------------------------------------------------------------------------------
!
    matr_elas(:,:) = 0.d0
    dorth(:,:)     = 0.d0
    work(:,:)      = 0.d0
!
! - Compute Hooke matrix
!
    if (elas_type .eq. 1) then
!
! ----- Isotropic matrix
!
        matr_elas(1,1) = e*(un-nu)*g
        matr_elas(1,2) = e*nu*g
        matr_elas(1,3) = e*nu*g
        matr_elas(2,1) = e*nu*g
        matr_elas(2,2) = e*(un-nu)*g
        matr_elas(2,3) = e*nu*g
        matr_elas(3,1) = e*nu*g
        matr_elas(3,2) = e*nu*g
        matr_elas(3,3) = e*(un-nu)*g
        matr_elas(4,4) = undemi*e/(un+nu)
!
    else if (elas_type .eq. 2) then
!
! ----- Orthotropic matrix
!
        nu21 = e2*nu12/e1
        nu31 = e3*nu13/e1
        nu32 = e3*nu23/e2
        delta = un-nu23*nu32-nu31*nu13-nu21*nu12-deux*nu23*nu31*nu12
        dorth(1,1) = (un - nu23*nu32)*e1/delta
        dorth(1,2) = (nu21 + nu31*nu23)*e1/delta
        dorth(1,3) = (nu31 + nu21*nu32)*e1/delta
        dorth(2,2) = (un - nu13*nu31)*e2/delta
        dorth(2,3) = (nu32 + nu31*nu12)*e2/delta
        dorth(3,3) = (un - nu21*nu12)*e3/delta
        dorth(2,1) = dorth(1,2)
        dorth(3,1) = dorth(1,3)
        dorth(3,2) = dorth(2,3)
        dorth(4,4) = g1
!
! ----- Matrix from orthotropic basis to global 3D basis
!
        call dpao2d(repere, irep, matr_tran)
!
! ----- Hooke matrix in global 3D basis
!
        ASSERT((irep.eq.1).or.(irep.eq.0))
        if (irep .eq. 1) then
            call utbtab('ZERO', 4, 4, dorth, matr_tran, work, matr_elas)
        else if (irep.eq.0) then
            do i = 1, 4
                do j = 1, 4
                    matr_elas(i,j) = dorth(i,j)
                end do
            end do
        endif
!
    else if (elas_type .eq. 3) then
!
! ----- Transverse isotropic matrix
!
        c1 = e1/ (un+nu12)
        delta = un - nu12 - deux*nu13*nu13*e3/e1
        dorth(1,1) = c1* (un-nu13*nu13*e3/e1)/delta
        dorth(1,2) = c1* ((un-nu13*nu13*e3/e1)/delta-un)
        dorth(1,3) = e3*nu13/delta
        dorth(2,1) = dorth(1,2)
        dorth(2,2) = dorth(1,1)
        dorth(2,3) = dorth(1,3)
        dorth(3,1) = dorth(1,3)
        dorth(3,2) = dorth(2,3)
        dorth(3,3) = e3* (un-nu12)/delta
        dorth(4,4) = undemi*c1
!
! ----- Matrix from transverse isotropic basis to global 3D basis
!
        call dpao2d(repere, irep, matr_tran)
!
! ----- Hooke matrix in global 3D basis
!
        ASSERT((irep.eq.1).or.(irep.eq.0))
        if (irep .eq. 1) then
            call utbtab('ZERO', 4, 4, dorth, matr_tran, work, matr_elas)
        else if (irep.eq.0) then
            do i = 1, 4
                do j = 1, 4
                    matr_elas(i,j) = dorth(i,j)
                end do
            end do
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
