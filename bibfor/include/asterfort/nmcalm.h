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
    subroutine nmcalm(typmat         , modelz, lischa, mate      , carele,&
                      ds_constitutive, instam, instap, valinc    , solalg,&
                      optmaz         , base  , meelem, ds_contact, matele,&
                      l_xthm)
        use NonLin_Datastructure_type
        character(len=6) :: typmat
        character(len=*) :: modelz
        character(len=19) :: lischa
        character(len=*) :: mate
        character(len=*) :: carele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        real(kind=8) :: instam
        real(kind=8) :: instap
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=*) :: optmaz
        character(len=1) :: base
        character(len=19) :: meelem(*)
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19) :: matele
        aster_logical, intent(in) :: l_xthm
    end subroutine nmcalm
end interface
