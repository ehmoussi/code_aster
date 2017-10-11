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
    subroutine thmGetElemPara_vf(l_axi    , l_steady , l_vf  ,&
                                 type_elem, ndim     ,&
                                 mecani   , press1   , press2, tempe,&
                                 dimdef   , dimcon   , dimuel,&
                                 nno      , nnos     , nface )
        aster_logical, intent(out) :: l_axi, l_steady, l_vf
        character(len=8), intent(out) :: type_elem(2)
        integer, intent(out) :: ndim
        integer, intent(out) :: mecani(5), press1(7), press2(7), tempe(5)
        integer, intent(out) :: dimdef, dimcon, dimuel
        integer, intent(out) :: nno, nnos, nface   
    end subroutine thmGetElemPara_vf
end interface
