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

!
#include "asterf_types.h"
interface 
      subroutine fluendo3d(xmat,sig0,sigf,deps,&
               nstrs,var0,varf,nvari,nbelas3d,&
               teta1,teta2,dt,vrgi,ierr1,&
               iso,mfr,end3d,fl3d,local,&
               ndim)
        real(kind=8) :: xmat(:)
        real(kind=8) :: sig0(:)
        real(kind=8) :: sigf(:)
        real(kind=8) :: deps(:)
        integer :: nstrs
        real(kind=8) :: var0(:)
        real(kind=8) :: varf(:)
        integer :: nvari
        integer :: nbelas3d 
        real(kind=8) :: teta1
        real(kind=8) :: teta2
        real(kind=8) :: dt
        real(kind=8) :: vrgi
        integer :: ierr1
        aster_logical :: iso
        integer :: mfr
        aster_logical :: end3d
        aster_logical :: fl3d
        aster_logical :: local
        integer :: ndim
    end subroutine fluendo3d
end interface
