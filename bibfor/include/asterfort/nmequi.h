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
    subroutine nmequi(l_disp     , l_pilo, l_macr, cnresu,&
                      cnfint     , cnfext, cndiri, cnsstr,&
                      ds_contact_,&
                      cnbudi_    , cndfdo_,&
                      cndipi_    , eta_)
        use NonLin_Datastructure_type
        aster_logical, intent(in) :: l_disp, l_pilo, l_macr
        character(len=19), intent(in) :: cnresu
        character(len=19), intent(in) :: cnfint, cnfext, cndiri, cnsstr
        type(NL_DS_Contact), optional, intent(in) :: ds_contact_
        character(len=19), optional, intent(in) :: cnbudi_, cndfdo_, cndipi_
        real(kind=8), optional, intent(in) :: eta_
    end subroutine nmequi
end interface
