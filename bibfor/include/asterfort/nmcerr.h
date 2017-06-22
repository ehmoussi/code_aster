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
    subroutine nmcerr(sddisc       , iter_glob_maxi, iter_glob_elas, pas_mini_elas, resi_glob_maxi,&
                      resi_glob_rela, inikry       , ds_contact_)
        use NonLin_Datastructure_type
        character(len=19), intent(in) :: sddisc
        integer, intent(in) :: iter_glob_maxi
        integer, intent(in) :: iter_glob_elas
        real(kind=8), intent(in) :: pas_mini_elas 
        real(kind=8), intent(in) :: inikry
        real(kind=8), intent(in) :: resi_glob_maxi
        real(kind=8), intent(in) :: resi_glob_rela
        type(NL_DS_Contact), optional, intent(in) :: ds_contact_
    end subroutine nmcerr
end interface
