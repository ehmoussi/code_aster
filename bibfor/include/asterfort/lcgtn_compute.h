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

#include "asterf_types.h"
!
interface
    function lcgtn_compute(resi,rigi,elas, itemax, prec, m, dt, eps, phi, ep, ka, f, state, &
                  t,deps_t,dphi_t,deps_ka,dphi_ka) &
        result(iret)
        use lcgtn_module, only: gtn_material
    
        aster_logical,intent(in)     :: resi,rigi,elas
        type(gtn_material),intent(in):: m
        integer,intent(in)           :: itemax
        real(kind=8),intent(in)      :: prec
        real(kind=8),intent(in)      :: dt
        real(kind=8),intent(in)      :: eps(:)
        real(kind=8),intent(in)      :: phi
        real(kind=8),intent(inout)   :: ep(:),ka,f
        integer,intent(inout)        :: state
        real(kind=8),intent(out)     :: t(:),deps_t(:,:),dphi_t(:),deps_ka(:),dphi_ka
        integer                      :: iret
    end function
end interface
