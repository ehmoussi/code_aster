! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine behaviourSelectOption(option, l_matr, l_vect, l_inte, l_pred)
!
implicit none
!
#include "asterf_types.h"
!
character(len=16), intent(in) :: option
aster_logical, intent(out) :: l_matr, l_vect, l_inte, l_pred
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! Select objects to construct from option name
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! Out l_matr           : flag to compute matrix
! Out l_vect           : flag to compute vector
! Out l_inte           : flag to inntegrate behaviour
! Out l_pred           : flag for special prediction
!
! --------------------------------------------------------------------------------------------------
!
    l_vect = option.eq.'RAPH_MECA' .or. option(1:9).eq.'FULL_MECA' .or. option .eq. 'RIGI_MECA_TANG'
    l_matr = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RIGI_MECA'
    l_pred = option .eq. 'RIGI_MECA_TANG'
    l_inte = option.eq.'RAPH_MECA' .or. option(1:9).eq.'FULL_MECA'

end subroutine
