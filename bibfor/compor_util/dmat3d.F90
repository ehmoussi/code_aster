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

subroutine dmat3d(fami, mater , time, poum, ipg,&
                  ispg, repere, xyzgau, d)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/get_elas_para.h"
#include "asterfort/matrHooke3d.h"
!
!
    character(len=*), intent(in) :: fami
    integer, intent(in) :: mater
    real(kind=8), intent(in) :: time
    character(len=*), intent(in) :: poum
    integer, intent(in) :: ipg
    integer, intent(in) :: ispg
    real(kind=8), intent(in) :: repere(7)
    real(kind=8), intent(in) :: xyzgau(3)
    real(kind=8), intent(out) :: d(6, 6)
!
! --------------------------------------------------------------------------------------------------
!
! Hooke matrix for iso-parametric elements
!
! 3D and Fourier
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
! In  xyzgau : coordinate for current Gauss point
! Out d      : Hooke matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: elas_type
    real(kind=8) :: nu, nu12, nu13, nu23
    real(kind=8) :: e1, e2, e3, e
    real(kind=8) :: g1, g2, g3, g
!
! --------------------------------------------------------------------------------------------------
!

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
    call matrHooke3d(elas_type, repere,&
                     e , nu, g,&
                     e1, e2, e3, nu12, nu13, nu23, g1, g2, g3,&
                     d , xyzgau)
!
end subroutine
