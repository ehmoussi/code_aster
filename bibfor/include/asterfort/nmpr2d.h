! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine nmpr2d(l_axis, nno  , npg ,&
                      poidsg, vff  , dff ,&
                      geom  , pres , cisa,&
                      vect_ , matr_)
        aster_logical, intent(in):: l_axis
        integer, intent(in) :: nno, npg
        real(kind=8), intent(in) :: poidsg(npg), vff(nno, npg), dff(nno, npg)
        real(kind=8), intent(in) :: geom(2, nno), pres(npg), cisa(npg)
        real(kind=8), intent(out), optional :: vect_(2, nno), matr_(2, nno, 2, nno)
    end subroutine nmpr2d
end interface
