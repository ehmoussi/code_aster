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
!
#include "asterf_types.h"
!
interface
    subroutine dltini(lcrea, nume, result, depini, vitini,&
                      accini, fexini, famini, fliini, neq,&
                      numedd, inchac, ds_energy)
        use NonLin_Datastructure_type
        aster_logical :: lcrea
        integer :: nume
        character(len=8) :: result
        real(kind=8) :: depini(*)
        real(kind=8) :: vitini(*)
        real(kind=8) :: accini(*)
        real(kind=8) :: fexini(*)
        real(kind=8) :: famini(*)
        real(kind=8) :: fliini(*)
        integer :: neq
        character(len=24) :: numedd
        integer :: inchac
        type(NL_DS_Energy), intent(in) :: ds_energy
    end subroutine dltini
end interface
