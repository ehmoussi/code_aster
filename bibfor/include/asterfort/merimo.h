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
    subroutine merimo(base           , model , cara_elem, mate  , varc_refe,&
                      ds_constitutive, iterat, acti_func, sddyna, hval_incr,&
                      hval_algo      , merigi, vefint   , optioz, tabret   )
        use NonLin_Datastructure_type
        character(len=1), intent(in) :: base
        integer, intent(in) :: iterat
        character(len=*), intent(in) :: mate
        character(len=19), intent(in) :: sddyna
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: cara_elem
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=24), intent(in) :: varc_refe
        integer, intent(in) :: acti_func(*)
        character(len=19), intent(in) :: hval_incr(*)
        character(len=19), intent(in) :: hval_algo(*)
        character(len=*), intent(in) :: optioz
        character(len=19), intent(in) :: merigi
        character(len=19), intent(in) :: vefint
        aster_logical, intent(out) :: tabret(0:10)
    end subroutine merimo
end interface
