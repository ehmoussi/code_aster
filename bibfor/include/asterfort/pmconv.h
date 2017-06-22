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
    subroutine pmconv(r, rini, r1, inst, sigp,&
                      coef, iter, indimp, ds_conv, conver,&
                      itemax)
        use NonLin_Datastructure_type
        real(kind=8) :: r(12)
        real(kind=8) :: rini(12)
        real(kind=8) :: r1(12)
        real(kind=8) :: inst
        real(kind=8) :: sigp(6)
        real(kind=8) :: coef
        integer :: iter
        integer :: indimp(6)
        type(NL_DS_Conv), intent(in) :: ds_conv
        aster_logical :: conver
        aster_logical :: itemax
    end subroutine pmconv
end interface
