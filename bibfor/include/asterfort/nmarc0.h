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
interface
    subroutine nmarc0(result, modele        , ds_material    , carele   , fonact,&
                      sdcrit, sddyna        , ds_constitutive, sdcriq   ,&
                      sdpilo, list_load_resu, numarc         , time_curr)
        use NonLin_Datastructure_type
        character(len=8) :: result
        character(len=24) :: modele
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        integer :: fonact(*)
        character(len=19) :: sdcrit
        character(len=19) :: sddyna
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=24) :: sdcriq
        character(len=19) :: sdpilo
        character(len=19) :: list_load_resu
        integer :: numarc
        real(kind=8) :: time_curr
    end subroutine nmarc0
end interface
