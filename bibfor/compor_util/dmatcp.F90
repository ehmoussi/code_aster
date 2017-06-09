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

subroutine dmatcp(fami, mater, time, poum, ipg,&
                  ispg, repere, d)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dpao2d.h"
#include "asterfort/get_elas_para.h"
#include "asterfort/utbtab.h"
!
!
    character(len=*), intent(in) :: fami
    integer, intent(in) :: mater
    real(kind=8), intent(in) :: time
    character(len=*), intent(in) :: poum
    integer, intent(in) :: ipg
    integer, intent(in) :: ispg
    real(kind=8), intent(in) :: repere(7)
    real(kind=8), intent(out) :: d(4, 4)
!
! --------------------------------------------------------------------------------------------------
!
! Hooke matrix for iso-parametric elements
!
! Plane stress
!
! --------------------------------------------------------------------------------------------------
!
! In  fami   : Gauss family for integration point rule
! In  mater  : material parameters
! In  time   : current time
! In  poum   : '-' or '+' for parameters evaluation (previous or current temperature)
! In  ipg    : current point gauss
! In  ispg   : current "sous-point" gauss
! In  repere : local basis for orthotropic elasticity
! Out d      : Hooke matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: irep, i, j
    integer :: elas_type
    real(kind=8) :: zero, undemi, un
    real(kind=8) :: passag(4, 4), dorth(4, 4), work(4, 4)
    real(kind=8) :: nu, nu12, nu21, nu13, nu23
    real(kind=8) :: e1, e2, e3, e
    real(kind=8) :: g1, g2, g3, g
    real(kind=8) :: c1, delta
!
! --------------------------------------------------------------------------------------------------
!
    zero       = 0.0d0
    undemi     = 0.5d0
    un         = 1.0d0
    d(:,:)     = 0.d0
    dorth(:,:) = 0.d0
    work(:,:)  = 0.d0
!
! - Get elastic parameters
!
    call get_elas_para(fami, mater    , poum, ipg, ispg, &
                       elas_type,&
                       time = time,&
                       e = e      , nu = nu    , g = g,&
                       e1 = e1    , e2 = e2    , e3 = e3,& 
                       nu12 = nu12, nu13 = nu13, nu23 = nu23,&
                       g1 = g1    , g2 = g2    , g3 = g3)
!
! - Compute Hooke matrix
!
    if (elas_type.eq.1) then
!
! ----- Isotropic matrix
!
        d(1,1) = e/(un-nu*nu)
        d(1,2) = d(1,1)*nu
        d(2,1) = d(1,2)
        d(2,2) = d(1,1)
        d(4,4) = undemi*e/ (un+nu)
!
    else if (elas_type.eq.2) then
!
! ----- Orthotropic matrix
!
        nu21  = e2*nu12/e1
        delta = un-nu12*nu21
        dorth(1,1) = e1/delta
        dorth(1,2) = nu12*e2/delta
        dorth(2,2) = e2/delta
        dorth(2,1) = dorth(1,2)
        dorth(4,4) = g1
!
! ----- Matrix from orthotropic basis to global 3D basis
!
        call dpao2d(repere, irep, passag)
!
! ----- Hooke matrix in global 3D basis
!
        ASSERT((irep.eq.1).or.(irep.eq.0))
        if (irep .eq. 1) then
            call utbtab('ZERO', 4, 4, dorth, passag,&
                        work, d)
        else if (irep.eq.0) then
            do i = 1, 4
                do j = 1, 4
                    d(i,j) = dorth(i,j)
                end do
            end do
        endif
    else if (elas_type.eq.3) then
        e = e1
        nu = nu12
!
! ----- Transverse isotropic matrix
!
        c1 = e/ (un+nu)
        delta = un - nu*nu
        d(1,1) = e/delta
        d(1,2) = nu*d(1,1)
        d(2,1) = d(1,2)
        d(2,2) = d(1,1)
        d(4,4) = undemi*c1
    else
        ASSERT(.false.)
    endif
!
end subroutine
