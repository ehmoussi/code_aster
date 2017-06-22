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

!
!
#include "asterf_types.h"
!
interface
    subroutine vfcfks(cont, tange, maxfa, nface, uk,&
                      dukp1, dukp2, ufa, dufa1, dufa2,&
                      c, pesa, rho, drho1, drho2,&
                      xk, xfa, maxdim, ndim, fks,&
                      dfks1, dfks2)
        integer :: ndim
        integer :: maxdim
        integer :: nface
        integer :: maxfa
        aster_logical :: cont
        aster_logical :: tange
        real(kind=8) :: uk
        real(kind=8) :: dukp1
        real(kind=8) :: dukp2
        real(kind=8) :: ufa(1:nface)
        real(kind=8) :: dufa1(1:nface)
        real(kind=8) :: dufa2(1:nface)
        real(kind=8) :: c(1:maxfa, 1:nface)
        real(kind=8) :: pesa(ndim)
        real(kind=8) :: rho
        real(kind=8) :: drho1
        real(kind=8) :: drho2
        real(kind=8) :: xk(ndim)
        real(kind=8) :: xfa(1:maxdim, 1:nface)
        real(kind=8) :: fks(nface)
        real(kind=8) :: dfks1(1+maxfa, nface)
        real(kind=8) :: dfks2(1+maxfa, nface)
    end subroutine vfcfks
end interface
