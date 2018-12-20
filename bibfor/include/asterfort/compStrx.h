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
#include "asterf_types.h"
!
interface
    subroutine compStrx(modelz , ligrel , compor    ,&
                        chdispz, chgeom , chmate    , chcara,&
                        chvarc , chvref , &
                        basez  , chelemz, codret    ,&
                        l_poux_, load_d_, coef_type_, coef_real_, coef_cplx_)
        character(len=*), intent(in) :: modelz, ligrel, compor
        character(len=*), intent(in) :: chdispz, chgeom, chmate
        character(len=*), intent(in) :: chcara(*)
        character(len=*), intent(in) :: chvarc, chvref
        character(len=*), intent(in) :: chelemz, basez
        integer, intent(out) :: codret
        aster_logical, intent(in), optional :: l_poux_
        character(len=*), intent(in), optional :: load_d_, coef_type_
        real(kind=8), intent(in), optional :: coef_real_
        complex(kind=8), intent(in), optional :: coef_cplx_
    end subroutine compStrx
end interface
