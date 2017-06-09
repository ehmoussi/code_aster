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
    subroutine nmfint(modele, mate  , carele, comref    , ds_constitutive,&
                      fonact, iterat, sddyna, ds_measure, valinc         ,&
                      solalg, ldccvg, vefint)
        use NonLin_Datastructure_type        
        character(len=24) :: modele
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=24) :: comref
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        integer :: fonact(*)
        integer :: iterat
        character(len=19) :: sddyna
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        integer :: ldccvg
        character(len=19) :: vefint
    end subroutine nmfint
end interface
