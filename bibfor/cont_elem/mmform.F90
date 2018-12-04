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
subroutine mmform(ndim  ,&
                  typmae, typmam,&
                  nne   , nnm   ,&
                  xpc   , ypc   , xpr  , ypr,&
                  ffe   , dffe  , ddffe,&
                  ffm   , dffm  , ddffm,&
                  ffl   , dffl  , ddffl)
!
implicit none
!
#include "asterfort/mmfonf.h"
!
integer, intent(in) :: ndim
character(len=8), intent(in) :: typmae, typmam
integer, intent(in) :: nne, nnm
real(kind=8), intent(in) :: xpc, ypc, xpr, ypr
real(kind=8), intent(out) :: ffe(9), dffe(2, 9), ddffe(3, 9)
real(kind=8), intent(out) :: ffm(9), dffm(2, 9), ddffm(3, 9)
real(kind=8), intent(out) :: ffl(9), dffl(2, 9), ddffl(3, 9)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Get shape functions
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  typmae           : type of slave element
! In  typmam           : type of master element
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  xpc              : X-coordinate for contact point
! In  ypc              : Y-coordinate for contact point
! In  xpr              : X-coordinate for projection of contact point
! In  ypr              : Y-coordinate for projection of contact point
! Out ffe              : shape function for slave nodes
! Out dffe             : first derivative of shape function for slave nodes
! Out ddffe            : second derivative of shape function for slave nodes
! Out ffm              : shape function for master nodes
! Out dffm             : first derivative of shape function for master nodes
! Out ddffm            : second derivative of shape function for master nodes
! Out ffl              : shape function for Lagrange dof
! Out dffl             : first derivative of shape function for Lagrange dof
! Out ddffl            : second derivative of shape function for Lagrange dof
!
! --------------------------------------------------------------------------------------------------
!

!
! - For slave nodes
!
    call mmfonf(ndim, nne, typmae, xpc, ypc, ffe, dffe, ddffe)
!
! - For master nodes
!
    call mmfonf(ndim, nnm, typmam, xpr, ypr, ffm, dffm, ddffm)
!
! - For Lagrangian dof
!
    ffl(:)     = ffe(:)
    dffl(1,:)  = dffe(1,:)
    dffl(2,:)  = dffe(2,:)
    ddffl(1,:) = ddffe(1,:)
    ddffl(2,:) = ddffe(2,:)
    ddffl(3,:) = ddffe(3,:)
!
end subroutine
