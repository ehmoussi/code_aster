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
#include "asterf_types.h"
!
interface
    subroutine vfcfks(l_matr, maxfa  , ndim , nface,&
                      uk    , dukp1  , dukp2,&
                      ufa   , dufa1  , dufa2,&
                      c     , gravity,&
                      rho   , drho1  , drho2,&
                      xk    , xface, &
                      fks   , dfks1, dfks2)
        aster_logical, intent(in) :: l_matr
        integer, intent(in) :: maxfa, nface, ndim
        real(kind=8), intent(in) :: uk, dukp1, dukp2
        real(kind=8), intent(in) :: ufa(1:nface), dufa1(1:nface), dufa2(1:nface)
        real(kind=8), intent(in) :: c(1:maxfa, 1:nface), gravity(ndim)
        real(kind=8), intent(in) :: rho, drho1, drho2
        real(kind=8), intent(in) :: xk(ndim), xface(1:3, 1:nface)
        real(kind=8), intent(out) :: fks(nface), dfks1(1+maxfa, nface), dfks2(1+maxfa, nface)
    end subroutine vfcfks
end interface
