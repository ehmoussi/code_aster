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
interface
    subroutine nmprac(fonact, lischa, numedd, numfix    , solveu     ,&
                      sddyna, ds_measure, ds_contact, ds_algopara,&
                      meelem, measse, maprec, matass    , faccvg)
        use NonLin_Datastructure_type        
        integer :: fonact(*)
        character(len=19) :: lischa
        character(len=24) :: numedd
        character(len=24) :: numfix
        character(len=19) :: solveu
        character(len=19) :: sddyna
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: maprec
        character(len=19) :: matass
        integer :: faccvg
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
    end subroutine nmprac
end interface
