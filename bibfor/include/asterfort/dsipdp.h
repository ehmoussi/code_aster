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
    subroutine dsipdp(nume_thmc,&
                      adcome, addep1, addep2  ,&
                      dimcon, dimdef, dsde    ,&
                      dspdp1, dspdp2, l_dspdp2)
        integer, intent(in) :: nume_thmc
        integer, intent(in) :: adcome, addep1, addep2
        integer, intent(in) :: dimdef, dimcon
        real(kind=8), intent(in) :: dsde(dimcon, dimdef)
        real(kind=8), intent(out) :: dspdp1, dspdp2
        aster_logical, intent(out) :: l_dspdp2
    end subroutine dsipdp
end interface
