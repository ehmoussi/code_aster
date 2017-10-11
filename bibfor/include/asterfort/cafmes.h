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
    subroutine cafmes(ifa   , l_resi, l_matr, maxfa, nface,&
                      fkss  , dfks1 , dfks2 ,&
                      mobfas, dmob1 , dmob2 ,&
                      dmob1f, dmob2f,&
                      fmw   , fm1w  , fm2w)
        aster_logical, intent(in) :: l_matr, l_resi
        integer, intent(in) :: ifa, maxfa, nface
        real(kind=8), intent(in) :: fkss, dfks1(1+maxfa, maxfa), dfks2(1+maxfa, maxfa)
        real(kind=8), intent(in) :: mobfas,  dmob1(1:maxfa), dmob2(1:maxfa)
        real(kind=8), intent(in) :: dmob2f(1:maxfa), dmob1f(1:maxfa)
        real(kind=8), intent(out) :: fmw(1:maxfa), fm1w(1+maxfa, maxfa), fm2w(1+maxfa, maxfa)
    end subroutine cafmes
end interface
