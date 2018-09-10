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
      subroutine majw3d(epspt60,epspt6,t33,&
       wplt06,wplt6,wpltx06,wpltx6,wpl3,vwpl33,vwpl33t,&
       wplx3,vwplx33,vwplx33t,local,dim3,ndim,ifour)

        real(kind=8) :: epspt60(6)
        real(kind=8) :: epspt6(6)
        real(kind=8) :: t33(3,3)
        real(kind=8) :: wplt06(6)
        real(kind=8) :: wplt6(6)
        real(kind=8) :: wpltx06(6)
        real(kind=8) :: wpltx6(6)
        real(kind=8) :: wpl3(3)
        real(kind=8) :: vwpl33(3,3)
        real(kind=8) :: vwpl33t(3,3)
        real(kind=8) :: wplx3(3)
        real(kind=8) :: vwplx33(3,3)
        real(kind=8) :: vwplx33t(3,3)
        aster_logical :: local
        real(kind=8) ::  dim3
        integer :: ndim
        integer :: ifour     
    end subroutine majw3d
end interface
